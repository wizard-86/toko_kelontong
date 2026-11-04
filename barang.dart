import 'dart:io';
import 'koneksi.dart';
import 'add_barang.dart';
import 'edit_barang.dart';
import 'delete_barang.dart';

void menuBarang(Database db) {
  while (true) {
    print('\x1B[2J\x1B[0;0H');
    header('MANAJEMEN MASTER BARANG');
    print('${'ID'.padRight(5)}| ${'KODE'.padRight(9)}| ${'NAMA BARANG'.padRight(29)}| ${'KATEGORI'.padRight(17)}| ${'BELI'.padRight(12)}| ${'JUAL'.padRight(12)}| STOK');
    garis(char: '-');
    for (final p in db.products) {
      print('${p.id.toString().padRight(5)}| '
          '${p.kodeBarang.padRight(9)}| '
          '${p.namaBarang.padRight(29)}| '
          '${db.namaKategori(p.kategoriId).padRight(17)}| '
          '${formatRupiah(p.hargaBeli).padRight(12)}| '
          '${formatRupiah(p.hargaJual).padRight(12)}| ${p.stok}');
    }
    garis();
    print(' [1] Tambah Barang   [2] Edit Barang   [3] Hapus Barang   [0] Kembali');
    final c = inputInt('Pilih [0-3]: ');
    if (c == 0) return;
    if (c == 1) tambahBarang(db);
    if (c == 2) editBarang(db);
    if (c == 3) hapusBarang(db);
  }
}
