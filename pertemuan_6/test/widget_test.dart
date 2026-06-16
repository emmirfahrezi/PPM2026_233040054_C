import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_5/main.dart';

void main() {
  test('Catatan serializes to and from JSON', () {
    final source = Catatan(
      id: 7,
      judul: 'Tugas Mobile',
      isi: 'Selesaikan modul P5',
      kategori: 'Tugas',
      dibuatPada: DateTime.parse('2026-06-02T10:30:00Z'),
    );

    final json = source.toJson();
    final parsed = Catatan.fromJson({
      'id': json['id'],
      'judul': json['judul'],
      'isi': json['isi'],
      'kategori': json['kategori'],
      'dibuat_pada': json['dibuat_pada'],
    });

    expect(parsed.id, 7);
    expect(parsed.judul, 'Tugas Mobile');
    expect(parsed.isi, 'Selesaikan modul P5');
    expect(parsed.kategori, 'Tugas');
    expect(parsed.dibuatPada.toUtc(), DateTime.parse('2026-06-02T10:30:00Z'));
  });
}
