import 'dart:async';
import 'package:collection/collection.dart';

import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onionchatflutter/model/chat_channel.dart';
import 'package:onionchatflutter/model/chat_message.dart';
import 'package:onionchatflutter/util/connection_helper.dart';
import 'package:onionchatflutter/viewmodel/messenger_service.dart';


class ChannelsBloc extends Bloc<ChannelsEvent, ChannelsState> {
  final Messenger _messenger;
  ChannelsBloc(this._messenger) : super(UninitializedState()) {
    on<InitEvent>(onInit);
    on<FetchEvent>(onFetch);
    on<CreateChannelEvent>(onCreateChannel);
    on<AddChannelEvent>(onAddChannel);
    on<ChannelMessageAddedEvent>(onChannelMessageAdded);
    on<ChannelClosedEvent>(onChannelClose);
    on<LogoutEvent>(onLogout);
  }

  FutureOr<void> onLogout(
      final LogoutEvent event, Emitter<ChannelsState> emit) async {
    _messenger.logout();
  }

  FutureOr<void> onInit(final InitEvent event, Emitter<ChannelsState> emit) async {
    final List<ChatChannel> channels = await _messenger.fetchChannels(0, 10);
    emit(LoadedState(channels, channels.length < 10));
    _messenger.channelCreations.listen((event) {
        add(AddChannelEvent(event));
    });
    StreamGroup.merge([_messenger.incomingMessages, _messenger.outgoingMessages]).listen((event) {
      final stateC = state;
      if (stateC is! LoadedState) {
        return;
      }
      final channel = stateC.channels.firstWhereOrNull((element) => element.name == event.channelName);
      if (channel == null) {
        return;
      }
      add(ChannelMessageAddedEvent(channel, event));
    });
  }

  FutureOr<void> onFetch(final FetchEvent event, Emitter<ChannelsState> emit) async {
    final stateC = state;
    if (stateC is! LoadedState) {
      return;
    }
    final List<ChatChannel> channels = await _messenger.fetchChannels(stateC.channels.length, 10);
    stateC.channels.addAll(channels);
    emit(LoadedState(stateC.channels, channels.length < 10));
  }

  FutureOr<void> onCreateChannel(final CreateChannelEvent event, Emitter<ChannelsState> emit) async {
    await _messenger.createChannel(event.channelId);
  }

  FutureOr<void> onAddChannel(final AddChannelEvent event, Emitter<ChannelsState> emit) async {
    final stateC = state;
    if (stateC is! LoadedState) {
      return;
    }
    stateC.channels.add(event.channel);
    emit(LoadedState(stateC.channels, stateC.completedLoading));
  }

  FutureOr<void> onChannelMessageAdded(final ChannelMessageAddedEvent event, Emitter<ChannelsState> emit) async {
    final stateC = state;
    if (stateC is! LoadedState) {
      return;
    }
    final msg = event.message;
    event.channel.unreadCount = (event.channel.unreadCount ?? 0) + 1;
    if (msg is TextMessage) {
      if (msg.from == _messenger.username) {
        event.channel.lastMessage = "you: ${msg.message}";
      } else {
        event.channel.lastMessage = msg.message;
      }
    }
    emit(LoadedState(stateC.channels, stateC.completedLoading));
  }

  FutureOr<void> onChannelClose(final ChannelClosedEvent event, Emitter<ChannelsState> emit) async {
    final stateC = state;
    if (stateC is! LoadedState) {
      return;
    }
    event.channel.unreadCount = 0;
    await _messenger.updateLastSeen(event.channel.name);
    emit(LoadedState(stateC.channels, stateC.completedLoading));
  }

}

abstract class ChannelsEvent {}

class LogoutEvent extends ChannelsEvent {}

class InitEvent extends ChannelsEvent {}

class FetchEvent extends ChannelsEvent {}

class CreateChannelEvent extends ChannelsEvent {
  final String channelId;

  CreateChannelEvent(this.channelId);
}

class AddChannelEvent extends ChannelsEvent {
  final ChatChannel channel;

  AddChannelEvent(this.channel);
}

class ChannelMessageAddedEvent extends ChannelsEvent {
  final ChatChannel channel;
  final Message message;

  ChannelMessageAddedEvent(this.channel, this.message);
}

class ChannelClosedEvent extends ChannelsEvent {
  final ChatChannel channel;

  ChannelClosedEvent(this.channel);
}

abstract class ChannelsState {}

class UninitializedState extends ChannelsState {}

class LoadedState extends ChannelsState {
  final List<ChatChannel> channels;
  bool completedLoading;

  LoadedState(this.channels, this.completedLoading);
}