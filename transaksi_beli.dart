import 'koneksi.dart';

/// Mencatat pembelian barang, memperbarui stok dan harga beli, lalu menyimpan perubahan.
void menuTransaksiBeli(Database db) {
  print('\n--- TRANSAKSI PEMBELIAN (KULAKAN) ---');
  for (final p in db.products) {
    print(' [${p.id}] ${p.kodeBarang} - ${p.namaBarang} (Stok: ${p.stok}, Beli: ${formatRupiah(p.hargaBeli)})');
  }
  final id = inputInt('ID Barang: ');
  final p = db.findProduct(id);
  if (p == null) {
    print('[ERROR] Barang tidak ditemukan!');
    return;
  }
  final jumlah = inputInt('Jumlah Beli: ');
  if (jumlah <= 0) {
    print('[ERROR] Jumlah harus > 0!');
    return;
  }
  final hargaBeli = inputInt('Harga Beli per unit (Rp): ');
  final suplier = inputString('Nama Supplier: ');
  final totalBiaya = jumlah * hargaBeli;

  final purchase = Purchase(
    id: db.nextPurchaseId(),
    noFaktur: db.generateNoFaktur(),
    tanggal: nowString(),
    barangId: p.id,
    jumlah: jumlah,
    hargaBeli: hargaBeli,
    totalBiaya: totalBiaya,
    suplier: suplier,
  );
  db.purchases.add(purchase);

  p.stok += jumlah;
  p.hargaBeli = hargaBeli;
  db.save();

  print('\n[OK] Pembelian berhasil!');
  print('No Faktur  : ${purchase.noFaktur}');
  print('Total Biaya: ${formatRupiah(totalBiaya)}');
  print('Stok baru  : ${p.stok} unit');
}
