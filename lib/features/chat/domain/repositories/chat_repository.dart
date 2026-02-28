import '../models/conversation.dart';
import '../models/message.dart';

abstract class ChatRepository {
  Future<List<Conversation>> listConversations({
    int limit = 20,
    String? cursor,
  });

  Future<Conversation> getConversation(String id);

  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    int limit = 50,
    String? cursor,
  });

  Future<String> getWsTicket();
}
