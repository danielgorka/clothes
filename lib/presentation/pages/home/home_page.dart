import 'package:clothes/app/display_sizes.dart';
import 'package:clothes/app/keys.dart';
import 'package:clothes/app/routes/router.gr.dart';
import 'package:clothes/presentation/pages/home/widgets/navigation_scaffold.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      late final NavigationType type;
      if (constraints.maxWidth >= DisplaySizes.large) {
        type = NavigationType.extendedNavRail;
      } else if (constraints.maxWidth >= DisplaySizes.medium) {
        type = NavigationType.navRail;
      } else {
        type = NavigationType.bottomNavBar;
      }
      return NavigationScaffold(
        navigationType: type,
        items: [
          //TODO: change icons
          NavigationItem(
            label: 'Clothes',
            icon: const Icon(Icons.help_outline, key: Keys.clothesNavbarIcon),
            route: const ClothesRouter(),
          ),
          NavigationItem(
            label: 'Outfits',
            icon: const Icon(Icons.help_outline, key: Keys.outfitsNavbarIcon),
            route: const OutfitsRouter(),
          ),
          NavigationItem(
            label: 'Calendar',
            icon: const Icon(Icons.help_outline, key: Keys.calendarNavbarIcon),
            route: const CalendarRouter(),
          ),
        ],
      );
    });
  }
}
