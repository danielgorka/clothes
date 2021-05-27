import 'package:auto_route/auto_route.dart';
import 'package:clothes/app/keys.dart';
import 'package:clothes/app/routes/router.gr.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        ClothesRouter(),
        OutfitsRouter(),
        CalendarRouter(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            //TODO: change icons
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline, key: Keys.clothesNavbarIcon),
              label: 'Clothes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline, key: Keys.outfitsNavbarIcon),
              label: 'Outfits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline, key: Keys.calendarNavbarIcon),
              label: 'Calendar',
            ),
          ],
        );
      },
    );
  }
}
