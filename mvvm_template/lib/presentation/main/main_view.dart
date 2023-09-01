import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_template/presentation/main/pages/home/view/home_view.dart';
import 'package:mvvm_template/presentation/main/pages/notifications/notifications_page.dart';
import 'package:mvvm_template/presentation/main/pages/search/search_page.dart';
import 'package:mvvm_template/presentation/main/pages/settings/settings_page.dart';
import 'package:mvvm_template/presentation/resources/strings_manager.dart';
import 'package:mvvm_template/presentation/resources/values_manager.dart';

import '../resources/color_manager.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  final List<String> _titles = [
    AppStrings.home.tr(),
    AppStrings.search.tr(),
    AppStrings.notifications.tr(),
    AppStrings.settings.tr(),
  ];

  String _title = AppStrings.home.tr();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorManager.lightGrey,
              spreadRadius: AppSize.s1,
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: _currentIndex,
          onTap: (index) => onTap(index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: AppStrings.home.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: AppStrings.search.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: AppStrings.notifications.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppStrings.settings.tr(),
            ),
          ],
        ),
      ),
    );
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = _titles[index];
    });
  }
}
