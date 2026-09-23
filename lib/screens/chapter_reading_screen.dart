import 'package:flutter/material.dart';
import '../models/chapter_model.dart';
import '../theme/app_theme.dart';

class ChapterReadingScreen extends StatelessWidget {
  final Chapter chapter;
  const ChapterReadingScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('অধ্যায় ${chapter.chapterNumber}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chapter.title,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              chapter.content,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 17,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
