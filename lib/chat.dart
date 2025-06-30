import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added for DateFormat
import 'dart:math'; // Added for Random

// Make sure this exists in mock_chat.dart
import 'mock_chat.dart';

class ChatScreen extends StatefulWidget {
  final String donationId;
  final String currentUserType;
  final String otherPartyName;
  final String otherPartyImage;

  const ChatScreen({
    Key? key, // Added Key parameter
    required this.donationId,
    required this.currentUserType,
    required this.otherPartyName,
    required this.otherPartyImage,
  }) : super(key: key); // Added super call

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final String _currentUserId = 'mock_user_${Random().nextInt(1000)}';

  @override
  void initState() {
    super.initState();
    // Load initial mock messages
    _messages.addAll([
      ChatMessage(
        senderId: 'mock_ngo_1',
        senderType: 'ngo',
        text: 'Hi there! We can pickup the donation today between 3-5 PM',
        timestamp: DateTime.now().subtract(Duration(minutes: 10)),
      ),
      ChatMessage(
        senderId: _currentUserId,
        senderType: widget.currentUserType,
        text: 'That works for us. Please come to the back entrance',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.otherPartyImage)),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherPartyName),
                Text(
                  widget.currentUserType == 'ngo'
                      ? 'Restaurant'
                      : 'NGO Representative',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isCurrentUser = message.senderId == _currentUserId;

    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.deepOrange[400] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser)
              Text(
                widget.otherPartyName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCurrentUser ? Colors.white : Colors.deepOrange,
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color:
                    isCurrentUser
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.deepOrange),
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                final newMessage = ChatMessage(
                  senderId: _currentUserId,
                  senderType: widget.currentUserType,
                  text: _messageController.text,
                );
                setState(() {
                  _messages.add(newMessage);
                  _messageController.clear();
                });
                Future.delayed(Duration(milliseconds: 100), () {
                  Scrollable.ensureVisible(
                    context,
                    alignment: 1.0,
                    duration: Duration(milliseconds: 300),
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
