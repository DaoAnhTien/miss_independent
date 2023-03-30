import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/modules/events/screens/events_screen.dart';
import 'package:miss_independent/modules/home/screens/home_screen.dart';
import 'package:miss_independent/modules/members/screens/members_screen.dart';
import 'package:miss_independent/modules/mi_forum/screens/mi_forum_screen.dart';
import 'package:miss_independent/modules/shop/screens/category_screen.dart';

import '../../common/constants/images.dart';
import '../../common/constants/routes.dart';
import '../../generated/l10n.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/drawer.dart';
import '../shop/bloc/cart_cubit.dart';
import '../shop/bloc/cart_state.dart';
import '../shop/widgets/icon_btn_with_counter.dart';

enum MainTabBarType { home, shop, forum, event, members }

class MainTabBar extends StatefulWidget {
  const MainTabBar({Key? key}) : super(key: key);

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  MainTabBarType _selectedTab = MainTabBarType.home;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const CachedImage(
            url: kHeaderLogo, fit: BoxFit.contain, height: 46),
        leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: const Icon(CupertinoIcons.text_alignleft, size: 23)),
        actions: _selectedTab == MainTabBarType.shop
            ? _renderCartIcon()
            : [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(kNotificationsRouter);
                    },
                    icon: const Icon(CupertinoIcons.bell, size: 23)),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(kFriendRequestRoute);
                    },
                    icon: const Icon(CupertinoIcons.ellipses_bubble, size: 23))
              ],
      ),
      drawer: const DrawerApp(),
      body: _renderContent(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: kGreyColor,
        currentIndex: _selectedTab.index,
        onTap: _onSelectTab,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.home, size: 22),
              label: S.of(context).home),
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.bag, size: 22),
              label: S.of(context).shop),
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.group, size: 22),
              label: S.of(context).forum),
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.calendar, size: 22),
              label: S.of(context).events),
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.person_2, size: 22),
              label: S.of(context).members),
        ],
      ),
    );
  }

  void _onSelectTab(int index) {
    switch (index) {
      case 0:
        _selectedTab = MainTabBarType.home;
        break;
      case 1:
        _selectedTab = MainTabBarType.shop;
        break;
      case 2:
        _selectedTab = MainTabBarType.forum;
        break;
      case 3:
        _selectedTab = MainTabBarType.event;
        break;
      case 4:
        _selectedTab = MainTabBarType.members;
        break;
    }
    setState(() {});
  }

  Widget _renderContent() {
    switch (_selectedTab) {
      case MainTabBarType.home:
        return const HomeScreen();
      case MainTabBarType.shop:
        return const CategoryScreen();
      case MainTabBarType.forum:
        return const MiForumScreen();
      case MainTabBarType.event:
        return const EventsScreen();
      case MainTabBarType.members:
        return const MembersScreen();
      default:
        return const SizedBox();
    }
  }

  List<Widget> _renderCartIcon() {
    return [
      BlocBuilder<CartCubit, CartState>(
        builder: (context, state) => IconBtnWithCounter(
          press: () => Navigator.pushNamed(context, kCartRoute),
          icon: const Icon(CupertinoIcons.cart),
          numOfitem: state.carts?.length ?? 0,
        ),
      ),
      const SizedBox(width: 8),
    ];
  }
}
