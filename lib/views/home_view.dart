import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ukl/controlers/book_controllers.dart';
import 'package:ukl/models/book_model.dart';
import 'book_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required BookController controller});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BookController controller = BookController(); // Singleton

  TextEditingController searchCtrl = TextEditingController();
  List<BookModel> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    filteredBooks = controller.books; // awal tampil semua buku

    searchCtrl.addListener(() {
      filterBooks(searchCtrl.text);
    });
  }

  void filterBooks(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredBooks = controller.books;
      } else {
        filteredBooks = controller.books
            .where((b) =>
                b.title.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.blue.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perpustakaan Digital"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 SEARCH BAR
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  hintText: "Cari judul buku...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Jika tidak mencari → tampil halaman default
            if (searchCtrl.text.isEmpty) ...[
              CarouselSlider(
                items: controller.books.map((b) {
                  int index = controller.books.indexOf(b);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailView(
                            bookIndex: index,
                            controller: controller,
                            book: b,
                          ),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        b.posterPath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  viewportFraction: .82,
                ),
              ),

              section("🔥 Populer"),
              horizontalListPopuler(
                controller.books.where((b) => b.voteAverage >= 4.0).toList(),
              ),

              section("❤️ Favorit Kamu"),
              horizontalList(
                controller.books.where((b) => b.isFavorite).toList(),
              ),

              section("📚 Semua Buku"),
              gridBuku(filteredBooks),
            ]
            else ...[
              section("🔎 Hasil Pencarian"),
              if (filteredBooks.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Buku tidak ditemukan 😢",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                )
              else
                gridBuku(filteredBooks),
            ],
          ],
        ),
      ),
    );
  }

  // ---------- Section Title ----------
  Widget section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
    );
  }

  // ---------- Horizontal List ----------
  Widget horizontalList(List<BookModel> books) {
    if (books.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text("Belum ada buku di bagian ini."),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (_, i) {
          var b = books[i];
          int index = controller.books.indexOf(b);
          return bookCard(b, index);
        },
      ),
    );
  }

  // ---------- Populer Horizontal ----------
  Widget horizontalListPopuler(List<BookModel> books) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (_, i) {
          var b = books[i];
          int index = controller.books.indexOf(b);
          return smallBookCard(b, index);
        },
      ),
    );
  }

  // -------- Small Card Populer --------
  Widget smallBookCard(BookModel b, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailView(
              bookIndex: index,
              controller: controller,
              book: b,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                b.posterPath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // Judul
            Text(
              b.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            // ⭐ VoteAverage
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 3),
                Text(
                  b.voteAverage.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Overview
            Text(
              b.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Normal Book Card ----------
  Widget bookCard(BookModel b, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailView(
              bookIndex: index,
              controller: controller,
              book: b,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      b.posterPath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.toggleFavorite(index);
                        });
                      },
                      child: Icon(
                        b.isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 24,
                        color: b.isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              b.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Grid View ----------
  Widget gridBuku(List<BookModel> books) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .68,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (_, i) {
        var b = books[i];
        int index = controller.books.indexOf(b);
        return bookCard(b, index);
      },
    );
  }
}
