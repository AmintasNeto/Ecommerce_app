import 'package:flutter/material.dart';

import '../Constants.dart';

class ProductSize extends StatefulWidget {
  final List sizesList;
  final Function(String) onSelected;
  final int? idSelected;

  const ProductSize({Key? key, required this.sizesList, required this.onSelected, this.idSelected}) : super(key: key);

  @override
  State<ProductSize> createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selected = 0;

  @override
  void initState(){
    _selected = widget.idSelected ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        children: [
          for (int i = 0; i < widget.sizesList.length; i++)
            GestureDetector(
              onTap: () {
                widget.onSelected("${widget.sizesList[i]}");
                setState(() {
                  _selected = i;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _selected == i
                      ? Theme.of(context).colorScheme.secondary
                      : const Color(0xFFDCDCDC),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.sizesList[i],
                  style: TextStyle(
                    fontSize: 16,
                    color: _selected == i ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
