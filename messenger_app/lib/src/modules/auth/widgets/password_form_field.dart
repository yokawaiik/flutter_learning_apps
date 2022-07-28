import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  String label;
  String? value;
  Function onChanged;



  PasswordFormField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  late bool _isPasswordShow;

  @override
  void initState() {
    _isPasswordShow = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !_isPasswordShow,
      initialValue: widget.value,
      onChanged: (v) => widget.onChanged(v),
      validator: (v) {
        if (v == null || v.length == 0) return "Field does not to can be empty";
        if (v.length > 40 || v.length < 7)
          return "Field does not to can be more 40 symbols and less 8 symbols";

        return null;
      },
      decoration: InputDecoration(
        label: Text(widget.label),
        hintText: "********",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordShow = !_isPasswordShow;
            });
          },
          icon: Icon(
            _isPasswordShow
                ? Icons.visibility_off
                : Icons.visibility, //change icon based on boolean value
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
