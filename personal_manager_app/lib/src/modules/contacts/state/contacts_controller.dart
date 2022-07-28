import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_manager_app/src/models/db_exception.dart';
import '../../../utils/select_date.dart' as selectDateUtil;
import '../models/contact.dart';
import '../models/contacts.dart';
import '../utils/contacts_db_helper.dart';

import '../constants/storage_config.dart' as storageConfig;

class ContactsController extends GetxController {
  final _db = ContactsDBHelper.instance;

  final _contacts = Contacts();

  final form = GlobalKey<FormState>();

  final pageController = PageController();

  Contacts get contacts => _contacts;

  Contact? get contact => _contacts.selectedItem;

  bool get isEdit {
    return (_contacts.selectedItem as Contact).id == null ? false : true;
  }

  @override
  void onInit() {
    super.onInit();

    getAll();
  }

  BuildContext? context;
  void addContext(BuildContext context) {
    this.context = context;
  }

  Future<void> getAll() async {
    try {
      _contacts.items = await _db.getAll();
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    } finally {
      update();
    }
  }

  Future<void> delete(int id) async {
    try {
      await _db.delete(id);

      (_contacts.items as List<Contact>)
          .removeWhere((Contact item) => item.id! == id);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      update();
    }
  }

  void reset() {
    if (_contacts.stackIndex > 0) {
      _contacts.stackIndex--;
    }

    pageController.jumpToPage(_contacts.stackIndex);

    Get.back();
    // clear data
    if (_contacts.stackIndex == 1) {
      _contacts.selectedItem = null;
      // _contacts.chosenDate = null;
      form.currentState!.reset();
    }

    update();
  }

  Future<void> selectItem(int id) async {
    try {
      final item = await _db.get(id);

      _contacts.selectedItem = item;
      // _contacts.chosenDate = item?.apptDate;

      _contacts.stackIndex = 2;
      pageController.jumpToPage(_contacts.stackIndex);

      update();
    } catch (e) {
      reset();
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> createContact() async {
    _contacts.selectedItem = Contact();
    _contacts.stackIndex = 1;

    pageController.jumpToPage(_contacts.stackIndex);
    update();
  }

  Future<void> updateRow() async {
    try {
      await _db.update(contact!);

      final index = (_contacts.items as List<Contact>)
          .indexWhere((item) => item.id == contact!.id);

      _contacts.items[index] = contact!;

      reset();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }
  }

  Future<void> addRow() async {
    try {
      final isFormValid = form.currentState!.validate();

      if (!isFormValid) {
        throw DBException("It's nesessary fill title and description.");
      }

      form.currentState!.save();

      if ((_contacts.selectedItem as Contact).birthdayDate == null) {
        throw DBException("It's nesessary select date and time.");
      }
      final insertedItem = await _db.create(_contacts.selectedItem as Contact);

      _contacts.items.insert(0, insertedItem);

      reset();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }
  }

  void setDate() async {
    try {
      final selectedDate = await selectDateUtil.selectDate(
        context!,
        contact?.birthdayDate,
      );

      if (selectedDate != null) {
        contact?.birthdayDate = selectedDate;
      }

      update();
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }
  }

  Future<void> setImage() async {
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();

      final imagePicker = ImagePicker();

      final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedImageFile == null) {
        return;
      }

      final pathDirectoryOfImages = join(
        documentDirectory.path,
        storageConfig.images,
      );

      Directory directoryOfImages = Directory(pathDirectoryOfImages);

      if (!(await directoryOfImages.exists())) {

        await directoryOfImages.create(recursive: false);
        
      } 

      final pathToImage = join(
        documentDirectory.path,
        storageConfig.images,
        pickedImageFile.name,
      );

      final newImageFile = await File(pickedImageFile.path).copy(pathToImage);

      contact!.pathToImage = pickedImageFile.path;

      update();
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }
  }
}
