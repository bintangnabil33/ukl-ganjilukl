import 'package:flutter/material.dart';
import 'package:ukl/controlers/book_controllers.dart';
import 'package:ukl/models/book_model.dart';

class BookDetailView extends StatefulWidget {
  final int bookIndex;
  final BookController controller;

  const BookDetailView({
    super.key,
    required this.bookIndex,
    required this.controller, required BookModel book,
  });

  @override
  State<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView> {
  @override
  Widget build(BuildContext context) {
    var b = widget.controller.books[widget.bookIndex];
    Color primaryColor = Colors.blue.shade800;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detail Buku"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Poster Buku
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(b.posterPath, height: 270),
              ),
            ),
            const SizedBox(height: 18),

            // Konten Putih
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 🔥 Center semua
                children: [
                  // Judul Buku 📚
                  Text(
                    b.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // ⭐
                  ),
                  const SizedBox(height: 4),

                  // Penerbit
                  Text(
                    b.publisher,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center, // ⭐
                  ),
                  const SizedBox(height: 12),

                  // Rating ⭐⭐⭐⭐⭐
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(5, (i) {
                        if (i < b.voteAverage.floor()) {
                          return const Icon(Icons.star, color: Colors.amber);
                        } else if (i < b.voteAverage) {
                          return const Icon(Icons.star_half, color: Colors.amber);
                        } else {
                          return const Icon(Icons.star_border, color: Colors.amber);
                        }
                      }),
                      const SizedBox(width: 6),
                      Text(
                        b.voteAverage.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // SINOPSIS 📖
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sinopsis Buku",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Overview: ${b.overview}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // STATUS 📌
                  Column(
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center, // ⭐
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: b.status == "Available"
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          b.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // ⭐
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ❤️ Tombol Favorit
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        b.isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 26,
                      ),
                      label: Text(
                        b.isFavorite
                            ? "Hapus dari Favorit"
                            : "Tambah ke Favorit",
                        style: const TextStyle(fontSize: 17),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            b.isFavorite ? Colors.red : primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.controller.toggleFavorite(widget.bookIndex);
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
