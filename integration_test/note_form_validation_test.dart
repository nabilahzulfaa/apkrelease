import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tugas_ketiga/note_form_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('NoteFormPage shows validation errors when fields are empty', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: NoteFormPage()));

    await tester.tap(find, text('simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Judul wajib'), findsOneWidget);
    expect(find.text('Isi wajib'), findsOneWidget);
  });
}
