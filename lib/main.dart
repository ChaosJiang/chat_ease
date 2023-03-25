import 'package:chat_ease/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:chat_ease/api/chat_api.dart';
import 'package:chat_ease/chat_page.dart';

void main() {
  runApp(ChatApp(
    chatApi: ChatApi(),
  ));
}

class ChatApp extends StatelessWidget {
  const ChatApp({required this.chatApi, super.key});
  final ChatApi chatApi;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Client',
      theme: ThemeData.light(),
      // home: ChatPage(chatApi: chatApi),
      initialRoute: '/',
      routes: {
        '/': (context) => ChatPage(chatApi: chatApi),
        '/settings': (context) => const SettingsScreen()
      },
    );
  }
}
