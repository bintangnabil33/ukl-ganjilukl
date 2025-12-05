import 'package:flutter/material.dart';
import 'package:ukl/controlers/book_controllers.dart';
import 'package:ukl/models/book_model.dart';
import 'book_detail_view.dart';

class LinimasaView extends StatefulWidget {
  final BookController controller;

  const LinimasaView({super.key, required this.controller});

  @override
  State<LinimasaView> createState() => _LinimasaViewState();
}

class _LinimasaViewState extends State<LinimasaView> {
  final TextEditingController title = TextEditingController();
  final TextEditingController publisher = TextEditingController();
  final TextEditingController overview = TextEditingController();
  final TextEditingController image = TextEditingController();
  String status = "Available";
  double rating = 0; // ⭐ rating bintang (0–5)
  final formKey = GlobalKey<FormState>();

  // ==============================
  // ⭐ OPEN FORM
  // ==============================
  void openForm({int? index}) {
    if (index != null) {
      var b = widget.controller.books[index];
      title.text = b.title;
      publisher.text = b.publisher;
      overview.text = b.overview;
      image.text = b.posterPath.replaceAll("assets/", "");
      rating = b.voteAverage;
      status = b.status;
    } else {
      title.clear();
      publisher.clear();
      overview.clear();
      image.clear();
      rating = 0;
      status = "Available";
    }

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  index == null ? "Tambah Buku" : "Edit Buku",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                customField(title, "Judul Buku"),
                customField(publisher, "Penerbit"),
                customField(overview, "Deskripsi Buku", max: 3),
                customField(image, "Nama file gambar (contoh: buku.png)"),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Rating Buku",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = (i + 1).toDouble();
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(
                    labelText: "Status Buku",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ["Available", "Borrowed"]
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => status = v ?? "Available"),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        String imgPath = "assets/${image.text}";

                        if (index != null) {
                          widget.controller.updateBook(
                            index,
                            title: title.text,
                            overview: overview.text,
                            publisher: publisher.text,
                            status: status,
                            voteAverage: rating,
                            posterPath: imgPath,
                          );
                        } else {
                          widget.controller.addBook(
                            title: title.text,
                            overview: overview.text,
                            publisher: publisher.text,
                            status: status,
                            voteAverage: rating,
                            posterPath: imgPath,
                          );
                        }

                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    child: Text("Simpan"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==============================
  // FIELD CUSTOM
  // ==============================
  Widget customField(TextEditingController ctrl, String label,
      {int max = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: max,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  // ==============================
  // BUILD UI
  // ==============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Linimasa Buku"),
        backgroundColor: Colors.blue.shade700,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: Icon(Icons.add),
      ),
      body: widget.controller.books.isEmpty
          ? Center(
              child: Text(
                "Belum ada buku.\nTekan + untuk menambah",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: widget.controller.books.length,
              itemBuilder: (_, i) {
                var b = widget.controller.books[i];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailView(
                              bookIndex: i, controller: widget.controller, book: b,),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        b.posterPath,
                        width: 55,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(b.title),
                    subtitle:
                        Text("${b.publisher} | ${b.status} | ${b.voteAverage} ⭐"),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") openForm(index: i);
                        if (value == "delete") {
                          widget.controller.deleteBook(i);
                          setState(() {});
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(value: "edit", child: Text("Edit")),
                        PopupMenuItem(value: "delete", child: Text("Hapus")),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
