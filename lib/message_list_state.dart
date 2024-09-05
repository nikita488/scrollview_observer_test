part of 'message_list_cubit.dart';

enum MessageListStatus {
  initial,
  loading,
  updating,
  success,
  failure;

  bool get isLoading => this == loading;
  bool get isUpdating => this == updating;
  bool get isSuccess => this == success;
  bool get isFailure => this == failure;
}

class MessageListState extends Equatable {
  const MessageListState(
      {this.status = MessageListStatus.initial,
      this.error,
      this.items = const [],
      this.lastMessageId = 0});

  final MessageListStatus status;
  final Object? error;
  final List<MessageListItem> items;
  final int lastMessageId;

  MessageListState copyWith(
      {MessageListStatus? status,
      Object? error,
      List<MessageListItem>? items,
      int? lastMessageId}) {
    return MessageListState(
      status: status ?? this.status,
      error: error ?? this.error,
      items: items ?? this.items,
      lastMessageId: lastMessageId ?? this.lastMessageId,
    );
  }

  @override
  List<Object?> get props => [status, error, items.length, lastMessageId];
}
