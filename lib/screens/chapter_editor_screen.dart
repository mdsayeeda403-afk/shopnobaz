import 'package:flutter/material.dart';
import '../models/chapter_model.dart';
import '../services/story_service.dart';
import '../theme/app_theme.dart';
import 'story_detail_screen.dart';

class ChapterEditorScreen extends StatefulWidget {
  final String storyId;
  final int nextChapterNumber;

  const ChapterEditorScreen({
    super.key,
    required this.storyId,
    required this.nextChapterNumber,
  });

  @override
  State<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends State<ChapterEditorScreen> {
  final _storyService = StoryService();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _wordCount = 0;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {
        _wordCount = countWords(_contentController.text);
      });
    });
  }

  bool get _meetsMinimum => _wordCount >= kMinWordCount;

  Future<void> _publish() async {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _error = 'অধ্যায়ের শিরোনাম দাও');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await _storyService.addChapter(
        storyId: widget.storyId,
        chapterNumber: widget.nextChapterNumber,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => StoryDetailScreen(storyId: widget.storyId),
          ),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('অধ্যায় ${widget.nextChapterNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: const InputDecoration(hintText: 'অধ্যায়ের শিরোনাম'),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(color: AppColors.textWhite, height: 1.6),
                decoration: const InputDecoration(
                  hintText: 'এই অধ্যায়ে যা ঘটবে তা লেখো... (কমপক্ষে ৭০০ শব্দ)',
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'শব্দ সংখ্যা: $_wordCount / $kMinWordCount',
                  style: TextStyle(
                    color: _meetsMinimum
                        ? AppColors.primaryBlue
                        : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!_meetsMinimum)
                  Text(
                    'আরও ${kMinWordCount - _wordCount} শব্দ লাগবে',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: (_meetsMinimum && !_isSubmitting) ? _publish : null,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black),
                    )
                  : const Text('অধ্যায় প্রকাশ করুন'),
            ),
          ],
        ),
      ),
    );
  }
}
