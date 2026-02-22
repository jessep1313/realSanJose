import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/model/conversation.dart';

import '../model/chartmessage.dart';

final chatProvider = ChangeNotifierProvider.autoDispose<ChatProvider>(
  (ref) => ChatProvider(),
);

class ChatProvider with ChangeNotifier {
  var conversationList = [
    Conversation('assets/images/specialist1.jpg', 'Ram Prasad',
        'Lorem ipsum dolor sit amet.', '1 min ago', false),
    Conversation('assets/images/specialist2.jpg', 'Binod Sharma',
        'Lorem ipsum dolor sit amet.', '10 min ago', true),
    Conversation('assets/images/specialist3.jpg', 'Mark  Zarkerton',
        'Lorem ipsum dolor sit amet.', 'yestarday', false),
    Conversation('assets/images/specialist4.jpg', 'Liory Hamber',
        'Lorem ipsum dolor sit amet.', '6 min ago', true),
    Conversation('assets/images/specialist5.jpg', 'Natt Derenian',
        'Lorem ipsum dolor sit amet.', '1 min ago', false),
    Conversation('assets/images/specialist6.jpg', 'Jirna Loyed',
        'Lorem ipsum dolor sit amet.', '1 min ago', true),
  ];

  List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "Hello", messageType: "receiver", time: 'SAT 8:30 PM'),
    ChatMessage(
        messageContent: "How are you? How are you ?K xa khabar thik xa kbr",
        messageType: "receiver",
        time: 'SAT 8:31 PM'),
    ChatMessage(
        messageContent: "I am fine,and you",
        messageType: "sender",
        time: 'SAT 8:32 PM'),
    ChatMessage(
        messageContent: "ehhhh, doing OK.",
        messageType: "receiver",
        time: 'SAT 8:32 PM'),
    ChatMessage(
        messageContent: "Is there any thing wrong?",
        messageType: "sender",
        time: 'SAT 8:33 PM'),
  ];
}
