import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/utility/colors.dart';
import 'package:insta/utility/tabitems.dart';

class Web extends StatefulWidget {
  const Web({Key? key}) : super(key: key);

  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<Web> {
  int _page = 0;

  late PageController pageController;

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

  changepage(int page) {

//Refers to the indexs of children 
pageController.jumpToPage(page);
    _page=page;
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'instaimg.svg',
          color: MyColors.primaryColor,
          height: 32,
        ),
        centerTitle: false,
        backgroundColor: MyColors.webBackgroundColor,
        actions: [
          IconButton(
              onPressed: () {
                changepage(0);
              },
              icon: Icon(
                Icons.home,
                color: _page == 0
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
              )),
          IconButton(
              onPressed: () {
                  changepage(1);
              },
              icon: Icon(
                Icons.search,
                color: _page == 1
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
              )),
          IconButton(
              onPressed: () {
                  changepage(2);
              },
              icon: Icon(
                Icons.add_a_photo,
                color: _page == 2
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
              )),
          IconButton(
              onPressed: () {
                  changepage(3);
              },
              icon: Icon(
                Icons.notifications_none,
                color: _page == 3
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
              )),
          IconButton(
              onPressed: () {
                  changepage(4);
              },
              icon: Icon(
                Icons.person,
                color: _page == 4
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
              )),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        //scrollDirection: Axis.horizontal,
        controller: pageController,
        onPageChanged: (int page) {
          setState(() {
          _page=page;
          });
        },
        children: homeItems,
      ),
    );
  }
}
