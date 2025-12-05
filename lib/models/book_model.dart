// lib/models/book_model.dart
class BookModel {
  int id;
  String title;
  String overview;
  String publisher;
  String status;
  double voteAverage;
  String posterPath;
  bool isFavorite;

  BookModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.publisher,
    required this.status,
    required this.voteAverage,
    required this.posterPath,
    this.isFavorite = false,
  });

  /// Buat salinan (clone) supaya kita tidak berbagi referensi objek
  BookModel copy() {
    return BookModel(
      id: id,
      title: title,
      overview: overview,
      publisher: publisher,
      status: status,
      voteAverage: voteAverage,
      posterPath: posterPath,
      isFavorite: isFavorite,
    );
  }
}
