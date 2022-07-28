import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_manager_app/src/models/db_exception.dart';
import 'package:personal_manager_app/src/modules/appointments/models/appointment.dart';
import 'package:personal_manager_app/src/modules/appointments/models/appointments.dart';
import 'package:personal_manager_app/src/modules/appointments/utils/appointments_db_helper.dart';
import '../../../utils/select_date.dart' as selectDateUtil;
import '../../../utils/select_time.dart' as selectTimeUtil;

class AppointmentsController extends GetxController {
  final _db = AppointmentsDBHelper.instance;

  final _appointments = Appointments();

  final form = GlobalKey<FormState>();

  final pageController = PageController();

  Appointments get appointments => _appointments;

  Appointment? get appointment => _appointments.selectedItem;

  bool get isEdit {
    return (_appointments.selectedItem as Appointment).id == null
        ? false
        : true;
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

  DateTime _currentDateInCalendar = DateTime.now();

  Future<void> getAll([DateTime? date]) async {
    try {
      // dont work if date the same
      if (_currentDateInCalendar.month == date?.month) {
        return;
      }
      print("new month");

      if (date == null) {
        _currentDateInCalendar = DateTime.now();
      } else {
        _currentDateInCalendar = date;
      }

      _appointments.items = await _db.getAll(_currentDateInCalendar);
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

      (_appointments.items as List<Appointment>)
          .removeWhere((Appointment item) => item.id! == id);

          
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      update();
    }
  }

  void reset() {
    if (_appointments.stackIndex > 0) {
      _appointments.stackIndex--;
    }

    pageController.jumpToPage(_appointments.stackIndex);

    Get.back();
    // clear data
    if (_appointments.stackIndex == 2) {
      _appointments.selectedItem = null;
      // _appointments.chosenDate = null;
      form.currentState!.reset();
    }

    update();
  }

  Future<void> selectItem(int id) async {
    try {
      final item = await _db.get(id);

      _appointments.selectedItem = item;
      // _appointments.chosenDate = item?.apptDate;

      _appointments.stackIndex = 2;
      pageController.jumpToPage(_appointments.stackIndex);

      update();

      // todo
    } catch (e) {
      reset();
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> createAppointment() async {
    _appointments.selectedItem = Appointment();
    _appointments.stackIndex = 2;

    pageController.jumpToPage(_appointments.stackIndex);
    update();
  }

  // Future<void> selectDate() async {
  //   _appointments.chosenDate = await selectDateUtil.selectDate(context!);

  //   (_appointments.selectedItem as Appointment).apptDate =
  //       _appointments.chosenDate;

  //   update();
  // }

  Future<void> updateRow() async {
    try {
      await _db.update(appointment!);

      final index = (_appointments.items as List<Appointment>)
          .indexWhere((item) => item.id == appointment!.id);

      _appointments.items[index] = appointment!;

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

      if ((_appointments.selectedItem as Appointment).apptDate == null ||
          (_appointments.selectedItem as Appointment).apptTime == null) {
        throw DBException("It's nesessary select date and time.");
      }
      final insertedItem =
          await _db.create(_appointments.selectedItem as Appointment);

      _appointments.items.insert(0, insertedItem);

      reset();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }
  }

  void setDate() async {
    try {
      final selectedDate = await selectDateUtil.selectDate(
        context!,
        appointment?.apptDate,
      );

      if (selectedDate != null) {
        appointment?.apptDate = selectedDate;
      }
      update();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }
  }

  Future<void> setTime() async {
    try {
      final selectedTime = await selectTimeUtil.selectTime(
        context!,
        appointment?.apptTime,
      );

      if (selectedTime != null) {
        appointment?.apptTime = selectedTime;
      }
      update();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
    }
  }

  List<Appointment> get listAppointmentsOfDate {
    print("listAppointmentsOfDate");

    print(_appointments.items);
    final filteredItems = (_appointments.items as List<Appointment>)
        .where((item) => item.apptDate!.day == _currentDateInCalendar.day)
        .toList();

    print("filteredItems $filteredItems");

    return filteredItems;
  }

  void showListAppointmentsOfDate(DateTime date) {
    _appointments.stackIndex = 1;

    _currentDateInCalendar = date;

    pageController.jumpToPage(_appointments.stackIndex);

    update();
  }
}
