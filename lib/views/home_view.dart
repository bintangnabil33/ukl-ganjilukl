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

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.blue.shade700;

    return Scaffold(
      appBar: AppBar(
        title: Text("Perpustakaan Digital"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------------------
            // CAROUSEL SLIDER
            // ------------------------------------------------------------
            CarouselSlider(
              items: controller.books.map((b) {
                int index = controller.books.indexOf(b);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailView(
                            bookIndex: index, controller: controller, book: b,),
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
            gridBuku(controller.books),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------
  Widget section(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        title,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ------------------------------------------------------------
  // HORIZONTAL LIST (NORMAL CARD)
  // ------------------------------------------------------------
  Widget horizontalList(List<BookModel> books) {
    if (books.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
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

  // ------------------------------------------------------------
  // HORIZONTAL LIST POPULER (SMALL CARD)
  // ------------------------------------------------------------
  Widget horizontalListPopuler(List<BookModel> books) {
    if (books.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text("Belum ada buku populer."),
      );
    }

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

  // ------------------------------------------------------------
  // SMALL CARD (SEPERTI TERAKHIR DIAKSES) + RATING
  // ------------------------------------------------------------
  Widget smallBookCard(BookModel b, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BookDetailView(bookIndex: index, controller: controller, book: b,),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(8),
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
            SizedBox(height: 8),
            // Judul
            Text(
              b.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            // ⭐ VoteAverage
            Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.amber),
                SizedBox(width: 3),
                Text(
                  b.voteAverage.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            // Overview
            Text(
              b.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // NORMAL CARD (BESAR)
  // ------------------------------------------------------------
  Widget bookCard(BookModel b, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BookDetailView(bookIndex: index, controller: controller, book: b,),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 10),
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
            SizedBox(height: 8),
            Text(
              b.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            // ⭐⭐ 5-star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(5, (i) {
                  if (i < b.voteAverage.floor()) {
                    return Icon(Icons.star, color: Colors.amber, size: 14);
                  } else if (i < b.voteAverage) {
                    return Icon(Icons.star_half, color: Colors.amber, size: 14);
                  } else {
                    return Icon(Icons.star_border,
                        color: Colors.amber, size: 14);
                  }
                }),
                SizedBox(width: 4),
                Text(
                  b.voteAverage.toString(),
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // GRID VIEW ALL BOOKS
  // ------------------------------------------------------------
  Widget gridBuku(List<BookModel> books) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: books.length,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
