import 'package:cloud_firestore/cloud_firestore.dart';

enum StoryType { story, poem, novel }

extension StoryTypeLabel on StoryType {
  String get bengaliLabel {
    switch (this) {
      case StoryType.story:
        return 'গল্প';
      case StoryType.poem:
        return 'কবিতা';
      case StoryType.novel:
        return 'উপন্যাস';
    }
  }

  static StoryType fromString(String value) {
    switch (value) {
      case 'poem':
        return StoryType.poem;
      case 'novel':
        return StoryType.novel;
      default:
        return StoryType.story;
    }
  }

  String get value {
    switch (this) {
      case StoryType.story:
        return 'story';
      case StoryType.poem:
        return 'poem';
      case StoryType.novel:
        return 'novel';
    }
  }
}

class Story {
  final String id;
  final String title;
  final String authorId;
  final String authorName;
  final StoryType type;
  final String description;
  // ছোট লেখা (গল্প/কবিতা) হলে content সরাসরি এখানে থাকবে।
  // উপন্যাস হলে content খালি থাকবে, chapters sub-collection ব্যবহার হবে।
  final String content;
  final int totalChapters;
  final int totalReads;
  final int totalLikes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Story({
    required this.id,
    required this.title,
    required this.authorId,
    required this.authorName,
    required this.type,
    this.description = '',
    this.content = '',
    this.totalChapters = 0,
    this.totalReads = 0,
    this.totalLikes = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Story.fromMap(String id, Map<String, dynamic> map) {
    return Story(
      id: id,
      title: map['title'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      type: StoryTypeLabel.fromString(map['type'] ?? 'story'),
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      totalChapters: map['totalChapters'] ?? 0,
      totalReads: map['totalReads'] ?? 0,
      totalLikes: map['totalLikes'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authorId': authorId,
      'authorName': authorName,
      'type': type.value,
      'description': description,
      'content': content,
      'totalChapters': totalChapters,
      'totalReads': totalReads,
      'totalLikes': totalLikes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
