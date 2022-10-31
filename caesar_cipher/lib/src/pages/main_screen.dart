import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/caesar_functions.dart' as caesar_functions;

const _basicAlphabet = "абвгдежзиклмнопрстуфхцчшщьыъэюя";

class MainScreen extends StatefulWidget {
  static const String routeName = "/";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _alphabetTextEditingController = TextEditingController();
  // СУВЮЪСВЩШЩАЮУСЭЭМЦБЩБВЦЪМГЯАСУЫЦЭЩР
  // автоматизированныесистемыуправления
  final _inputTextEditingController = TextEditingController();
  final _offsetTextEditingController = TextEditingController();

  @override
  void initState() {
    _alphabetTextEditingController.text = _basicAlphabet;
    _offsetTextEditingController.text = '1';
    super.initState();
  }

  List<String> decryptedResults = [];

  // just a simple validation
  bool _validate(BuildContext context) {
    if (_inputTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill in the field with text!'),
        ),
      );

      return false;
    }
    if (_offsetTextEditingController.text.isEmpty) {
      const ScaffoldMessenger(
        child: SnackBar(
          content: Text('Fill in the field with offset!'),
        ),
      );
      return false;
    }
    return true;
  }

  // handler for encrypt
  void _encrypt(BuildContext context) {
    if (!_validate(context)) return;
    var text = _inputTextEditingController.text;
    var alphabet = _alphabetTextEditingController.text;
    var offset = int.parse(_offsetTextEditingController.text);

    setState(() {
      decryptedResults.clear();
      decryptedResults.add(caesar_functions.encrypt(text, offset, alphabet));
    });
  }

  // handler for decrypt by enumeration method
  void _decrypt(BuildContext context) {
    if (!_validate(context)) return;
    var text = _inputTextEditingController.text;
    var alphabet = _alphabetTextEditingController.text;
    var offset = 1;

    setState(() {
      decryptedResults = caesar_functions.decrypt(text, offset, alphabet);
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _alphabetTextEditingController,
                decoration: const InputDecoration(
                  labelText: 'Current alphabet',
                ),
                minLines: 1,
                maxLines: 12,
              ),
              TextField(
                controller: _inputTextEditingController,
                decoration: const InputDecoration(
                  labelText: 'Text for encrypt or decrypt',
                ),
                minLines: 1,
                maxLines: 12,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _offsetTextEditingController,
                decoration: const InputDecoration(
                  labelText: 'Offset',
                ),
                onChanged: (value) {
                  if (value == "") return;
                  if (int.parse(value) >
                      _alphabetTextEditingController.text.length) return;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 2,
                minLines: 1,
                maxLines: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _encrypt(context),
                    child: const Text("Encrypt"),
                  ),
                  ElevatedButton(
                    onPressed: () => _decrypt(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text("Decrypt"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Results",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: decryptedResults.isEmpty
                    ? const Center(
                        child: Text('No results, because you did nothing.'))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: decryptedResults.length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) => SizedBox(
                          height: 24,
                          child: ListTile(
                            minVerticalPadding: 1,
                            contentPadding: EdgeInsets.all(1),
                            leading: Text('${index + 1}'),
                            title: Text(decryptedResults[index]),
                            dense: true,
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
