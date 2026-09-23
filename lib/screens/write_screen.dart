import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/story_service.dart';
import '../theme/app_theme.dart';
import 'story_detail_screen.dart';
import 'chapter_editor_screen.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final _authService = AuthService();
  final _storyService = StoryService();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _contentController = TextEditingController();
  StoryType _selectedType = StoryType.story;
  bool _isSubmitting = false;

  Future<void> _submit(AppUser user) async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final storyId = await _storyService.createStory(
        title: _titleController.text.trim(),
        authorId: user.uid,
        authorName: user.name,
        type: _selectedType,
        description: _descController.text.trim(),
        content: _selectedType == StoryType.novel
            ? ''
            : _contentController.text.trim(),
      );

      if (!mounted) return;

      if (_selectedType == StoryType.novel) {
        // উপন্যাস হলে সরাসরি প্রথম অধ্যায় লেখার স্ক্রিনে পাঠানো
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ChapterEditorScreen(
              storyId: storyId,
              nextChapterNumber: 1,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => StoryDetailScreen(storyId: storyId),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _typeChip(StoryType type) {
    final selected = _selectedType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(type.bengaliLabel),
        selected: selected,
        onSelected: (_) => setState(() => _selectedType = type),
        selectedColor: AppColors.primaryBlue,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: selected ? Colors.black : AppColors.textWhite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) {
      return const Center(child: Text('লগইন করুন'));
    }

    return FutureBuilder<AppUser?>(
      future: _authService.getUserProfile(firebaseUser.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        final user = snapshot.data!;

        if (user.role != UserRole.writer) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'শুধুমাত্র লেখক অ্যাকাউন্ট থেকে লেখা পাবলিশ করা যায়।\nপ্রোফাইল থেকে লেখক হিসেবে যোগ দাও।',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('কী লিখছো?',
                    style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _typeChip(StoryType.story),
                    _typeChip(StoryType.poem),
                    _typeChip(StoryType.novel),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: AppColors.textWhite),
                  decoration: const InputDecoration(hintText: 'শিরোনাম'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _descController,
                  style: const TextStyle(color: AppColors.textWhite),
                  decoration:
                      const InputDecoration(hintText: 'সংক্ষিপ্ত বিবরণ (ঐচ্ছিক)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 14),
                if (_selectedType != StoryType.novel)
                  TextField(
                    controller: _contentController,
                    style: const TextStyle(color: AppColors.textWhite),
                    decoration: InputDecoration(
                      hintText: _selectedType == StoryType.poem
                          ? 'কবিতা লেখো...'
                          : 'গল্প লেখো...',
                    ),
                    maxLines: 12,
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'উপন্যাসের জন্য পরের ধাপে অধ্যায় লেখার পেজ খুলবে।',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _submit(user),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.black),
                        )
                      : Text(_selectedType == StoryType.novel
                          ? 'পরবর্তী: প্রথম অধ্যায় লিখুন'
                          : 'পাবলিশ করুন'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
