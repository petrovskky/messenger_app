import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/dialogs/dialogs_page.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';
import 'package:messenger_app/profile/profile_page.dart';
import 'package:messenger_app/search/search_page.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  MainTabState createState() => MainTabState();
}

class MainTabState extends State<MainTab> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DialogsPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: LocaleKeys.dialogs.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: LocaleKeys.userSearch.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: LocaleKeys.profile.tr(),
          ),
        ],
      ),
    );
  }
}