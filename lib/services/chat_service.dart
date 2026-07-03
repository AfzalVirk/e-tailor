import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ChatService {
  ChatService._();

  static final _conversationsRef = FirebaseFirestore.instance.collection(
    'conversations',
  );

  /// Deterministic ID so opening a chat with the same tailor always
  /// lands on the same thread, never creates a duplicate.
  static String conversationIdFor(String userUid, String tailorId) {
    return '${userUid}_$tailorId';
  }

  /// Creates the conversation document if it doesn't exist yet.
  /// Safe to call every time the chat icon is tapped — does nothing
  /// if the thread already exists.
  static Future<String> ensureConversation({
    required String customerUid,
    required String tailorId,
    required String tailorName,
    required String tailorImage,
  }) async {
    final conversationId = conversationIdFor(customerUid, tailorId);
    final docRef = _conversationsRef.doc(conversationId);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'participantIds': [customerUid, tailorId],
        'customerUid': customerUid,
        'tailorId': tailorId,
        'tailorName': tailorName,
        'tailorImage': tailorImage,
        'lastMessage': null,
        'lastMessageAt': null,
        'lastMessageSenderId': null,
        'lastReadAt': <String, dynamic>{},
      });
    }

    return conversationId;
  }

  static Stream<List<ConversationModel>> streamConversations(
    String currentUserUid,
  ) {
    return _conversationsRef
        .where('participantIds', arrayContains: currentUserUid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ConversationModel.fromMap(
                  doc.id,
                  doc.data(),
                  currentUserUid,
                ),
              )
              .toList(),
        );
  }

  static Stream<List<MessageModel>> streamMessages(String conversationId) {
    return _conversationsRef
        .doc(conversationId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  static Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final docRef = _conversationsRef.doc(conversationId);

    await docRef
        .collection('messages')
        .add(
          MessageModel(
            id: '',
            senderId: senderId,
            text: text,
            sentAt: null,
          ).toMap(),
        );

    await docRef.update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastMessageSenderId': senderId,
    });
  }

  static Future<void> markAsRead({
    required String conversationId,
    required String userUid,
  }) async {
    await _conversationsRef.doc(conversationId).update({
      'lastReadAt.$userUid': FieldValue.serverTimestamp(),
    });
  }
}
