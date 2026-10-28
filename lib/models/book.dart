/// A simple model describing one book in the library.
class Book {
  final String id;
  final String title;
  final String subtitle;
  final String author;
  final String category;
  final String description;
  final String arabicTitle;

  const Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.category,
    required this.description,
    required this.arabicTitle,
  });
}