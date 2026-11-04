import 'koneksi.dart';

/// Mengubah data barang yang dipilih; input kosong mempertahankan nilai sebelumnya.
void editBarang(Database db) {
  print('\n--- EDIT BARANG ---');
  final id = inputInt('ID Barang yang ingin diedit: ');
  final p = db.findProduct(id);
  if (p == null) {
    print('[ERROR] Barang tidak ditemukan!');
    return;
  }
  print('Kosongkan input untuk mempertahankan nilai lama.');
  final nama = inputString('Nama Barang [${p.namaBarang}]: ', allowEmpty: true);
  final hb = inputString('Harga Beli [${p.hargaBeli}]: ', allowEmpty: true);
  final hj = inputString('Harga Jual [${p.hargaJual}]: ', allowEmpty: true);
  final st = inputString('Stok [${p.stok}]: ', allowEmpty: true);

  if (nama.isNotEmpty) p.namaBarang = nama;
  if (hb.isNotEmpty) p.hargaBeli = int.parse(hb);
  if (hj.isNotEmpty) p.hargaJual = int.parse(hj);
  if (st.isNotEmpty) p.stok = int.parse(st);
  db.save();
  print('[OK] Barang berhasil diubah.');
}
