import '../models/book.dart';

/// Temporary sample data makes the app usable before a database is added.
/// Replace or expand these entries with content that has been verified.
const sampleBooks = <Book>[
  Book(
    id: 'heart',
    title: 'Inna Fi Al-Jasadi Mudghah',
    subtitle: 'The Heart: The Source of Righteousness and Corruption',
    author: 'Scholar Ahmad Islam',
    category: 'Faith & Heart',
    arabicTitle: 'إِنَّ فِي الْجَسَدِ مُضْغَةً',
    description:
        'A study of the heart, its importance, its diseases, and the path to purification.',
  ),
  Book(
    id: 'knowing-allah',
    title: 'Knowing Allah',
    subtitle: 'Understanding Tawheed and the Names of Allah',
    author: 'Scholar Ahmad Islam',
    category: 'Aqeedah',
    arabicTitle: 'مَعْرِفَةُ اللَّهِ',
    description:
        'An introductory learning resource about knowing Allah through authentic evidence.',
  ),
  Book(
    id: 'hope',
    title: 'Hope in Allah',
    subtitle: 'Understanding Rajaa’',
    author: 'Scholar Ahmad Islam',
    category: 'Faith & Heart',
    arabicTitle: 'الرَّجَاءُ فِي اللَّهِ',
    description:
        'A study of hope in Allah balanced with sincere worship and reliance upon Him.',
  ),
];
