import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onionchatflutter/constants.dart';
import 'package:onionchatflutter/repository/avatar_repository.dart';
import 'package:onionchatflutter/screens/chat_screen.dart';
import 'package:onionchatflutter/screens/login_screen.dart';
import 'package:onionchatflutter/viewmodel/channels_bloc.dart';
import 'package:onionchatflutter/widgets/nav_drawer.dart';

import '../viewmodel/avatar_bloc.dart' as avatar;
import '../widgets/avatar_widget.dart';
import '../widgets/chat_cards.dart';

class ContactsScreen extends StatefulWidget {
  static const routeName = '/contacts';
  final AvatarRepository repository;
  final String selfUserId;

  const ContactsScreen({Key? key, required this.selfUserId, required this.repository}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _userID = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<ChannelsBloc>(context).add(InitEvent());
    super.initState();
  }

  @override
  void activate() {
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        repository: widget.repository,
        username: widget.selfUserId,
        onLogout: () {
          BlocProvider.of<ChannelsBloc>(context).add(LogoutEvent());
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
        },
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                          print('Nav Drawer');
                        },
                        child: Image.asset('Assets/Icons/NavDrawerIcon.png'));
                  }),
                  const Text(
                    'Chats',
                    style: TextStyle(
                        fontFamily: FontFamily_main,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: heading_color),
                  ),
                  BlocProvider(
                      create: (ctx) => avatar.AvatarBloc(widget.selfUserId, widget.repository),
                      child: AvatarWidget(radius: 30)),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocBuilder<ChannelsBloc, ChannelsState>(
                  builder: (ctx, bloc) {
                if (bloc is LoadedState) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        bloc.channels.length + (bloc.completedLoading ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (!bloc.completedLoading &&
                          index >= bloc.channels.length) {
                        BlocProvider.of<ChannelsBloc>(context)
                            .add(FetchEvent());
                        return const CircularProgressIndicator();
                      }
                      final ch = bloc.channels[index];
                      String name = ch.name;
                      String latestMessage = ch.lastMessage ?? "-";
                      String imageUrl = ch.avatarFilePath;
                      int unreadMessages = ch.unreadCount ?? 0;
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ChatScreen.routeName,
                                  arguments: ChatScreenArguments(
                                      name, imageUrl, name, widget.selfUserId))
                              .then((value) {
                              BlocProvider.of<ChannelsBloc>(context).add(ChannelClosedEvent(ch));
                          });
                        },
                        child: ChatCards(
                            name: name,
                            latestMessage: latestMessage,
                            imageUrl: imageUrl,
                            unreadMessages: unreadMessages,
                            repository: widget.repository
                        ),
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext c) => AlertDialog(
                    title: const Text(
                      "Add new contact",
                      style: TextStyle(
                        fontFamily: FontFamily_main,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SizedBox(
                      height: 180,
                      child: Column(
                        children: [
                          const Text(
                            'Enter user ID',
                            style: TextStyle(
                              fontFamily: FontFamily_main,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              hintText: 'Enter username',
                              fillColor: Color(0xffE5E5E5),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: text_field_color, width: 3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                            controller: _userID,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ChannelsBloc>(context)
                                    .add(CreateChannelEvent(_userID.text));
                                if (kDebugMode) {
                                  print('Add new contacts here');
                                }
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Navigator.of(c).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xff822FAF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text("Add Contact",
                                  style: TextStyle(
                                    fontFamily: FontFamily_main,
                                  )))
                        ],
                      ),
                    ),
                  ));

          _userID.clear();
        },
        child: Image.asset('Assets/Icons/AddContacts.png'),
      ),
    );
  }
}

/**
 * Consumer<ChatCardsinfo>(
    builder: ((context, value, child) {
    return ListView.builder(
    itemCount: value.chatInfo.length,
    itemBuilder: (context, index) {
    String name = value.chatInfo[index].name;
    String latestMessage =
    value.chatInfo[index].latestMessage;
    String imageUrl = value.chatInfo[index].imageUrl;
    int unreadMessages =
    value.chatInfo[index].unreadMessageCounter;
    return ChatCards(
    name: name,
    latestMessage: latestMessage,
    imageUrl: imageUrl,
    unreadMessages: unreadMessages);
    },
    );
    }),
    )
 *
 * */
