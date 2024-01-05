import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool outlineBtn;
  final bool isLoading;

  const CustomBtn(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.outlineBtn,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: outlineBtn ? Colors.transparent : Colors.black),
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        height: 65,
        child: Stack(
          children: [
            Center(
              child: Visibility(
                visible: !isLoading,
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 16,
                      color: outlineBtn ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Center(
              child: Visibility(
                visible: isLoading,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: outlineBtn ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
