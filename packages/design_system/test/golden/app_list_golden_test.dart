import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

const _labels = ['Overview', 'Billing', 'Notifications'];

Widget _defaultList() => AppList(
  itemCount: _labels.length,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) => AppListRow(
    selected: index == 1,
    onTap: () {},
    child: Text(_labels[index]),
  ),
);

Widget _cardStyleList() => AppList(
  itemCount: _labels.length,
  cardStyle: true,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) => Text(_labels[index]),
);

void main() {
  group('AppList golden', () {
    testWidgets('default, second row selected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 180),
        child: SizedBox(width: 280, child: _defaultList()),
      );
      await expectLater(
        find.byType(AppList),
        matchesGoldenFile('goldens/app_list_default_light.png'),
      );
    });

    testWidgets('default, second row selected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 180),
        child: SizedBox(width: 280, child: _defaultList()),
      );
      await expectLater(
        find.byType(AppList),
        matchesGoldenFile('goldens/app_list_default_dark.png'),
      );
    });

    testWidgets('cardStyle (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 220),
        child: SizedBox(width: 280, child: _cardStyleList()),
      );
      await expectLater(
        find.byType(AppList),
        matchesGoldenFile('goldens/app_list_card_style_light.png'),
      );
    });

    testWidgets('cardStyle (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 220),
        child: SizedBox(width: 280, child: _cardStyleList()),
      );
      await expectLater(
        find.byType(AppList),
        matchesGoldenFile('goldens/app_list_card_style_dark.png'),
      );
    });
  });
}
