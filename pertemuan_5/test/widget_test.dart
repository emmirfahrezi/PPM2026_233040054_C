import 'package:flutter_test/flutter_test.dart';

import 'package:pertemuan_5/main.dart';

void main() {
  testWidgets('MyApp shows the notes home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Catatan Mahasiswa'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
  });
}
