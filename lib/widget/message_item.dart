import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_chat/core/models/chat_model.dart';
import 'package:socket_chat/utils/margin.dart';
import 'package:socket_chat/utils/timeago.dart';

class MessageItem extends StatelessWidget {
  final bool isMe;
  final ChatModel message;
  const MessageItem({
    Key key,
    this.isMe = false,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? 'Me' : message?.username ?? '',
            style: GoogleFonts.manrope(
                color: isMe ? Colors.grey : Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          const YMargin(10),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: (isMe ? Colors.white : Colors.black).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    message?.message ?? '',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(isMe ? 1 : 0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const YMargin(3),
          Text(
            '${timeAgoSinceDate(message?.timestamp ?? DateTime.now())}',
            style: GoogleFonts.manrope(
                color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
