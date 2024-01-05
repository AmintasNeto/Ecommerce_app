import 'package:ecommerce_app/Constants.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) OnChanged;
  final Function(String) OnSubmited;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final bool? isPassword;

  const CustomInput(
      {Key? key,
      required this.hintText,
      required this.OnChanged,
      required this.OnSubmited,
      this.focusNode,
      required this.textInputAction,
      this.isPassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(5)),
      child: TextField(
        obscureText: isPassword ?? false,
        focusNode: focusNode,
        onChanged: OnChanged,
        onSubmitted: OnSubmited,
        textInputAction: textInputAction,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),),
        style: Constants.regularDarkText,
      ),
    );
  }
}
