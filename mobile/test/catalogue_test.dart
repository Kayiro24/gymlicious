import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../catalogue/main.dart';

void main() {
  testWidgets('every catalogue entry renders at phone and tablet, 200% text', (
    tester,
  ) async {
    // Progress rings animate forever, so pump fixed frames instead of settling.
    Future<void> settle() async {
      for (var frame = 0; frame < 4; frame++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
    }

    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    for (final size in [const Size(390, 844), const Size(1280, 800)]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(const CatalogueApp());
      await tester.tap(find.byTooltip('Text size 200%'));
      await settle();
      final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold));
      final count = tester.widgetList(find.byType(ListTile)).length;
      scaffold.openDrawer();
      await settle();
      final entries = tester.widgetList<ListTile>(find.byType(ListTile));
      final total = entries.length - count;
      for (var index = 0; index < total; index++) {
        if (!scaffold.isDrawerOpen) {
          scaffold.openDrawer();
          await settle();
        }
        await tester.tap(find.byType(ListTile).at(index), warnIfMissed: false);
        await settle();
        expect(tester.takeException(), isNull, reason: 'entry $index at $size');
      }
    }
  });
}
