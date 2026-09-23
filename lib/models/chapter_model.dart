import 'package:cloud_firestore/cloud_firestore.dart';

/// প্রতি অধ্যায়ে কমপক্ষে এই শব্দ সংখ্যা থাকতে হবে
const int kMinWordCount = 700;

class Chapter {
  final String id;
  final int chapterNumber;
  final String title;
  final String content;
  final int wordCount;
  final DateTime publishedAt;
  final int reads;

  Chapter({
    required this.id,
    required this.chapterNumber,
    required this.title,
    required this.content,
    required this.wordCount,
    required this.publishedAt,
    this.reads = 0,
  });

  factory Chapter.fromMap(String id, Map<String, dynamic> map) {
    return Chapter(
      id: id,
      chapterNumber: map['chapterNumber'] ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      wordCount: map['wordCount'] ?? 0,
      publishedAt:
          (map['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reads: map['reads'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapterNumber': chapterNumber,
      'title': title,
      'content': content,
      'wordCount': wordCount,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'reads': reads,
    };
  }
}

/// বাংলা ও ইংরেজি দুই ধরনের লেখার জন্যই কাজ করবে এমন শব্দ গোনার ফাংশন
int countWords(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return 0;
  return trimmed.split(RegExp(r'\s+')).length;
}
