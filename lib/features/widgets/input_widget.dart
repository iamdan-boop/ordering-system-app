import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({
    Key? key,
    required this.hintText,
    required this.onChange,
    this.obscureText = false,
    this.defaultText,
  }) : super(key: key);

  final String hintText;
  final Function(String?) onChange;
  final bool obscureText;
  final String? defaultText;

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepOrange),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: TextFormField(
        initialValue: widget.defaultText,
        obscureText: widget.obscureText,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
