import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onionchatflutter/constants.dart';
import 'package:onionchatflutter/screens/Scan_Qr.dart';
import 'package:onionchatflutter/xmpp/Connection.dart';
import 'package:onionchatflutter/xmpp/xmpp_stone.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../repository/avatar_repository.dart';
import '../viewmodel/avatar_bloc.dart';
import 'avatar_widget.dart';

class NavDrawer extends StatefulWidget {
  final String username;
  final AvatarRepository repository;
  final void Function() onLogout;
  const NavDrawer({
    Key? key,
    required this.username,
    required this.onLogout,
    required this.repository
  }) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // Implement a function to change the profile photo of the user
  // and also the QR buttons and LogOut button

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 50,
        backgroundColor: const Color(0xffF7ECF8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hey there, ',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: FontFamily_main,
                    color: nav_secondary,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                // Replace with the username of the current user.
                widget.username,
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: FontFamily_main,
                    foreground: Paint()..shader = nameHeadingGradient,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 38,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: dark_accent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('Assets/Test_images/vshnv.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: BlocProvider(
                              create: (ctx) => AvatarBloc(widget.username, widget.repository),
                              child: AvatarWidget(radius: 30)),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () {
                          print('edit button pressed');
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          // color: Theme.of(context).accentColor,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(width: 3, color: dark_accent),
                            image: const DecorationImage(
                              image: AssetImage('Assets/Icons/editIcon.png'),
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 41,
                            minHeight: 41,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 64,
                thickness: 3,
                color: Color(0xffE2DBE6),
              ),
              TextButton.icon(
                onPressed: () {
                  // Show QR function here

                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      // title: Text("Scan QR cod"),
                      content: Container(
                        height: 270,
                        width: 200,
                        child: Column(
                          children: [
                            Center(
                              child: QrImage(
                                data: widget.username,
                                size: 200,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              // Replace with the username of the current user.
                              widget.username,
                              style: TextStyle(
                                  fontSize: 26,
                                  fontFamily: FontFamily_main,
                                  foreground: Paint()
                                    ..shader = nameHeadingGradient,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: Image.asset('Assets/Icons/qrIcon.png'),
                label: const Text(
                  'Show QR',
                  style: TextStyle(
                    // add Roboto font here.
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: nav_secondary,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Scan QR function here
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => ScanQR()));
                },
                icon: Image.asset('Assets/Icons/qrIcon.png'),
                label: const Text(
                  'Scan QR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: nav_secondary,
                  ),
                ),
              ),
              const Divider(
                height: 64,
                thickness: 3,
                color: Color(0xffE2DBE6),
              ),
              TextButton.icon(
                onPressed: widget.onLogout,
                icon: Image.asset('Assets/Icons/LogoutIcon.png'),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    // add Roboto font here.
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: nav_secondary,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
