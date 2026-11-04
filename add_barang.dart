import 'koneksi.dart';

void tambahBarang(Database db) {
  print('\n--- TAMBAH BARANG BARU ---');
  for (final c in db.categories) {
    print(' [${c.id}] ${c.namaKategori}');
  }
  final nama = inputString('Nama Barang: ');
  final kategoriId = inputInt('ID Kategori: ');
  if (db.categories.every((c) => c.id != kategoriId)) {
    print('[ERROR] Kategori tidak ditemukan!');
    return;
  }
  final hargaBeli = inputInt('Harga Beli (Rp): ');
  final hargaJual = inputInt('Harga Jual (Rp): ');
  final stok = inputInt('Stok Awal: ');

  final newId = db.nextProductId();
  final kode = 'BRG${newId.toString().padLeft(3, '0')}';
  db.products.add(Product(
    id: newId,
    kodeBarang: kode,
    namaBarang: nama,
    kategoriId: kategoriId,
    hargaBeli: hargaBeli,
    hargaJual: hargaJual,
    stok: stok,
  ));
  db.save();
  print('[OK] Barang "$nama" berhasil ditambahkan dengan kode $kode.');
}
