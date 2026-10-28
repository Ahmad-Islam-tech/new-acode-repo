import '../models/search_result.dart';

/// Provides one search system for all Noor Library content.
///
/// The sample records below demonstrate the search mechanism.
/// Later, we will connect this service to the actual books,
/// Qur'an database, hadith collection, and online library.
class UniversalSearchService {
  UniversalSearchService._();

  /// Shared service instance.
  static final UniversalSearchService instance =
      UniversalSearchService._();

  /// Demonstration search index.
  ///
  /// These entries test the search feature. They are not
  /// intended to represent your complete library.
  final List<SearchResult> _items = const [
    SearchResult(
      title: 'Sample Book: Purification of the Heart',
      category: 'BOOKS',
      content:
          'Study the heart, sincerity, good character, '
          'and spiritual purification.',
      reference: 'Demonstration book entry',
    ),

    SearchResult(
      title: 'Sample Topic: Patience',
      category: 'CHAPTERS',
      content:
          'A study topic about patience, perseverance, '
          'and remaining steadfast in faith.',
      reference: 'Demonstration chapter entry',
    ),

    SearchResult(
      title: 'Patience in the Qur’an',
      category: 'QURAN',
      content:
          'Indeed, Allah is with the patient.',
      arabicText:
          'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
      englishText:
          'Indeed, Allah is with the patient.',
      reference: 'Al-Baqarah 2:153',
    ),

    SearchResult(
      title: 'Actions Are Judged by Intentions',
      category: 'HADITH',
      content:
          'Actions are judged by intentions, and every '
          'person will have what they intended.',
      reference: 'Sahih al-Bukhari 1',
    ),

    SearchResult(
      title: 'Obugumiikiriza',
      category: 'LUGANDA',
      content:
          'Obugumiikiriza kitegeeza okusigala nga munywevu '
          'mu kukola ekirungi n’okwewala ebibi.',
      lugandaText:
          'Obugumiikiriza n’okugumiikiriza ebigezo.',
      reference: 'Demonstration Luganda entry',
    ),
  ];

  /// Returns matching results across all available categories.
  ///
  /// A blank search returns no results to avoid displaying
  /// the entire index before the user starts searching.
  List<SearchResult> search(
    String query, {
    String category = 'ALL',
  }) {
    final normalizedQuery = _normalize(query);

    if (normalizedQuery.isEmpty) {
      return [];
    }

    return _items.where((item) {
      final matchesText =
          _normalize(item.searchableText).contains(normalizedQuery);

      final matchesCategory =
          category == 'ALL' || item.category == category;

      return matchesText && matchesCategory;
    }).toList();
  }

  /// Normalizes text for more flexible searching.
  ///
  /// For Arabic, this removes common vowel marks so that
  /// searches can work even when the user omits tashkīl.
  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(
          RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'),
          '',
        )
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .trim();
  }
}