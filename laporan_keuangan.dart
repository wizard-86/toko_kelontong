// Database dan helper format rupiah/tampilan berasal dari koneksi.dart.
import 'koneksi.dart';

/// Menghitung dan menampilkan ringkasan keuangan serta stok/aset untuk setiap kategori.
/// Mengakses [Database] dan [formatRupiah] yang diimpor dari koneksi.dart.
void menuLaporanKeuangan(Database db) {
  print('\x1B[2J\x1B[0;0H');
  header('LAPORAN RINGKASAN KEUANGAN TOKO');

  final totalPembelian = db.purchases.fold<int>(0, (s, e) => s + e.totalBiaya);
  final totalOmzet = db.sales.fold<int>(0, (s, e) => s + e.totalBayar);
  final totalLaba = db.sales.fold<int>(0, (s, e) => s + e.laba);
  final totalAset = db.products.fold<int>(0, (s, e) => s + (e.hargaBeli * e.stok));

  print(' Total Pengeluaran Kulakan (Modal) : ${formatRupiah(totalPembelian)}');
  print(' Total Penerimaan Penjualan (Omzet): ${formatRupiah(totalOmzet)}');
  print(' Total Keuntungan Bersih (Laba)    : ${formatRupiah(totalLaba)}');
  print(' Total Valuasi Aset Stok Toko      : ${formatRupiah(totalAset)}');
  garis();
  print(' Jumlah Kategori : ${db.categories.length}');
  print(' Jumlah Barang   : ${db.products.length}');
  print(' Transaksi Beli  : ${db.purchases.length}');
  print(' Transaksi Jual  : ${db.sales.length}');
  garis();

  print('\nREKAP STOK & ASET PER KATEGORI:');
  garis(char: '-');
  print('${'KATEGORI'.padRight(20)}| ${'JML BARANG'.padRight(12)}| ${'TOTAL STOK'.padRight(12)}| VALUASI ASET');
  garis(char: '-');
  for (final c in db.categories) {
    final list = db.products.where((p) => p.kategoriId == c.id).toList();
    final stok = list.fold<int>(0, (s, e) => s + e.stok);
    final aset = list.fold<int>(0, (s, e) => s + e.stok * e.hargaBeli);
    print('${c.namaKategori.padRight(20)}| '
        '${list.length.toString().padRight(12)}| '
        '${stok.toString().padRight(12)}| ${formatRupiah(aset)}');
  }
}
