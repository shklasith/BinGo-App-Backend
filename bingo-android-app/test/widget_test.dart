import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bingo_merged/app/app.dart';

void main() {
  testWidgets('merged app shows splash content on launch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BingoMergedApp());

    expect(find.text('BinGo'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });
}
