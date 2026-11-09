// dart:io menyediakan stdin untuk input CLI dan exit untuk menutup aplikasi.
import 'dart:io';
// Database, input/output CLI, format angka, serta model transaksi berasal dari koneksi.dart.
import 'koneksi.dart';
// Menu pengelolaan barang berasal dari barang.dart.
import 'barang.dart';
// Menu transaksi penjualan berasal dari transaksi_jual.dart.
import 'transaksi_jual.dart';
// Menu transaksi pembelian berasal dari transaksi_beli.dart.
import 'transaksi_beli.dart';
// Menu riwayat penjualan berasal dari riwayat_jual.dart.
import 'riwayat_jual.dart';
// Menu riwayat pembelian berasal dari riwayat_beli.dart.
import 'riwayat_beli.dart';
// Menu laporan keuangan berasal dari laporan_keuangan.dart.
import 'laporan_keuangan.dart';
// Menu manajemen kategori berasal dari kategori.dart.
import 'kategori.dart';

final db = Database();

/// Memuat data melalui [Database] dari koneksi.dart, lalu menjalankan menu dan memanggil
/// fungsi-fungsi fitur yang diimpor dari berkas menu masing-masing.
void main() {
  db.load();
  while (true) {
    tampilDashboard();
    final pilihan = inputInt('Pilih menu [0-7]: ');
    switch (pilihan) {
      case 1:
        menuTransaksiJual(db);
        break;
      case 2:
        menuTransaksiBeli(db);
        break;
      case 3:
        menuRiwayatJual(db);
        break;
      case 4:
        menuRiwayatBeli(db);
        break;
      case 5:
        menuLaporanKeuangan(db);
        break;
      case 6:
        menuBarang(db);
        break;
      case 7:
        menuKategori(db);
        break;
      case 0:
        print('\nTerima kasih! Data tersimpan di ${Database.filePath}');
        exit(0);
      default:
        print('[ERROR] Pilihan tidak valid!');
    }
    print('\nTekan Enter untuk melanjutkan...');
    stdin.readLineSync();
  }
}

/// Menampilkan ringkasan stok barang dan pilihan menu utama aplikasi.
/// Menggunakan [header], [garis], dan [formatRupiah] dari koneksi.dart.
void tampilDashboard() {
  print('\x1B[2J\x1B[0;0H'); 
  header('SISTEM KASIR & KULAKAN TOKO KELONTONG (DART NATIVE CLI)');
  print('${'ID'.padRight(5)}| ${'KODE'.padRight(9)}| ${'NAMA BARANG'.padRight(29)}| ${'KATEGORI'.padRight(17)}| ${'HARGA JUAL'.padRight(14)}| STOK');
  garis(char: '-');
  for (final p in db.products) {
    print('${p.id.toString().padRight(5)}| '
        '${p.kodeBarang.padRight(9)}| '
        '${p.namaBarang.padRight(29)}| '
        '${db.namaKategori(p.kategoriId).padRight(17)}| '
        '${formatRupiah(p.hargaJual).padRight(14)}| ${p.stok} unit');
  }
  garis();
  print('''
PILIHAN MENU UTAMA:
 [1] Kasir Penjualan Barang (Kurangi Stok & Hitung Laba)
 [2] Pembelian / Kulakan Barang (Tambah Stok Otomatis)
 [3] Riwayat Transaksi Penjualan
 [4] Riwayat Transaksi Pembelian (Kulakan)
 [5] Laporan Ringkasan Keuangan Toko (Omzet & Laba)
 [6] Manajemen Master Barang (Tambah, Ubah, Hapus)
 [7] Manajemen Kategori Barang
 [0] Keluar Aplikasi''');
  garis(char: '-');
}
