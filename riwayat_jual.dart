// Database dan helper pemformatan/tampilan berasal dari koneksi.dart.
import 'koneksi.dart';

/// Menampilkan transaksi penjualan beserta akumulasi omzet dan laba.
/// Mengakses data [Database] dan helper tampilan yang diimpor dari koneksi.dart.
void menuRiwayatJual(Database db) {
  print('\x1B[2J\x1B[0;0H');
  header('RIWAYAT TRANSAKSI PENJUALAN');
  if (db.sales.isEmpty) {
    print('Belum ada transaksi penjualan.');
    return;
  }
  print('${'ID'.padRight(5)}| ${'NO STRUK'.padRight(15)}| ${'TANGGAL'.padRight(18)}| ${'BARANG'.padRight(26)}| ${'JML'.padRight(5)}| ${'TOTAL BAYAR'.padRight(14)}| LABA');
  garis(char: '-');
  int totalOmzet = 0, totalLaba = 0;
  for (final t in db.sales) {
    final p = db.findProduct(t.barangId);
    final nama = p?.namaBarang ?? '(dihapus)';
    print('${t.id.toString().padRight(5)}| '
        '${t.noStruk.padRight(15)}| '
        '${t.tanggal.padRight(18)}| '
        '${nama.padRight(26)}| '
        '${t.jumlah.toString().padRight(5)}| '
        '${formatRupiah(t.totalBayar).padRight(14)}| ${formatRupiah(t.laba)}');
    totalOmzet += t.totalBayar;
    totalLaba += t.laba;
  }
  garis();
  print('TOTAL OMZET : ${formatRupiah(totalOmzet)}');
  print('TOTAL LABA  : ${formatRupiah(totalLaba)}');
}
