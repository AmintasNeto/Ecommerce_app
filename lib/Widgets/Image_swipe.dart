import 'package:flutter/material.dart';

class PageSwipe extends StatefulWidget {
  final List imageList;

  const PageSwipe(this.imageList, {Key? key}) : super(key: key);

  @override
  State<PageSwipe> createState() => _PageSwipeState();
}

class _PageSwipeState extends State<PageSwipe> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (number) {
              setState((){
                _selectedPage = number;
              });
            },
            children: [
              for (int i = 0; i < widget.imageList.length; i++)
                Image.network(
                  widget.imageList[i],
                  fit: BoxFit.contain,
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i < widget.imageList.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _selectedPage == i ? 25 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
