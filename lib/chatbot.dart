import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'consts.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitplan Chatbot',
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black12,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 0, // Remove default shadow
        ),
      ),
      home: ChatPage(),
    );
  }
}

class ChatMessage {
  final String text;
  final ChatUser user;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.user,
    required this.timestamp,
  });
}

class ChatUser {
  final String firstName;

  ChatUser({
    required this.firstName,
  });
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.insert(
      0,
      ChatMessage(
        text: 'Welcome to Fitplan! How can I assist you today?',
        user: ChatUser(firstName: 'Fitplan'),
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Increase app bar height
        child: AppBar(
          title: Text(
            'Fitplan Chatbot',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.5), // Add shadow effect
          backgroundColor: Colors.green,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade700, Colors.teal.shade700],
              ),
            ),
          ),
        ),
      ),
      body: Container(

        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isUser = message.user.firstName == 'User';
    final String formattedTime = DateFormat('hh:mm a').format(message.timestamp);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.circular(12.0),
            color: isUser ? Colors.green : Colors.white,
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            formattedTime,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.green[600],
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                sendMessage(_textController.text);
              },
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.isEmpty) return;

    final newMessage = ChatMessage(
      text: messageText,
      user: ChatUser(firstName: 'User'),
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    try {
      final response = await getCohereChatResponse(messageText);
      final botMessage = ChatMessage(
        text: response,
        user: ChatUser(firstName: 'Fitplan'),
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      print('Error: $e');
      final errorMessage = ChatMessage(
        text: 'Error: $e',
        user: ChatUser(firstName: 'Fitplan'),
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.insert(0, errorMessage);
      });
    }

    _textController.clear();
  }

  Future<String> getCohereChatResponse(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.cohere.ai/v1/chat'),
      headers: {
        'Authorization': 'Bearer $COHERE_API_KEY',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'message': prompt,
        'chat_history': _messages.map((message) {
          return {
            'role': message.user.firstName == 'User' ? 'user' : 'assistant',
            'message': message.text,
          };
        }).toList(),
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['text'] != null) {
        return data['text'];
      } else {
        throw Exception('Response does not contain text');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key');
    } else {
      throw Exception('Failed to fetch response');
    }
  }
}
