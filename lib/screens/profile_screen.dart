import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/story_service.dart';
import '../theme/app_theme.dart';
import 'story_detail_screen.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final storyService = StoryService();
    final firebaseUser = authService.currentUser;

    if (firebaseUser == null) return const SizedBox.shrink();

    return FutureBuilder<AppUser?>(
      future: authService.getUserProfile(firebaseUser.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        final user = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.surface,
                    child: Icon(Icons.person,
                        color: AppColors.primaryBlue, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: const TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(
                          user.role == UserRole.writer ? 'লেখক' : 'পাঠক',
                          style: const TextStyle(color: AppColors.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: AppColors.textMuted),
                    onPressed: () async {
                      await authService.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const SplashScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (user.role == UserRole.writer) ...[
                const Text('আমার লেখা',
                    style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<List<Story>>(
                    stream: storyService.streamStoriesByAuthor(user.uid),
                    builder: (context, snap) {
                      final stories = snap.data ?? [];
                      if (stories.isEmpty) {
                        return const Text(
                          'তুমি এখনো কিছু লেখোনি।',
                          style: TextStyle(color: AppColors.textMuted),
                        );
                      }
                      return ListView.builder(
                        itemCount: stories.length,
                        itemBuilder: (context, i) {
                          final s = stories[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              title: Text(s.title,
                                  style: const TextStyle(
                                      color: AppColors.textWhite)),
                              subtitle: Text(s.type.bengaliLabel,
                                  style: const TextStyle(
                                      color: AppColors.textMuted)),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        StoryDetailScreen(storyId: s.id),
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
            ],
          ),
        );
      },
    );
  }
}
