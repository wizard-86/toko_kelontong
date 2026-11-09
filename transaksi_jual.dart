// Database, model Sale, dan helper transaksi/input/output berasal dari koneksi.dart.
import 'koneksi.dart';

/// Memproses penjualan setelah memvalidasi barang, jumlah, dan ketersediaan stok.
/// Membuat model [Sale] dan memakai [Database] serta helper dari koneksi.dart.
void menuTransaksiJual(Database db) {
  print('\n--- TRANSAKSI PENJUALAN (KASIR) ---');
  for (final p in db.products) {
    print(' [${p.id}] ${p.kodeBarang} - ${p.namaBarang} (Stok: ${p.stok}, Jual: ${formatRupiah(p.hargaJual)})');
  }
  final id = inputInt('ID Barang: ');
  final p = db.findProduct(id);
  if (p == null) {
    print('[ERROR] Barang tidak ditemukan!');
    return;
  }
  final jumlah = inputInt('Jumlah Beli Konsumen: ');
  if (jumlah <= 0) {
    print('[ERROR] Jumlah harus > 0!');
    return;
  }
  if (jumlah > p.stok) {
    print('[ERROR] Stok barang tidak mencukupi! Stok tersedia saat ini: ${p.stok} unit.');
    return;
  }

  final totalBayar = jumlah * p.hargaJual;
  final laba = (p.hargaJual - p.hargaBeli) * jumlah;

  final sale = Sale(
    id: db.nextSaleId(),
    noStruk: db.generateNoStruk(),
    tanggal: nowString(),
    barangId: p.id,
    jumlah: jumlah,
    hargaJual: p.hargaJual,
    totalBayar: totalBayar,
    laba: laba,
  );
  db.sales.add(sale);
  p.stok -= jumlah;
  db.save();

  print('\n[OK] Penjualan berhasil!');
  print('No Struk   : ${sale.noStruk}');
  print('Total Bayar: ${formatRupiah(totalBayar)}');
  print('Laba       : ${formatRupiah(laba)}');
  print('Stok baru  : ${p.stok} unit');
}
