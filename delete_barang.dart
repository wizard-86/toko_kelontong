import 'koneksi.dart';

/// Menghapus barang setelah memeriksa keberadaan, riwayat transaksi, dan konfirmasi pengguna.
void hapusBarang(Database db) {
  print('\n--- HAPUS BARANG ---');
  final id = inputInt('ID Barang yang ingin dihapus: ');
  final p = db.findProduct(id);
  if (p == null) {
    print('[ERROR] Barang tidak ditemukan!');
    return;
  }
  final dipakaiBeli = db.purchases.any((t) => t.barangId == id);
  final dipakaiJual = db.sales.any((t) => t.barangId == id);
  if (dipakaiBeli || dipakaiJual) {
    print('[ERROR] Barang tidak bisa dihapus karena sudah memiliki riwayat transaksi!');
    return;
  }
  print('Yakin hapus "${p.namaBarang}"? (y/n)');
  final konfirmasi = inputString('Pilihan: ').toLowerCase();
  if (konfirmasi != 'y') {
    print('Dibatalkan.');
    return;
  }
  db.products.removeWhere((e) => e.id == id);
  db.save();
  print('[OK] Barang berhasil dihapus.');
}
