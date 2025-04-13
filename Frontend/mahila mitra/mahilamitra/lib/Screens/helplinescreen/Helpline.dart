import 'package:flutter/material.dart';

class HelplineChatScreen extends StatefulWidget {
  const HelplineChatScreen({super.key});

  @override
  State<HelplineChatScreen> createState() => _HelplineChatScreenState();
}

class _HelplineChatScreenState extends State<HelplineChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> messages = [
    {"sender": "bot", "text": "Hi, how can I assist you today?"},
  ];

  void _sendMessage() {
    String msg = _messageController.text.trim();
    if (msg.isNotEmpty) {
      setState(() {
        messages.add({"sender": "user", "text": msg});
        _messageController.clear();

        // Simulated bot response
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            messages.add({"sender": "bot", "text": "Thanks for reaching out. We'll get back to you shortly!"});
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Helpline Chat 💬"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.pinkAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Colors.pinkAccent,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
