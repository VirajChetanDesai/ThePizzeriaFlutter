import 'package:flutter/material.dart';
import 'package:pizzeria/Users/fragments/favourite_fragment_screen.dart';
import 'package:pizzeria/Users/fragments/home_fragment_screen.dart';
import 'package:pizzeria/Users/fragments/order_fragment_screen.dart';
import 'package:pizzeria/Users/fragments/profile_fragment_screen.dart';
import 'package:pizzeria/user_preferences/current_user.dart';
import 'package:get/get.dart';
class DashBoardOfFragments extends StatelessWidget {
  currentUser _rememberCurrentUser = Get.put(currentUser());
  final List<Widget> _fragmentScreens = [
    HomeFragmentScreen(),
    FavouriteFragmentScreen(),
    OrderFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  final List _navbarButtonProperties = [
    {
      "active_icon":Icons.home,
    "inactive_icon":Icons.home_outlined,
    "label":"Home",
    },
    {
      "active_icon":Icons.favorite,
      "inactive_icon":Icons.favorite_outline,
      "label":"Favourites"
    },
    {
      "active_icon":Icons.inventory_2,
    "inactive_icon":Icons.inventory_2_outlined,
    "label":"Order"
    },
    {
      "active_icon":Icons.person,
      "inactive_icon":Icons.person_outlined,
      "label":"Profile"
    }
  ];
  RxInt _indexNumber = 0.obs;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: currentUser(),
      initState: (currentState){
          _rememberCurrentUser.GetUserInfo();
      },
      builder: (controller){
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Obx(
                  ()=> _fragmentScreens[_indexNumber.value],
              ),
            ),
            bottomNavigationBar: Obx(()=>
              BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value){
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.lightBlueAccent,
                items: List.generate(4, (index){
                  var navbtnprop = _navbarButtonProperties[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.black,
                    icon: Icon(navbtnprop['inactive_icon'],color: Colors.lightBlueAccent[200],),
                    activeIcon: Icon(navbtnprop['active_icon'],color: Colors.white,),
                    label: navbtnprop['label'],
                  );
                }),
              )
            ),
          );
      },
    );
  }
}
