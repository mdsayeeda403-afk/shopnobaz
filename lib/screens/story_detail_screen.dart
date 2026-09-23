import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../models/chapter_model.dart';
import '../services/story_service.dart';
import '../theme/app_theme.dart';
import 'chapter_reading_screen.dart';
import 'chapter_editor_screen.dart';
import '../services/auth_service.dart';

class StoryDetailScreen extends StatelessWidget {
  final String storyId;
  const StoryDetailScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    final storyService = StoryService();
    final currentUserId = AuthService().currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('বিস্তারিত')),
      body: FutureBuilder<Story>(
        future: storyService.getStory(storyId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }
          final story = snapshot.data!;
          final isOwner = story.authorId == currentUserId;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.title,
                    style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${story.type.bengaliLabel} • লেখক: ${story.authorName}',
                    style: const TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 12),
                if (story.description.isNotEmpty)
                  Text(story.description,
                      style: const TextStyle(color: AppColors.textWhite)),
                const SizedBox(height: 16),
                Expanded(
                  child: story.type == StoryType.novel
                      ? _ChapterList(
                          storyId: story.id,
                          isOwner: isOwner,
                          storyService: storyService,
                        )
                      : SingleChildScrollView(
                          child: Text(
                            story.content.isEmpty
                                ? 'এখনো কোনো লেখা যোগ করা হয়নি।'
                                : story.content,
                            style: const TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 16,
                                height: 1.6),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<Story>(
        future: storyService.getStory(storyId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          final story = snapshot.data!;
          final isOwner = story.authorId == currentUserId;
          if (!isOwner || story.type != StoryType.novel) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            backgroundColor: AppColors.primaryBlue,
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text('নতুন অধ্যায়',
                style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChapterEditorScreen(
                    storyId: story.id,
                    nextChapterNumber: story.totalChapters + 1,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ChapterList extends StatelessWidget {
  final String storyId;
  final bool isOwner;
  final StoryService storyService;

  const _ChapterList({
    required this.storyId,
    required this.isOwner,
    required this.storyService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Chapter>>(
      stream: storyService.streamChapters(storyId),
      builder: (context, snapshot) {
        final chapters = snapshot.data ?? [];
        if (chapters.isEmpty) {
          return const Center(
            child: Text('এখনো কোনো অধ্যায় প্রকাশিত হয়নি।',
                style: TextStyle(color: AppColors.textMuted)),
          );
        }
        return ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text('অধ্যায় ${chapter.chapterNumber}: ${chapter.title}',
                    style: const TextStyle(color: AppColors.textWhite)),
                subtitle: Text('${chapter.wordCount} শব্দ',
                    style: const TextStyle(color: AppColors.textMuted)),
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.primaryBlue),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChapterReadingScreen(chapter: chapter),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
