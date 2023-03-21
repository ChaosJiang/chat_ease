class ChatMessage {
  ChatMessage(this.content, this.isUserMessage);
  @override
  String toString() {
    return '{isUserMessage: $isUserMessage, content: $content}';
  }

  final String content;
  final bool isUserMessage;
}
