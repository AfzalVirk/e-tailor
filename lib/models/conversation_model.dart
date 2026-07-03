import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  final String id;
  final String tailorId;
  final String tailorName;
  final String tailorImage;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderId;
  final bool hasUnread;

  const ConversationModel({
    required this.id,
    required this.tailorId,
    required this.tailorName,
    required this.tailorImage,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastMessageSenderId,
    required this.hasUnread,
  });

  factory ConversationModel.fromMap(
    String id,
    Map<String, dynamic> map,
    String currentUserUid,
  ) {
    final lastMessageAt = (map['lastMessageAt'] as Timestamp?)?.toDate();
    final lastMessageSenderId = map['lastMessageSenderId'] as String?;

    final lastReadMap = map['lastReadAt'] as Map<String, dynamic>? ?? {};
    final myLastRead = (lastReadMap[currentUserUid] as Timestamp?)?.toDate();

    final hasUnread =
        lastMessageAt != null &&
        lastMessageSenderId != currentUserUid &&
        (myLastRead == null || lastMessageAt.isAfter(myLastRead));

    return ConversationModel(
      id: id,
      tailorId: map['tailorId'] as String? ?? '',
      tailorName: map['tailorName'] as String? ?? '',
      tailorImage: map['tailorImage'] as String? ?? '',
      lastMessage: map['lastMessage'] as String?,
      lastMessageAt: lastMessageAt,
      lastMessageSenderId: lastMessageSenderId,
      hasUnread: hasUnread,
    );
  }
}
