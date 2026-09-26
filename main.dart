import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKasir());
}

class AplikasiKasir extends StatelessWidget {
  const AplikasiKasir({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kasir Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HalamanKasir(),
    );
  }
}

class Produk {
  final String nama;
  final double harga;

  Produk({required this.nama, required this.harga});
}

class ItemKeranjang {
  final Produk produk;
  int jumlah;

  ItemKeranjang({required this.produk, this.jumlah = 1});
}

class HalamanKasir extends StatefulWidget {
  const HalamanKasir({super.key});

  @override
  State<HalamanKasir> createState() => _HalamanKasirState();
}

class _HalamanKasirState extends State<HalamanKasir> {
  // Daftar Produk Toko
  final List<Produk> daftarProduk = [
    Produk(nama: 'Kopi Hitam', harga: 10000),
    Produk(nama: 'Es Teh Manis', harga: 5000),
    Produk(nama: 'Roti Bakar', harga: 15000),
    Produk(nama: 'Nasi Goreng', harga: 20000),
    Produk(nama: 'Air Mineral', harga: 4000),
  ];

  final List<ItemKeranjang> keranjang = [];
  final TextEditingController bayarController = TextEditingController();
  double kembalian = 0;

  void tambahKeKeranjang(Produk produk) {
    setState(() {
      int index = keranjang.indexWhere((item) => item.produk.nama == produk.nama);
      if (index != -1) {
        keranjang[index].jumlah++;
      } else {
        keranjang.add(ItemKeranjang(produk: produk));
      }
    });
  }

  double hitungTotal() {
    return keranjang.fold(0, (total, item) => total + (item.produk.harga * item.jumlah));
  }

  void hitungKembalian() {
    double total = hitungTotal();
    double uangBayar = double.tryParse(bayarController.text) ?? 0;
    setState(() {
      kembalian = uangBayar - total;
    });
  }

  void resetTransaksi() {
    setState(() {
      keranjang.clear();
      bayarController.clear();
      kembalian = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalHarga = hitungTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetTransaksi,
            tooltip: 'Transaksi Baru',
          )
        ],
      ),
      body: Column(
        children: [
          // Daftar Produk
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Pilih Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daftarProduk.length,
              itemBuilder: (context, index) {
                final produk = daftarProduk[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () => tambahKeKeranjang(produk),
                    child: Container(
                      width: 110,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(produk.nama, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text('Rp ${produk.harga.toStringAsFixed(0)}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          // Keranjang Belanja
          const Text('Rincian Belanja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: keranjang.isEmpty
                ? const Center(child: Text('Keranjang masih kosong'))
                : ListView.builder(
                    itemCount: keranjang.length,
                    itemBuilder: (context, index) {
                      final item = keranjang[index];
                      return ListTile(
                        title: Text(item.produk.nama),
                        subtitle: Text('Rp ${item.produk.harga.toStringAsFixed(0)} x ${item.jumlah}'),
                        trailing: Text('Rp ${(item.produk.harga * item.jumlah).toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
          ),
          // Area Pembayaran
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Rp ${totalHarga.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bayarController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Uang Pembayaran (Rp)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => hitungKembalian(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kembalian:', style: TextStyle(fontSize: 16)),
                    Text(
                      'Rp ${kembalian < 0 ? 0 : kembalian.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kembalian < 0 ? Colors.red : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}