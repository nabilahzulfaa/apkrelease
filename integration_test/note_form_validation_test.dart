import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// Ganti ke nama package sesuai pubspec.yaml kamu (tugas_ketiga)
import 'package:tugas_ketiga/note_form_page.dart';

void main() {
  // Wajib untuk inisialisasi pengujian integrasi
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('NoteFormPage shows validation errors when fields are empty', (
    tester,
  ) async {
    // 1. Memuat halaman form ke dalam lingkungan test
    await tester.pumpWidget(const MaterialApp(home: NoteFormPage()));

    // 2. Simulasi menekan tombol "Simpan" tanpa isi data apapun
    final finder = find.text('Simpan');
    await tester.tap(finder);

    // 3. Menunggu hingga animasi validasi selesai
    await tester.pumpAndSettle();

    // 4. Verifikasi bahwa pesan error muncul (sesuai gambar materi kamu)
    expect(find.text('Judul wajib'), findsOneWidget);
    expect(find.text('Isi wajib'), findsOneWidget);
  });
}
