// Database dan helper pemformatan/tampilan berasal dari koneksi.dart.
import 'koneksi.dart';

/// Menampilkan seluruh transaksi pembelian beserta jumlah total biaya kulakan.
/// Mengakses data [Database] dan helper tampilan yang diimpor dari koneksi.dart.
void menuRiwayatBeli(Database db) {
  print('\x1B[2J\x1B[0;0H');
  header('RIWAYAT TRANSAKSI PEMBELIAN (KULAKAN)');
  if (db.purchases.isEmpty) {
    print('Belum ada transaksi pembelian.');
    return;
  }
  print('${'ID'.padRight(5)}| ${'NO FAKTUR'.padRight(15)}| ${'TANGGAL'.padRight(18)}| ${'BARANG'.padRight(26)}| ${'JML'.padRight(5)}| ${'HARGA'.padRight(12)}| ${'TOTAL'.padRight(14)}| SUPLIER');
  garis(char: '-');
  int total = 0;
  for (final t in db.purchases) {
    final p = db.findProduct(t.barangId);
    final nama = p?.namaBarang ?? '(dihapus)';
    print('${t.id.toString().padRight(5)}| '
        '${t.noFaktur.padRight(15)}| '
        '${t.tanggal.padRight(18)}| '
        '${nama.padRight(26)}| '
        '${t.jumlah.toString().padRight(5)}| '
        '${formatRupiah(t.hargaBeli).padRight(12)}| '
        '${formatRupiah(t.totalBiaya).padRight(14)}| ${t.suplier}');
    total += t.totalBiaya;
  }
  garis();
  print('TOTAL MODAL KULAKAN: ${formatRupiah(total)}');
}
