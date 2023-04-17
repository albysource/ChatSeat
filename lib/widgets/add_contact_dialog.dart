import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onionchatflutter/constants.dart';
import 'package:onionchatflutter/screens/contacts_screen.dart';

import '../viewmodel/channels_bloc.dart';

class AddContactDialog extends StatefulWidget {
  static const routeName = '/popup';
  AddContactDialog({Key? key}) : super(key: key);

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _userID = TextEditingController();

  // @override
  // void initState() {
  //   BlocProvider.of<ChannelsBloc>(context).add(InitEvent());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add new contact",
        style: TextStyle(
          fontFamily: FontFamily_main,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        height: 180,
        child: Column(
          children: [
            Text(
              'Enter user ID',
              style: TextStyle(
                fontFamily: FontFamily_main,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                hintText: 'Enter username',
                fillColor: Color(0xffE5E5E5),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: text_field_color, width: 3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              controller: _userID,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ChannelsBloc>(context)
                      .add(CreateChannelEvent(_userID.text));
                  if (kDebugMode) {
                    print('Add new contacts here');
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff822FAF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text("Add Contact",
                    style: TextStyle(
                      fontFamily: FontFamily_main,
                    )))
          ],
        ),
      ),
    );
  }
}
