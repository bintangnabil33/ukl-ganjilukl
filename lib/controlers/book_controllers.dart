// book_controller.dart
import 'package:ukl/models/book_model.dart';

class BookController {
  // Singleton: semua halaman pakai instance yang sama
  static final BookController _instance = BookController._internal();
  factory BookController() => _instance;
  BookController._internal();

  List<BookModel> books = [
    BookModel(
      id: 1,
      title: "tentang kamu",
      overview: "\"Tentang Kamu\" adalah novel yang mengisahkan perjalanan Zaman Zulkarnaen, seorang pengacara muda yang ditugaskan untuk menyelesaikan kasus warisan yang rumit, mengungkap kisah hidup Sri Ningsih yang penuh misteri dan tantangan.",
      publisher: "Tere Liye",
      status: "Available",
      voteAverage: 4.0,
      posterPath: "assets/tentang kamu.jpg",
    ),
    BookModel(
      id: 2,
      title: "janji",
      overview: "Novel \"Janji\" karya Tere Liye mengisahkan petualangan tiga sekawan, Hasan, Baso, dan Kahar, yang ditugaskan untuk mencari Bahar, seorang mantan santri yang nakal, sebagai konsekuensi dari kenakalan mereka di pesantren.",
      publisher: "Tere Liye",
      status: "Available",
      voteAverage: 5.0,
      posterPath: "assets/janji.jpeg",
    ),
    BookModel(
      id: 3,
      title: "hujan",
      overview: "Novel \"Hujan\" karya Tere Liye adalah sebuah kisah emosional yang mengisahkan persahabatan dan cinta di tengah bencana alam, berlatar belakang tahun 2042 hingga 2050.",
      publisher: "Tere Liye",
      status: "Available",
      voteAverage: 4.5,
      posterPath: "assets/hujan.jpg",
    ),
    BookModel(
      id: 4,
      title: "cantik itu luka",
      overview: "Novel \"Cantik Itu Luka\" adalah novel karya Eka Kurniawan yang mengisahkan tentang kehidupan seorang wanita cantik yang mengalami berbagai tragedi dan penderitaan di sebuah kota kecil di Indonesia.",
      publisher: "Eka Kurniawan",
      status: "Available",
      voteAverage: 4.5,
      posterPath: "assets/cantik itu luka.jpg",
    ),
    BookModel(
      id: 5,
      title: "dompet ayah sepatu ibu",
      overview: "Novel \"Dompet Ayah Sepatu Ibu\" karya J.S. Khairen adalah novel yang menggambarkan perjuangan hidup dua karakter utama, Zenna dan Asrul, yang berasal dari keluarga miskin di lereng gunung.",
      publisher: "J.S. Khairen",
      status: "Available",
      voteAverage: 4.0,
      posterPath: "assets/dompet ayah sepatu ibu.jpg",
    ),
  ];

  /// Tambah buku baru
  void addBook({
    required String title,
    required String overview,
    required String publisher,
    String status = "Available",
    double voteAverage = 0.0,
    required String posterPath,
    bool isFavorite = false,
  }) {
    int id = books.isNotEmpty ? books.last.id + 1 : 1;
    books.add(BookModel(
      id: id,
      title: title,
      overview: overview,
      publisher: publisher,
      status: status,
      voteAverage: voteAverage,
      posterPath: posterPath,
      isFavorite: isFavorite,
    ));
  }

  /// Update buku berdasarkan index
  void updateBook(int index, {
    required String title,
    required String overview,
    required String publisher,
    String? status,
    double? voteAverage,
    String? posterPath,
    bool? isFavorite,
  }) {
    var old = books[index];
    books[index] = BookModel(
      id: old.id,
      title: title,
      overview: overview,
      publisher: publisher,
      status: status ?? old.status,
      voteAverage: voteAverage ?? old.voteAverage,
      posterPath: posterPath ?? old.posterPath,
      isFavorite: isFavorite ?? old.isFavorite,
    );
  }

  /// Hapus buku
  void deleteBook(int index) => books.removeAt(index);

  /// Toggle favorit
  void toggleFavorite(int index) => books[index].isFavorite = !books[index].isFavorite;
}
