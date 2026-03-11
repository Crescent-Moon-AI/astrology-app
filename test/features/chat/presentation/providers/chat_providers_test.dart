import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/features/chat/presentation/providers/chat_providers.dart';

void main() {
  group('ChatMessagesNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('addUserMessage generates unique UUIDs', () {
      final notifier =
          container.read(chatMessagesProvider('conv-1').notifier);

      notifier.addUserMessage('Hello');
      notifier.addUserMessage('World');

      final messages = container.read(chatMessagesProvider('conv-1'));
      expect(messages.length, 2);
      expect(messages[0].id, isNot(messages[1].id));

      // Verify UUID v4 format (8-4-4-4-12 hex)
      final uuidRegex = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(messages[0].id, matches(uuidRegex));
      expect(messages[1].id, matches(uuidRegex));
    });

    test('ensureAssistantMessage does not duplicate', () {
      final notifier =
          container.read(chatMessagesProvider('conv-1').notifier);

      notifier.ensureAssistantMessage('msg-1');
      notifier.ensureAssistantMessage('msg-1');

      final messages = container.read(chatMessagesProvider('conv-1'));
      expect(messages.length, 1);
    });

    test('addExistingMessage skips duplicates', () {
      final notifier =
          container.read(chatMessagesProvider('conv-1').notifier);

      notifier.addUserMessage('test');
      final messages = container.read(chatMessagesProvider('conv-1'));
      final existingMsg = messages.first;

      notifier.addExistingMessage(existingMsg);

      final updated = container.read(chatMessagesProvider('conv-1'));
      expect(updated.length, 1);
    });
  });
}
