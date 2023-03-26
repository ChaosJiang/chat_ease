import 'package:flutter/material.dart';
import 'package:chat_ease/models/chat_message.dart';
import 'package:dart_openai/openai.dart';
import 'package:chat_ease/store/shared_preferences_manager.dart';

class ChatApi {
  final SharedPreferencesManager _prefsManager;

  ChatApi(this._prefsManager);

  Future<String> completeChat(List<ChatMessage> messages) async {
    OpenAI.apiKey = await _prefsManager.getApiKey();
    OpenAI.organization = await _prefsManager.getApiOrg();

    final chatCompletion = await OpenAI.instance.chat.create(
        model: await _prefsManager.getModel(),
        messages: messages
            .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.isUserMessage ? 'user' : 'assistant',
                content: e.content))
            .toList());
    return chatCompletion.choices.first.message.content;
  }
}
