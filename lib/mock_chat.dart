// mock_chat_service.dart
class MockChatService {
  static List<ChatMessage> _messages = [];

  static Future<void> sendMessage(ChatMessage message) async {
    await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay
    _messages.add(message);
  }

  static Stream<List<ChatMessage>> getMessages(String donationId) {
    return Stream.periodic(
      Duration(seconds: 1),
      (_) => _messages,
    ).asBroadcastStream();
  }
}

class ChatMessage {
  final String senderId;
  final String senderType; // 'ngo' or 'restaurant'
  final String text;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.senderId,
    required this.senderType,
    required this.text,
    DateTime? timestamp,
    this.isRead = false,
  }) : timestamp = timestamp ?? DateTime.now();
}
