import 'dart:async';
import 'dart:ui';
import 'package:image/image.dart' as img;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onionchatflutter/viewmodel/post_authentication_cubit.dart';
import 'package:onionchatflutter/xmpp/xmpp_stone.dart';

import '../repository/avatar_repository.dart';
import '../xmpp/extensions/vcard_temp/VCard.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  final String username;
  final AvatarRepository repository;

  AvatarBloc(this.username, this.repository) : super(LoadingState()) {
    on<InitEvent>(onInit);
  }

  FutureOr<void> onInit(
      final InitEvent event, Emitter<AvatarState> emit) async {
    emit(ReadyState(await repository.fetchAvatar(username)));
  }
}

abstract class AvatarEvent {}

class InitEvent extends AvatarEvent {}

abstract class AvatarState {}

class LoadingState extends AvatarState {}

class ReadyState extends AvatarState {
  final img.Image image;

  ReadyState(this.image);
}