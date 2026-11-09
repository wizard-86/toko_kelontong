// dart:convert menyediakan jsonDecode dan JsonEncoder untuk membaca/menulis JSON.
import 'dart:convert';
// dart:io menyediakan File untuk penyimpanan serta stdin/stdout untuk input/output CLI.
import 'dart:io';

// ==================== MODEL ENTITAS ====================

/// Model kategori barang yang disimpan di database dan ditampilkan pada menu kategori.
class Category {
  int id;
  String namaKategori;
  String keterangan;

  /// Membuat kategori dengan ID, nama, dan keterangan yang diberikan.
  Category({required this.id, required this.namaKategori, required this.keterangan});

  /// Mengubah kategori menjadi map agar dapat disimpan sebagai JSON.
  Map<String, dynamic> toMap() => {
        'id': id,
        'namaKategori': namaKategori,
        'keterangan': keterangan,
      };

  /// Membuat kategori dari map hasil pembacaan data JSON.
  factory Category.fromMap(Map<String, dynamic> m) => Category(
        id: m['id'],
        namaKategori: m['namaKategori'],
        keterangan: m['keterangan'],
      );
}

/// Model barang yang menyimpan identitas, kategori, harga beli/jual, dan stok.
class Product {
  int id;
  String kodeBarang;
  String namaBarang;
  int kategoriId;
  int hargaBeli;
  int hargaJual;
  int stok;

  /// Membuat barang dengan identitas, kategori, harga, dan jumlah stok.
  Product({
    required this.id,
    required this.kodeBarang,
    required this.namaBarang,
    required this.kategoriId,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
  });

  /// Mengubah barang menjadi map agar dapat disimpan sebagai JSON.
  Map<String, dynamic> toMap() => {
        'id': id,
        'kodeBarang': kodeBarang,
        'namaBarang': namaBarang,
        'kategoriId': kategoriId,
        'hargaBeli': hargaBeli,
        'hargaJual': hargaJual,
        'stok': stok,
      };

  /// Membuat barang dari map hasil pembacaan data JSON.
  factory Product.fromMap(Map<String, dynamic> m) => Product(
        id: m['id'],
        kodeBarang: m['kodeBarang'],
        namaBarang: m['namaBarang'],
        kategoriId: m['kategoriId'],
        hargaBeli: m['hargaBeli'],
        hargaJual: m['hargaJual'],
        stok: m['stok'],
      );
}

/// Model transaksi pembelian atau kulakan beserta faktur, biaya, dan pemasok.
class Purchase {
  int id;
  String noFaktur;
  String tanggal;
  int barangId;
  int jumlah;
  int hargaBeli;
  int totalBiaya;
  String suplier;

  /// Membuat catatan pembelian dengan detail faktur, barang, jumlah, biaya, dan pemasok.
  Purchase({
    required this.id,
    required this.noFaktur,
    required this.tanggal,
    required this.barangId,
    required this.jumlah,
    required this.hargaBeli,
    required this.totalBiaya,
    required this.suplier,
  });

  /// Mengubah transaksi pembelian menjadi map agar dapat disimpan sebagai JSON.
  Map<String, dynamic> toMap() => {
        'id': id,
        'noFaktur': noFaktur,
        'tanggal': tanggal,
        'barangId': barangId,
        'jumlah': jumlah,
        'hargaBeli': hargaBeli,
        'totalBiaya': totalBiaya,
        'suplier': suplier,
      };

  /// Membuat transaksi pembelian dari map hasil pembacaan data JSON.
  factory Purchase.fromMap(Map<String, dynamic> m) => Purchase(
        id: m['id'],
        noFaktur: m['noFaktur'],
        tanggal: m['tanggal'],
        barangId: m['barangId'],
        jumlah: m['jumlah'],
        hargaBeli: m['hargaBeli'],
        totalBiaya: m['totalBiaya'],
        suplier: m['suplier'],
      );
}

/// Model transaksi penjualan beserta struk, nilai pembayaran, dan laba.
class Sale {
  int id;
  String noStruk;
  String tanggal;
  int barangId;
  int jumlah;
  int hargaJual;
  int totalBayar;
  int laba;

  /// Membuat catatan penjualan dengan detail struk, barang, jumlah, pembayaran, dan laba.
  Sale({
    required this.id,
    required this.noStruk,
    required this.tanggal,
    required this.barangId,
    required this.jumlah,
    required this.hargaJual,
    required this.totalBayar,
    required this.laba,
  });

  /// Mengubah transaksi penjualan menjadi map agar dapat disimpan sebagai JSON.
  Map<String, dynamic> toMap() => {
        'id': id,
        'noStruk': noStruk,
        'tanggal': tanggal,
        'barangId': barangId,
        'jumlah': jumlah,
        'hargaJual': hargaJual,
        'totalBayar': totalBayar,
        'laba': laba,
      };

  /// Membuat transaksi penjualan dari map hasil pembacaan data JSON.
  factory Sale.fromMap(Map<String, dynamic> m) => Sale(
        id: m['id'],
        noStruk: m['noStruk'],
        tanggal: m['tanggal'],
        barangId: m['barangId'],
        jumlah: m['jumlah'],
        hargaJual: m['hargaJual'],
        totalBayar: m['totalBayar'],
        laba: m['laba'],
      );
}

// ==================== SERVICE DATABASE (DAO) ====================

/// Mengelola data toko di memori serta memuat dan menyimpan data ke database.json.
/// Class ini juga menyediakan pencarian, pembuatan ID, dan nomor transaksi untuk menu.
class Database {
  static const String filePath = 'database.json';

  List<Category> categories = [];
  List<Product> products = [];
  List<Purchase> purchases = [];
  List<Sale> sales = [];

  /// Memuat data dari file JSON atau membuat dan menyimpan data awal jika file belum ada.
  void load() {
    final file = File(filePath);
    if (!file.existsSync()) {
      _seed();
      save();
      return;
    }
    final data = jsonDecode(file.readAsStringSync());
    categories = (data['categories'] as List).map((e) => Category.fromMap(e)).toList();
    products = (data['products'] as List).map((e) => Product.fromMap(e)).toList();
    purchases = (data['purchases'] as List).map((e) => Purchase.fromMap(e)).toList();
    sales = (data['sales'] as List).map((e) => Sale.fromMap(e)).toList();
  }

  /// Menyimpan seluruh kategori, barang, pembelian, dan penjualan ke file JSON.
  void save() {
    final data = {
      'categories': categories.map((e) => e.toMap()).toList(),
      'products': products.map((e) => e.toMap()).toList(),
      'purchases': purchases.map((e) => e.toMap()).toList(),
      'sales': sales.map((e) => e.toMap()).toList(),
    };
    File(filePath).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  /// Mengisi database dengan kategori dan barang contoh sebagai data awal.
  /// Dipanggil oleh [load] ketika file database belum tersedia.
  void _seed() {
    categories = [
      Category(id: 1, namaKategori: 'Sembako', keterangan: 'Kebutuhan pokok beras, minyak, gula'),
      Category(id: 2, namaKategori: 'Minuman', keterangan: 'Kopi, teh, susu, dan air mineral'),
      Category(id: 3, namaKategori: 'Makanan Ringan', keterangan: 'Biskuit, keripik, dan mie instan'),
      Category(id: 4, namaKategori: 'Kebersihan', keterangan: 'Sabun mandi, pasta gigi, deterjen'),
    ];
    products = [
      Product(id: 1, kodeBarang: 'BRG001', namaBarang: 'Beras Ramos 5kg', kategoriId: 1, hargaBeli: 65000, hargaJual: 72000, stok: 15),
      Product(id: 2, kodeBarang: 'BRG002', namaBarang: 'Minyak Goreng Sawit 1L', kategoriId: 1, hargaBeli: 14000, hargaJual: 16500, stok: 20),
      Product(id: 3, kodeBarang: 'BRG003', namaBarang: 'Gula Pasir Kristal 1kg', kategoriId: 1, hargaBeli: 15000, hargaJual: 17500, stok: 25),
      Product(id: 4, kodeBarang: 'BRG004', namaBarang: 'Kopi Kapal Api 165g', kategoriId: 2, hargaBeli: 12000, hargaJual: 14000, stok: 30),
      Product(id: 5, kodeBarang: 'BRG005', namaBarang: 'Indomie Goreng Original', kategoriId: 3, hargaBeli: 2800, hargaJual: 3500, stok: 80),
      Product(id: 6, kodeBarang: 'BRG006', namaBarang: 'Sabun Mandi Lifebuoy', kategoriId: 4, hargaBeli: 3500, hargaJual: 4500, stok: 40),
    ];
  }

  /// Menghasilkan ID kategori berikutnya, atau 1 jika belum ada kategori.
  int nextCategoryId() => categories.isEmpty ? 1 : categories.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

  /// Menghasilkan ID barang berikutnya, atau 1 jika belum ada barang.
  int nextProductId() => products.isEmpty ? 1 : products.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

  /// Menghasilkan ID pembelian berikutnya, atau 1 jika belum ada transaksi pembelian.
  int nextPurchaseId() => purchases.isEmpty ? 1 : purchases.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

  /// Menghasilkan ID penjualan berikutnya, atau 1 jika belum ada transaksi penjualan.
  int nextSaleId() => sales.isEmpty ? 1 : sales.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

  /// Mengambil nama kategori berdasarkan ID; mengembalikan tanda '-' jika tidak ditemukan.
  String namaKategori(int id) => categories.firstWhere((c) => c.id == id, orElse: () => Category(id: 0, namaKategori: '-', keterangan: '')).namaKategori;

  /// Mencari barang berdasarkan ID dan mengembalikan null jika tidak ditemukan.
  Product? findProduct(int id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Membuat nomor faktur pembelian berdasarkan bulan berjalan dan urutan transaksi.
  String generateNoFaktur() {
    final now = DateTime.now();
    final ym = '${now.year}${now.month.toString().padLeft(2, '0')}';
    final seq = (purchases.length + 1).toString().padLeft(3, '0');
    return 'PB-$ym-$seq';
  }

  /// Membuat nomor struk penjualan berdasarkan bulan berjalan dan urutan transaksi.
  String generateNoStruk() {
    final now = DateTime.now();
    final ym = '${now.year}${now.month.toString().padLeft(2, '0')}';
    final seq = (sales.length + 1).toString().padLeft(3, '0');
    return 'PJ-$ym-$seq';
  }
}

// ==================== HELPER CLI ====================

/// Memformat bilangan sebagai mata uang rupiah dengan pemisah ribuan berupa titik.
String formatRupiah(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

/// Menghasilkan tanggal dan waktu saat ini dalam format YYYY-MM-DD HH:mm.
/// Menggunakan [DateTime] dari pustaka inti Dart.
String nowString() {
  final n = DateTime.now();
  // Helper lokal untuk menambahkan nol di depan angka tanggal/waktu satu digit.
  String two(int v) => v.toString().padLeft(2, '0');
  return '${n.year}-${two(n.month)}-${two(n.day)} ${two(n.hour)}:${two(n.minute)}';
}

/// Mencetak garis pemisah dengan karakter dan panjang yang ditentukan.
void garis({String char = '=', int length = 88}) => print(char * length);

/// Mencetak judul yang dipusatkan di antara dua garis pemisah.
void header(String title) {
  garis();
  print(title.padLeft((88 + title.length) ~/ 2).padRight(88));
  garis();
}

/// Meminta input bilangan bulat dan mengulang permintaan jika input tidak valid.
int inputInt(String prompt) {
  while (true) {
    stdout.write(prompt);
    final s = stdin.readLineSync()?.trim() ?? '';
    final v = int.tryParse(s);
    if (v != null) return v;
    print('[ERROR] Input harus berupa angka!');
  }
}

/// Meminta input teks dan, kecuali diizinkan, menolak input yang kosong.
String inputString(String prompt, {bool allowEmpty = false}) {
  while (true) {
    stdout.write(prompt);
    final s = stdin.readLineSync()?.trim() ?? '';
    if (allowEmpty || s.isNotEmpty) return s;
    print('[ERROR] Input tidak boleh kosong!');
  }
}
