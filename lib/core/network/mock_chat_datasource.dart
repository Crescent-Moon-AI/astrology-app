import 'dart:async';

import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/models/ws_message.dart';

/// Mock WebSocket chat datasource that simulates streaming AI replies.
/// Emits the same message sequence as the real WebSocket server.
class MockChatDatasource extends ChatRemoteDatasource {
  final StreamController<WsServerMessage> _controller =
      StreamController<WsServerMessage>.broadcast();
  bool _connected = false;
  int _msgCounter = 0;

  @override
  Stream<WsServerMessage> get messageStream => _controller.stream;

  @override
  bool get isConnected => _connected;

  @override
  String? get sessionId => _connected ? 'mock-session' : null;

  @override
  Future<void> connect(String wsUrl, String ticket) async {
    _connected = true;
    // Emit connected message like real server
    _controller.add(
      WsServerMessage(type: 'connected', sessionId: 'mock-session'),
    );
  }

  @override
  void sendMessage({
    required String content,
    String? conversationId,
    String? clientMessageId,
    String? language,
    String? requestId,
    String? scenarioId,
  }) {
    _msgCounter++;
    final convId = conversationId ?? 'mock-conv-new-$_msgCounter';
    final msgId = 'mock-msg-resp-$_msgCounter';
    final blockId = 'mock-block-$_msgCounter';
    final clientMsgId = clientMessageId ?? 'mock-client-$_msgCounter';
    final reqId = requestId ?? 'mock-req-$_msgCounter';
    final reply = _pickReply(content);

    _streamReply(
      conversationId: convId,
      isNew: conversationId == null,
      messageId: msgId,
      blockId: blockId,
      clientMessageId: clientMsgId,
      requestId: reqId,
      reply: reply,
    );
  }

  @override
  void sendPing() {
    // No-op for mock
  }

  @override
  void disconnect() {
    _connected = false;
  }

  @override
  void dispose() {
    disconnect();
    _controller.close();
  }

  /// Stream a mock reply following the real WS message sequence.
  void _streamReply({
    required String conversationId,
    required bool isNew,
    required String messageId,
    required String blockId,
    required String clientMessageId,
    required String requestId,
    required String reply,
  }) {
    // Use Future to run async without blocking sendMessage
    Future<void>(() async {
      // 1. conversation_created (if new conversation)
      if (isNew) {
        _controller.add(
          WsServerMessage(
            type: 'conversation_created',
            conversationId: conversationId,
            requestId: requestId,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      // 2. message_ack
      _controller.add(
        WsServerMessage(
          type: 'message_ack',
          conversationId: conversationId,
          clientMessageId: clientMessageId,
          requestId: requestId,
          messageId: 'mock-user-msg-$_msgCounter',
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 3. block_upsert (kind: text, status: running)
      _controller.add(
        WsServerMessage(
          type: 'block_upsert',
          conversationId: conversationId,
          messageId: messageId,
          requestId: requestId,
          blockId: blockId,
          block: {'id': blockId, 'idx': 0, 'kind': 'text', 'status': 'running'},
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 150));

      // 4. block_delta × N (stream characters)
      final chars = reply.split('');
      final buffer = StringBuffer();
      for (var i = 0; i < chars.length; i++) {
        buffer.write(chars[i]);
        _controller.add(
          WsServerMessage(
            type: 'block_delta',
            blockId: blockId,
            delta: chars[i],
            index: i,
          ),
        );
        // Variable speed: faster for punctuation, slower for content
        final delay = _isPunctuation(chars[i]) ? 80 : 30;
        await Future<void>.delayed(Duration(milliseconds: delay));
      }

      // 5. block_done
      _controller.add(
        WsServerMessage(
          type: 'block_done',
          blockId: blockId,
          content: reply,
          messageId: messageId,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // 6. response_done
      _controller.add(
        WsServerMessage(
          type: 'response_done',
          conversationId: conversationId,
          messageId: messageId,
          requestId: requestId,
        ),
      );
    });
  }

  bool _isPunctuation(String ch) {
    return '，。！？、；：""'
            '（）\n'
        .contains(ch);
  }

  /// Pick a contextual Chinese astrology reply based on user input keywords.
  String _pickReply(String input) {
    final lower = input.toLowerCase();

    if (lower.contains('运势') || lower.contains('运程')) {
      return '亲爱的星辰旅人，让我为你解读近期的星象能量。\n\n'
          '目前太阳正经过你的命宫，这赋予你强大的个人魅力和自信心。'
          '木星与你的金星形成和谐相位，预示着财运和人际关系都将迎来好转。\n\n'
          '不过要注意土星的影响，它提醒你在追求目标时保持耐心和纪律。'
          '本周最佳行动日是周三和周五，适合签约、面试或重要谈话。\n\n'
          '总体而言，这是一个充满潜力的时期，把握好每一个机会吧！';
    }

    if (lower.contains('感情') || lower.contains('爱情') || lower.contains('桃花')) {
      return '让我为你分析当前的感情星象。\n\n'
          '金星正在双鱼座运行，这是爱情最浪漫的位置。'
          '你的第七宫（伴侣宫）被温暖的能量照亮，暗示着一段深刻的情感连接正在形成。\n\n'
          '如果你是单身，近期可能会通过文化艺术活动或朋友介绍认识心仪的对象。'
          '对方可能是水象星座（巨蟹、天蝎、双鱼），性格温柔而富有同理心。\n\n'
          '如果你正在恋爱中，这段时间适合坦诚沟通内心感受，让感情更上一层楼。';
    }

    if (lower.contains('事业') || lower.contains('工作') || lower.contains('职场')) {
      return '从星象角度来看，你的事业发展正处于关键转折期。\n\n'
          '火星进入你的第十宫（事业宫），带来强烈的上进心和行动力。'
          '这段时间你的工作效率会明显提升，领导力也更加突出。\n\n'
          '木星在第二宫的影响暗示可能有加薪或额外收入的机会。'
          '建议你大胆表达自己的想法，展示你的专业能力。\n\n'
          '需要注意的是，水星逆行期间避免签订重要合同，最好等到水逆结束后再做重大决定。';
    }

    if (lower.contains('塔罗') || lower.contains('牌')) {
      return '我感受到了你内心的疑问，让我为你翻开命运的牌阵。\n\n'
          '你抽到的主牌是「星星」——这是一张充满希望与灵感的牌。'
          '它暗示着经过一段困难时期后，光明即将到来。\n\n'
          '辅助牌「圣杯骑士」代表一个带着情感好消息的人或事件正在靠近。'
          '这可能是一段新的感情，也可能是内心深处的一次觉醒。\n\n'
          '建议你保持开放的心态，相信宇宙的安排。每一次转折都是成长的契机。';
    }

    if (lower.contains('水逆') || lower.contains('逆行')) {
      return '水星逆行确实是值得关注的星象事件。\n\n'
          '在水逆期间，沟通、交通和电子设备容易出现状况。'
          '你可能会遇到信息误传、合同纠纷或旧人重逢的情况。\n\n'
          '但水逆并不全是坏事！这是一个绝佳的「回顾与反思」时期：\n'
          '• 重新审视未完成的项目\n'
          '• 修复破裂的关系\n'
          '• 整理思路，为下一步做准备\n\n'
          '建议：重要文件多检查几遍，出行提前规划，电子设备做好备份。';
    }

    if (lower.contains('心情') || lower.contains('情绪') || lower.contains('状态')) {
      return '我感受到你今天的能量场，让我结合星象来分析。\n\n'
          '月亮目前在巨蟹座运行，这会让你的情感更加敏感细腻。'
          '你可能会比平时更加渴望安全感和家的温暖。\n\n'
          '建议你今天：\n'
          '• 给自己泡一杯温暖的花茶\n'
          '• 听一些舒缓的音乐\n'
          '• 和亲近的人聊聊心事\n'
          '• 在日记中记录你的感受\n\n'
          '记住，情绪的波动是正常的，就像月亮的阴晴圆缺一样自然。';
    }

    // Default reply
    return '感谢你的提问，让我为你解读星象的指引。\n\n'
        '目前的星象格局整体是积极的。太阳与木星形成三分相，'
        '这意味着你正处于一个充满机遇的时期。\n\n'
        '宇宙正在向你传递一个信息：相信自己的直觉，'
        '勇敢地追随内心的声音。每一颗星星都在为你指引方向。\n\n'
        '如果你想了解更具体的方面，可以告诉我你关心的领域，'
        '比如感情、事业、健康或财运，我会为你做更详细的解读。';
  }
}
