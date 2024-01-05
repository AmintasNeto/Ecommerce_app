import 'package:ecommerce_app/Tabs/Exit_tab.dart';
import 'package:ecommerce_app/Tabs/Homepage_tab.dart';
import 'package:ecommerce_app/Tabs/Saved_tab.dart';
import 'package:ecommerce_app/Tabs/Search_tab.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Widgets/BottomTabs.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late PageController _tabsPageControler;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabsPageControler = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PageView(
                controller: _tabsPageControler,
                onPageChanged: (number) {
                  setState(() {
                    _selectedTab = number;
                  });
                },
                children: [
                  HomepageTab(),
                  SearchTab(),
                  SavedTab(),
                  ExitTab(),
                ],
              ),
            ),
            Center(
              child: BottomTabs(
                selectedTab: _selectedTab,
                tabPressed: (number) {
                  _tabsPageControler.animateToPage(
                    number,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
