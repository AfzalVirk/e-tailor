import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/conversation_model.dart';
import '../../services/chat_service.dart';
import 'chat_thread_args.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return DateFormat('h:mm a').format(dt);
    }
    return DateFormat('MMM d').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('Messages', style: AppTextStyles.heading3(context)),
      ),
      body: currentUid == null
          ? const SizedBox.shrink()
          : StreamBuilder<List<ConversationModel>>(
              stream: ChatService.streamConversations(currentUid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        'Could not load messages: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall(
                          context,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  );
                }
                final conversations = snapshot.data!;
                if (conversations.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 56.sp,
                            color: AppColors.textSecondaryLight,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'No conversations yet',
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Message a tailor from their profile to get started.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: conversations.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: AppColors.borderLight,
                    indent: 76.w,
                  ),
                  itemBuilder: (context, index) {
                    final c = conversations[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 6.h,
                      ),
                      leading: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: c.tailorImage,
                          width: 48.w,
                          height: 48.w,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.person, size: 24.sp),
                        ),
                      ),
                      title: Text(
                        c.tailorName,
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          fontWeight: c.hasUnread
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        c.lastMessage ?? 'Start the conversation',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall(
                          context,
                          color: c.hasUnread
                              ? AppColors.textPrimaryLight
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatTime(c.lastMessageAt),
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.textSecondaryLight,
                            ).copyWith(fontSize: 10.sp),
                          ),
                          if (c.hasUnread) ...[
                            SizedBox(height: 4.h),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.chatThread,
                        arguments: ChatThreadArgs(
                          conversationId: c.id,
                          tailorName: c.tailorName,
                          tailorImage: c.tailorImage,
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
