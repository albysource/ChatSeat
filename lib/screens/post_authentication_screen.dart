import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onionchatflutter/repository/avatar_repository.dart';
import 'package:onionchatflutter/screens/chat_screen.dart';
import 'package:onionchatflutter/screens/contacts_screen.dart';
import 'package:onionchatflutter/viewmodel/channels_bloc.dart';
import 'package:onionchatflutter/viewmodel/messenger_bloc.dart';
import 'package:onionchatflutter/viewmodel/post_authentication_cubit.dart';

class PostAuthenticationScreen extends StatefulWidget {
  static const routeName = "/authenticated";
  static const navigatorKey = Key("post-auth-nav");
  final String username;

  const PostAuthenticationScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PostAuthenticationScreenState();
  }

}

class _PostAuthenticationScreenState extends State<PostAuthenticationScreen> {
  @override
  void initState() {
    BlocProvider.of<PostAuthenticationCubit>(context).initialize(widget.username);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostAuthenticationCubit, PostAuthenticationState> (
        builder: (ctx, state) {
          if (state is ReadyState) {
            return Navigator(
              key: PostAuthenticationScreen.navigatorKey,
              initialRoute: ContactsScreen.routeName,
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case ChatScreen.routeName:
                    final chatArgs = settings.arguments as ChatScreenArguments;
                    return PageRouteBuilder(
                        pageBuilder: (context, a, b) => BlocProvider(
                          create: (ctx) => MessengerBloc(state.messenger, chatArgs.channelId),
                          child: ChatScreen(chatScreenArguments: chatArgs),
                        )
                    );
                  case ContactsScreen.routeName:
                  default:
                    return PageRouteBuilder(
                        pageBuilder: (context, a, b) => BlocProvider(
                            create: (ctx) => ChannelsBloc(state.messenger),
                          child: ContactsScreen(selfUserId: state.messenger.username, repository: state.avatarRepository),
                        )
                    );
                }
              },
            );
          }
          return const CircularProgressIndicator();
        }
    );
  }

  @override
  void dispose() {
    final cubit = BlocProvider.of<PostAuthenticationCubit>(context);
    final state = cubit.state;
    if (state is ReadyState) {
      state.messenger.dispose();
    }
    super.dispose();
  }

}
