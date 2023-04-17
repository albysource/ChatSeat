import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:onionchatflutter/constants.dart';
import 'package:onionchatflutter/viewmodel/messenger_bloc.dart';
import 'package:onionchatflutter/widgets/attachment_message.dart';
import 'package:onionchatflutter/widgets/audio_message.dart';
import 'package:onionchatflutter/widgets/image_message.dart';
import 'package:onionchatflutter/widgets/normal_message.dart';
import '../model/chat_message.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/ChatScreen';
  final ChatScreenArguments chatScreenArguments;

  const ChatScreen({Key? key, required this.chatScreenArguments})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DateFormat _format = DateFormat("dd-MM-yyyy HH:mm:ss a");
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  StreamSubscription? _subscription;
  @override
  void initState() {
    BlocProvider.of<MessengerBloc>(context).add(MessengerInitEvent());
    // _subscription = BlocProvider.of<MessengerBloc>(context).stream.listen((state) {
    //   if (mounted && state is LoadedMessengerState) {
    //    _scrollJumpDown();
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7ECF8),
      body: GestureDetector(
        onTap: (() {
          FocusScope.of(context).requestFocus(FocusNode());
        }),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset('Assets/Icons/BackIcon.png'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    radius: 30,
                    foregroundImage:
                        AssetImage(widget.chatScreenArguments.imageUrl),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.chatScreenArguments.name,
                      style: const TextStyle(
                        fontFamily: FontFamily_main,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  width: double.infinity,
                  // height: 750,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 8,
                        blurRadius: 16,
                        offset:
                            const Offset(0, -5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<MessengerBloc, MessengerState>(
                          builder: (context, state) {
                            if (state is LoadingMessengerState) {
                              return const CircularProgressIndicator();
                            } else if (state is ErrorMessengerState) {
                              return const Text("Error");
                            } else if (state is LoadedMessengerState) {
                              final count = state.messages.length +
                                  (state.completedLoading ? 0 : 1);
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: count,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  final actualIndex = count -
                                      index -
                                      (state.completedLoading ? 0 : 1) -
                                      1;
                                  if (!state.completedLoading &&
                                      index == count - 1) {
                                    log("Loading more messages");
                                    BlocProvider.of<MessengerBloc>(context)
                                        .add(MessageFetchEvent());
                                    return Container(
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(),
                                    );
                                  }
                                  final Message msg =
                                      state.messages[actualIndex];
                                  switch (msg.type) {
                                    case MessageType.TEXT:
                                      return Normal_message(
                                          sendType: msg.from ==
                                                  widget.chatScreenArguments
                                                      .selfUserId
                                              ? "sent"
                                              : "received",
                                          message: (msg as TextMessage).message,
                                          time: _format.format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  msg.timestamp)));

                                    case MessageType.FILE:
                                      return Attachment_message(
                                          sendType: msg.from ==
                                                  widget.chatScreenArguments
                                                      .selfUserId
                                              ? "sent"
                                              : "received",
                                          url: (msg as DownloadableMessage).url,
                                          time: _format.format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  msg.timestamp)));
                                    case MessageType.IMAGE:
                                      return ImageMessage(
                                          sendType: msg.from ==
                                                  widget.chatScreenArguments
                                                      .selfUserId
                                              ? "sent"
                                              : "received",
                                          url: (msg as DownloadableMessage).url,
                                          time: _format.format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  msg.timestamp)));
                                    case MessageType.AUDIO:
                                      return AudioMessage(
                                          sendType: msg.from ==
                                                  widget.chatScreenArguments
                                                      .selfUserId
                                              ? "sent"
                                              : "received",
                                          url: (msg as DownloadableMessage).url,
                                          time: _format.format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  msg.timestamp)));
                                  }
                                },
                              );
                            }
                            return const Text("...");
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      print('Record start');
                                    },
                                    onTap: () {
                                      print('Record start');
                                    },
                                    child: Image.asset(
                                        'Assets/Icons/microphone.png'),
                                  ),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    print('Sent attachment');
                                  },
                                  child: Image.asset(
                                      'Assets/Icons/attachIcon.png'),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                hintText: 'Type something...',
                                fillColor: Color(0xffE5E5E5),
                                filled: true,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: text_field_color, width: 3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_messageController.text.isEmpty ||
                                  _messageController.text.trim().isEmpty) {
                                return;
                              } else {
                                final bloc =
                                    BlocProvider.of<MessengerBloc>(context);
                                bloc.add(MessageSendEvent(TextMessage(
                                    from: widget.chatScreenArguments.selfUserId,
                                    channelName:
                                        widget.chatScreenArguments.channelId,
                                    timestamp:
                                        DateTime.now().millisecondsSinceEpoch,
                                    message: _messageController.text.trim())));
                                setState(() {
                                  _messageController.clear();
                                });
                              }
                            },
                            child: Image.asset('Assets/Icons/Sent button.png'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollJumpDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}

class ChatScreenArguments {
  final String selfUserId;
  final String channelId;
  final String imageUrl;
  final String name;

  ChatScreenArguments(
      this.channelId, this.imageUrl, this.name, this.selfUserId);
}

/*
* Consumer<ChatMessage>(
                            builder: (context, Messages, index) {
                          return ListView.builder(
                            // controller: _controller,
                            reverse: true,
                            itemCount: Messages.SpoofMessages.length,
                            itemBuilder: (context, index) {
                              final reversedIndex =
                                  Messages.SpoofMessages.length - 1 - index;
                              String message =
                                  Messages.SpoofMessages[reversedIndex].message;
                              String time =
                                  Messages.SpoofMessages[reversedIndex].time;
                              String sendType = Messages
                                  .SpoofMessages[reversedIndex].sendType;
                              String type =
                                  Messages.SpoofMessages[reversedIndex].type;
                              String attachmentUrl = Messages
                                  .SpoofMessages[reversedIndex].attachmentUrl;
                              if (type == 'recording') {
                                return AudioMessage();
                              } else if (type == 'attachment') {
                                return Attachment_message(
                                  sendType: sendType,
                                  url: attachmentUrl,
                                  time: time,
                                );
                              } else {
                                return Normal_message(
                                  sendType: sendType,
                                  message: message,
                                  time: time,
                                );
                              }
                            },
                          );
                        }
                            // child:
                            )
*
* */