import 'koneksi.dart';

void menuKategori(Database db) {
  while (true) {
    print('\x1B[2J\x1B[0;0H');
    header('MANAJEMEN KATEGORI BARANG');
    print('${'ID'.padRight(5)}| ${'NAMA KATEGORI'.padRight(20)}| ${'KETERANGAN'.padRight(35)}| JML BARANG');
    garis(char: '-');
    for (final c in db.categories) {
      final jml = db.products.where((p) => p.kategoriId == c.id).length;
      print('${c.id.toString().padRight(5)}| '
          '${c.namaKategori.padRight(20)}| '
          '${c.keterangan.padRight(35)}| $jml');
    }
    garis();
    print(' [1] Tambah Kategori   [2] Hapus Kategori   [0] Kembali');
    final c = inputInt('Pilih [0-2]: ');
    if (c == 0) return;
    if (c == 1) {
      final nama = inputString('Nama Kategori: ');
      final ket = inputString('Keterangan: ');
      db.categories.add(Category(id: db.nextCategoryId(), namaKategori: nama, keterangan: ket));
      db.save();
      print('[OK] Kategori ditambahkan.');
    } else if (c == 2) {
      final id = inputInt('ID Kategori yang dihapus: ');
      final dipakai = db.products.any((p) => p.kategoriId == id);
      if (dipakai) {
        print('[ERROR] Kategori masih dipakai oleh barang, tidak dapat dihapus!');
        continue;
      }
      db.categories.removeWhere((e) => e.id == id);
      db.save();
      print('[OK] Kategori dihapus.');
    }
  }
}
