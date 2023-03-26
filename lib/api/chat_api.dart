import 'package:flutter/material.dart';
import 'package:chat_ease/models/chat_message.dart';
import 'package:dart_openai/openai.dart';
import 'package:chat_ease/store/shared_preferences_manager.dart';

class ChatApi {
  Future<String> completeChat(List<ChatMessage> messages) async {
    OpenAI.apiKey =
        await (await SharedPreferencesManager.getInstance()).getApiKey();
    OpenAI.organization =
        await (await SharedPreferencesManager.getInstance()).getApiOrg();

    final chatCompletion = await OpenAI.instance.chat.create(
        model: await (await SharedPreferencesManager.getInstance()).getModel(),
        messages: messages
            .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.isUserMessage ? 'user' : 'assistant',
                content: e.content))
            .toList());
    return chatCompletion.choices.first.message.content;
  }

  Future<bool> validateApiKey(String key) async {
    try {
      OpenAI.apiKey = key;
      OpenAI.organization =
          await (await SharedPreferencesManager.getInstance()).getApiOrg();

      await OpenAI.instance.completion.create(
          model:
              await (await SharedPreferencesManager.getInstance()).getModel());
    } on RequestFailedException catch (_, e) {
      // TODO add to error log
      return false;
    }
    return true;
  }
}
