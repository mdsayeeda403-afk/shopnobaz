import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../services/story_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'story_detail_screen.dart';
import 'write_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storyService = StoryService();
  int _currentIndex = 0;
  StoryType? _filter;

  Widget _buildFilterChip(String label, StoryType? type) {
    final selected = _filter == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _filter = type),
        selectedColor: AppColors.primaryBlue,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: selected ? Colors.black : AppColors.textWhite,
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              _buildFilterChip('সব', null),
              _buildFilterChip('গল্প', StoryType.story),
              _buildFilterChip('কবিতা', StoryType.poem),
              _buildFilterChip('উপন্যাস', StoryType.novel),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Story>>(
            stream: _storyService.streamAllStories(filterType: _filter),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryBlue),
                );
              }
              final stories = snapshot.data ?? [];
              if (stories.isEmpty) {
                return const Center(
                  child: Text(
                    'এখনো কোনো লেখা নেই।\nপ্রথম লেখাটি তুমিই লিখে ফেলো!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      title: Text(
                        story.title,
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '${story.type.bengaliLabel} • ${story.authorName}',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: AppColors.primaryBlue),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StoryDetailScreen(storyId: story.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildHomeTab(),
      const WriteScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('স্বপ্নবাজ')),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'লিখুন'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'প্রোফাইল'),
        ],
      ),
    );
  }
}
