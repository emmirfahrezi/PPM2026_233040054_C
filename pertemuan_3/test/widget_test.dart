import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pertemuan_3/main.dart';

void main() {
  testWidgets('edit catatan memperbarui item yang ada', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Belajar Flutter'), findsOneWidget);

    await tester.tap(find.text('Belajar Flutter'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Catatan'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Catatan'), findsOneWidget);
    expect(find.text('Email pengirim'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Belajar Flutter Lanjutan',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'mahasiswa@kampus.ac.id',
    );

    await tester.tap(find.text('Update Catatan'));
    await tester.pumpAndSettle();

    expect(find.text('Belajar Flutter Lanjutan'), findsOneWidget);
    expect(find.text('Belajar Flutter'), findsNothing);
  });
}
