/// Describes one result returned by Noor Library's universal search.
///
/// A result might represent a book, Qur'an verse, hadith,
/// or a chapter within a book.
class SearchResult {
  final String title;
  final String content;
  final String category;
  final String reference;
  final String arabicText;
  final String englishText;
  final String lugandaText;

  const SearchResult({
    required this.title,
    required this.content,
    required this.category,
    this.reference = '',
    this.arabicText = '',
    this.englishText = '',
    this.lugandaText = '',
  });

  /// Combines searchable fields into one string.
  ///
  /// This allows a search to match Arabic, English, Luganda,
  /// titles, references, and the main content.
  String get searchableText => [
        title,
        content,
        category,
        reference,
        arabicText,
        englishText,
        lugandaText,
      ].join(' ').toLowerCase();
}