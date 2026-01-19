import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Ganti ke nama package proyek Anda
import 'package:tugas_ketiga/note.dart';

void main() {
  // Baris ini wajib ada
  test('noteColorByDeadline returns correct color by deadline range', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Test overdue (lewat deadline) -> Merah Tua
    final overdue = today.subtract(const Duration(days: 1));
    expect(noteColorByDeadline(overdue), Colors.red.shade900);

    // 2. Test besok (hampir deadline) -> Merah Terang
    final dueTomorrow = today.add(const Duration(days: 1));
    expect(noteColorByDeadline(dueTomorrow), Colors.red.shade400);

    // 3. Test tanpa deadline (null) -> Kuning
    expect(noteColorByDeadline(null), Colors.yellow.shade300);
  });
} // Pastikan kurung kurawal penutup ini ada
