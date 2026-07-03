import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';
import 'chat_thread_args.dart';
import 'package:intl/intl.dart';

class ChatThreadScreen extends StatefulWidget {
  final ChatThreadArgs args;
  const ChatThreadScreen({super.key, required this.args});

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final _textController = TextEditingController();
  final _currentUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    ChatService.markAsRead(
      conversationId: widget.args.conversationId,
      userUid: _currentUid,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    ChatService.sendMessage(
      conversationId: widget.args.conversationId,
      senderId: _currentUid,
      text: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.args.tailorImage,
                width: 36.w,
                height: 36.w,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Icon(Icons.person, size: 20.sp),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.args.tailorName,
                    style: AppTextStyles.bodyMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'active now',
                    style: AppTextStyles.bodySmall(
                      context,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: ChatService.streamMessages(widget.args.conversationId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Say hello to ${widget.args.tailorName} to start the conversation.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
                    final isMe = m.senderId == _currentUid;
                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 2.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            constraints: BoxConstraints(maxWidth: 260.w),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? AppColors.primary
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(16.r),
                              border: isMe
                                  ? null
                                  : Border.all(color: AppColors.borderLight),
                            ),
                            child: Text(
                              m.text,
                              style: AppTextStyles.bodyMedium(
                                context,
                                color: isMe ? Colors.white : null,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                            left: 4.w,
                            right: 4.w,
                          ),
                          child: Text(
                            m.sentAt != null
                                ? DateFormat('h:mm a').format(m.sentAt!)
                                : 'Sending...',
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.textSecondaryLight,
                            ).copyWith(fontSize: 10.sp),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide(color: AppColors.borderLight),
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
