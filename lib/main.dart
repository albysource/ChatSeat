import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onionchatflutter/model/chat_info.dart';
import 'package:onionchatflutter/model/messages.dart';
import 'package:onionchatflutter/constants.dart';
import 'package:onionchatflutter/screens/login_screen.dart';
import 'package:onionchatflutter/screens/post_authentication_screen.dart';
import 'package:onionchatflutter/screens/signup_screen.dart';
import 'package:onionchatflutter/viewmodel/post_authentication_cubit.dart';
import 'package:onionchatflutter/xmpp/xmpp_stone.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final navigationKey =
      GlobalKey<NavigatorState>(debugLabel: "base-navigator");

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatMessage(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatCardsinfo(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: MyApp.navigationKey,
        debugShowCheckedModeBanner: false,
        title: 'OnionChat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: scaffold_color,
        ),
        initialRoute: LoginScreen.routeName,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case LoginScreen.routeName:
              return PageRouteBuilder(
                  pageBuilder: (context, a, b) => LoginScreen());
            case SignUpScreen.routeName:
              return PageRouteBuilder(
                  pageBuilder: (context, a, b) => const SignUpScreen());
            case PostAuthenticationScreen.routeName:
              final AuthenticatedArguments arguments =
                  settings.arguments as AuthenticatedArguments;
              return PageRouteBuilder(pageBuilder: (context, a, b) {
                return BlocProvider(
                  create: (ctx) => PostAuthenticationCubit(
                      InitialState(), arguments.connection),
                  child: PostAuthenticationScreen(
                      username: arguments.connection.account.fullJid.local ??
                          "Unknown"),
                );
              });
          }
        },
      ),
    );
  }
}

class AuthenticatedArguments {
  final Connection connection;

  AuthenticatedArguments(this.connection);
}
