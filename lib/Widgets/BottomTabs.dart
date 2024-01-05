import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  int? selectedTab;
  final Function(int) tabPressed;
  BottomTabs({Key? key, this.selectedTab, required this.tabPressed}) : super(key: key);

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int idSelected = 0;


  @override
  Widget build(BuildContext context) {
    idSelected = widget.selectedTab ?? 0;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 30)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            icon: Icons.home_outlined,
            selected: idSelected == 0,
            onPressed: () {
              widget.tabPressed(0);
            },
          ),
          BottomTabBtn(
            icon: Icons.search,
            selected: idSelected == 1,
            onPressed: () {
              widget.tabPressed(1);
            },
          ),
          BottomTabBtn(
            icon: Icons.bookmark_border,
            selected: idSelected == 2,
            onPressed: () {
              widget.tabPressed(2);
            },
          ),
          BottomTabBtn(
            icon: Icons.exit_to_app,
            selected: idSelected == 3,
            onPressed: () {
              widget.tabPressed(3);
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final IconData icon;
  final bool? selected;
  final Function() onPressed;

  const BottomTabBtn(
      {Key? key, required this.icon, this.selected, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: selected ?? false
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
            ),
          ),
        ),
        height: 70,
        width: 50,
        child: Icon(
          icon,
          color: selected ?? false
              ? Theme.of(context).colorScheme.secondary
              : Colors.black,
        ),
      ),
    );
  }
}
