import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/utility/colors.dart';
import 'package:insta/utility/tabitems.dart';

class Mobile extends StatefulWidget {
  const Mobile({ Key? key }) : super(key: key);

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
   int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: MyColors.mobileBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? MyColors.primaryColor : MyColors.secondaryColor,
            ),
            label: '',
            backgroundColor: MyColors.primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_page == 1) ? MyColors.primaryColor : MyColors.secondaryColor,
              ),
              label: '',
              backgroundColor: MyColors.primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_a_photo,
                color: (_page == 2) ? MyColors.primaryColor : MyColors.secondaryColor,
              ),
              label: '',
              backgroundColor: MyColors.primaryColor),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: (_page == 3) ? MyColors.primaryColor : MyColors.secondaryColor,
            ),
            label: '',
            backgroundColor: MyColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (_page == 4) ?MyColors.primaryColor :MyColors.secondaryColor,
            ),
            label: '',
            backgroundColor: MyColors.primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}