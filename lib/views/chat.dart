import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_chat/core/provider_registry.dart';
import 'package:socket_chat/utils/margin.dart';
import 'package:socket_chat/utils/theme.dart';
import 'package:socket_chat/widget/text_field.dart';

class ChatSection extends StatefulHookWidget {
  @override
  _ChatSectionState createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  @override
  Widget build(BuildContext context) {
    var provider = useProvider(mapVM);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            FluentIcons.arrow_left_28_filled,
          ),
          onPressed: () {
            context.read(mapVM).tabController.animateTo(0);
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Messages',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 19,
              ),
            ),
            if (provider.typing.isNotEmpty) ...[
              const YMargin(4),
              Text(
                provider.typing,
                style: GoogleFonts.manrope(
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                ),
              ),
            ]
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.all(16),
                children: [...provider.messages],
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: FlatTextField(),
            ),
          ],
        ),
      ),
    );
  }
}
