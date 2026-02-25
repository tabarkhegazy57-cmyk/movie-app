import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/core/appcolor.dart';
import 'package:movie_app/view/Screens/searchScreen.dart';
import 'package:movie_app/view/Screens/watchScreen.dart';

import 'HomeScreen.dart';


class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {

  int selectedIndex = 0;
  bool showBottomNav = true;

  final List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    WatchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: showBottomNav
          ? Container(
        height: 90,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.blue, width: 2),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.backGround,
          selectedItemColor: AppColors.textWhite,
          unselectedItemColor: AppColors.iconHint,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/Home.svg",
                color: selectedIndex == 0
                    ? AppColors.textWhite
                    : AppColors.iconHint,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/Search.svg",
                color: selectedIndex == 1
                    ? AppColors.textWhite
                    : AppColors.iconHint,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/Save.svg",
                color: selectedIndex == 2
                    ? AppColors.textWhite
                    : AppColors.iconHint,
              ),
              label: "Watch",
            ),
          ],
        ),
      )
          : null,
    );
  }
}