import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import 'message_list_item.dart';

part 'message_list_state.dart';

class MessageListCubit extends Cubit<MessageListState> {
  MessageListCubit() : super(const MessageListState());

  final _items = <int, MessageListItem>{};
  ChatScrollObserver? observer;

  Future<void> init() async {
    await Future.delayed(Duration.zero);
    loadMessages();
  }

  void resetMessages() async {
    emit(state.copyWith(status: MessageListStatus.updating));
    emit(state.copyWith(status: MessageListStatus.success));
  }

  Future<void> loadMessages() async {
    emit(state.copyWith(status: MessageListStatus.loading));

    //Imitate loading
    await Future.delayed(const Duration(seconds: 2));

    final items = List.generate(
        100,
        (index) => MessageListItem(
            id: index,
            fromUser: 'User №${index % 2}',
            fromUserId: index % 2,
            text: 'Text ' * (Random().nextInt(25) + 1),
            date: DateTime.now()
                .subtract(Duration(minutes: Random().nextInt(10))),
            own: index % 2 == 0,
            edited: false,
            readState: false));

    for (final element in items) {
      _items[element.id] = element;
    }

    observer?.observeSwitchShrinkWrap();
    emit(state.copyWith(
        status: MessageListStatus.success,
        items: _items.values.toList(growable: false),
        lastMessageId: 0));
  }

  Future<void> createMessage(VoidCallback? onCreate) async {
    emit(state.copyWith(status: MessageListStatus.updating));
    final last = _items.keys.lastOrNull ?? 0;

    _items[last + 1] = MessageListItem(
        id: last + 1,
        fromUser: 'User №${(last + 1) % 2}',
        fromUserId: (last + 1) % 2,
        text: 'New message ' * (Random().nextInt(25) + 1),
        date: DateTime.now().subtract(Duration(minutes: Random().nextInt(10))),
        own: (last + 1) % 2 == 0,
        edited: false,
        readState: false);

    onCreate?.call();
    emit(state.copyWith(
        status: MessageListStatus.success,
        items: _items.values.toList(growable: false)));
  }

  void deleteMessages({required int messageIds}) {
    emit(state.copyWith(status: MessageListStatus.updating));

    _items.remove(messageIds);

    emit(state.copyWith(
        status: MessageListStatus.success,
        items: _items.values.toList(growable: false)));
  }
}
