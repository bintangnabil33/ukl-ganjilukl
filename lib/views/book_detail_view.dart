import 'package:flutter/material.dart';
import 'package:ukl/controlers/book_controllers.dart';
import 'package:ukl/models/book_model.dart';

class BookDetailView extends StatefulWidget {
  final int bookIndex; // index buku
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
    var b = widget.controller.books[widget.bookIndex]; // ambil data terbaru dari controller
    Color primaryColor = Colors.blue.shade700;

    return Scaffold(
      appBar: AppBar(title: Text("Detail Buku"), backgroundColor: primaryColor),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Poster Buku
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                b.posterPath,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 18),

            // Judul Buku
            Text(
              b.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),

            // Publisher
            Text(
              b.publisher,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            SizedBox(height: 10),

            // Rating dengan bintang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(5, (i) {
                  if (i < b.voteAverage.floor()) {
                    return Icon(Icons.star, color: Colors.amber, size: 20);
                  } else if (i < b.voteAverage) {
                    return Icon(Icons.star_half, color: Colors.amber, size: 20);
                  } else {
                    return Icon(Icons.star_border, color: Colors.amber, size: 20);
                  }
                }),
                SizedBox(width: 6),
                Text(
                  b.voteAverage.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // Status Buku (dipindah di bawah bintang)
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: b.status == "Available" ? Colors.green.shade200 : Colors.orange.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                b.status,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 14),

            // Judul Deskripsi
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Deskripsi Buku",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6),

            // Deskripsi Buku
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                b.overview,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
            SizedBox(height: 25),

            // Tombol Favorit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: Icon(
                  b.isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 26,
                ),
                label: Text(
                  b.isFavorite ? "Hapus dari Favorit" : "Tambah ke Favorit",
                  style: TextStyle(fontSize: 17),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: b.isFavorite ? Colors.red : primaryColor,
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
          ],
        ),
      ),
    );
  }
}
