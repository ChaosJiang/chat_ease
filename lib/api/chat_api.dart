import 'package:chat_ease/models/chat_message.dart';
import 'package:chat_ease/utils/logger_util.dart';
import 'package:dart_openai/openai.dart';
import 'package:chat_ease/utils/shared_preferences_util.dart';

class ChatApi {
  Future<String> completeChat(List<ChatMessage> messages) async {
    OpenAI.apiKey =
        SharedPreferencesUtil.prefs.getString('open_ai_api_key') ?? '';
    OpenAI.organization = SharedPreferencesUtil.prefs.getString('open_ai_org');

    final chatCompletion = await OpenAI.instance.chat.create(
        model: SharedPreferencesUtil.prefs.getString('open_ai_model') ??
            'gpt-3.5-turbo',
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
          SharedPreferencesUtil.prefs.getString('open_ai_org');

      await OpenAI.instance.chat.create(
          model: SharedPreferencesUtil.prefs.getString('open_ai_model') ??
              'gpt-3.5-turbo',
          messages: [
            OpenAIChatCompletionChoiceMessageModel(role: 'user', content: 'Hi')
          ]);
    } catch (e) {
      LoggerUtil.logError(e.toString());
      return false;
    }
    return true;
  }
}
