import 'package:clothes/app/routes/router.gr.dart';
import 'package:clothes/app/utils/display_sizes.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/app/widgets/navigation_scaffold.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  NavigationType _getNavigationType(BoxConstraints constraints) {
    if (constraints.maxWidth >= DisplaySizes.large) {
      return NavigationType.extendedNavRail;
    } else if (constraints.maxWidth >= DisplaySizes.medium) {
      return NavigationType.navRail;
    } else {
      return NavigationType.bottomNavBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return NavigationScaffold(
        navigationType: _getNavigationType(constraints),
        items: [
          //TODO: change icons
          NavigationItem(
            label: context.l10n.clothes,
            icon: const Icon(Icons.help_outline, key: Keys.clothesNavbarIcon),
            route: const ClothesRouter(),
          ),
          NavigationItem(
            label: context.l10n.outfits,
            icon: const Icon(Icons.help_outline, key: Keys.outfitsNavbarIcon),
            route: const OutfitsRouter(),
          ),
          NavigationItem(
            label: context.l10n.calendar,
            icon: const Icon(Icons.help_outline, key: Keys.calendarNavbarIcon),
            route: const CalendarRouter(),
          ),
        ],
      );
    });
  }
}