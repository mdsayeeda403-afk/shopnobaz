import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_model.dart';
import '../models/chapter_model.dart';

class StoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _stories => _db.collection('stories');

  /// হোম স্ক্রিনে দেখানোর জন্য সব লেখা (নতুন আগে)
  Stream<List<Story>> streamAllStories({StoryType? filterType}) {
    Query query = _stories.orderBy('createdAt', descending: true);
    if (filterType != null) {
      query = query.where('type', isEqualTo: filterType.value);
    }
    return query.snapshots().map((snap) => snap.docs
        .map((d) => Story.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList());
  }

  /// নির্দিষ্ট লেখকের সব লেখা
  Stream<List<Story>> streamStoriesByAuthor(String authorId) {
    return _stories
        .where('authorId', isEqualTo: authorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Story.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  /// নতুন গল্প/কবিতা/উপন্যাস তৈরি করা
  /// গল্প/কবিতার জন্য content সরাসরি দিতে হবে; উপন্যাসের জন্য খালি রেখে পরে chapter যোগ হবে
  Future<String> createStory({
    required String title,
    required String authorId,
    required String authorName,
    required StoryType type,
    String description = '',
    String content = '',
  }) async {
    final now = DateTime.now();
    final story = Story(
      id: '',
      title: title,
      authorId: authorId,
      authorName: authorName,
      type: type,
      description: description,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    final docRef = await _stories.add(story.toMap());
    return docRef.id;
  }

  Future<Story> getStory(String storyId) async {
    final doc = await _stories.doc(storyId).get();
    return Story.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  // ---------- অধ্যায় (শুধু উপন্যাসের জন্য) ----------

  CollectionReference _chapters(String storyId) =>
      _stories.doc(storyId).collection('chapters');

  Stream<List<Chapter>> streamChapters(String storyId) {
    return _chapters(storyId)
        .orderBy('chapterNumber')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Chapter.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  /// নতুন অধ্যায় যোগ করা - ৭০০ শব্দের কম হলে এরর থ্রো করবে (ফ্রন্টএন্ড ভ্যালিডেশন)
  Future<void> addChapter({
    required String storyId,
    required int chapterNumber,
    required String title,
    required String content,
  }) async {
    final wordCount = countWords(content);
    if (wordCount < kMinWordCount) {
      throw Exception(
          'অধ্যায়ে কমপক্ষে $kMinWordCount শব্দ থাকতে হবে। বর্তমানে আছে: $wordCount');
    }

    final chapter = Chapter(
      id: '',
      chapterNumber: chapterNumber,
      title: title,
      content: content,
      wordCount: wordCount,
      publishedAt: DateTime.now(),
    );

    await _chapters(storyId).add(chapter.toMap());

    // প্যারেন্ট story ডকুমেন্টে totalChapters ও updatedAt আপডেট করা
    await _stories.doc(storyId).update({
      'totalChapters': FieldValue.increment(1),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
