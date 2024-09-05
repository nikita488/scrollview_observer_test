import 'package:equatable/equatable.dart';

class MessageListItem extends Equatable {
  const MessageListItem({
    required this.id,
    required this.fromUser,
    required this.fromUserId,
    required this.text,
    required this.date,
    required this.own,
    required this.edited,
    required this.readState,
  });

  final int id;
  final String fromUser;
  final int fromUserId;
  final String text;
  final DateTime date;
  final bool own;
  final bool edited;
  final bool readState;

  MessageListItem copyWith({
    int? id,
    String? fromUser,
    int? fromUserId,
    String? text,
    DateTime? date,
    bool? own,
    bool? edited,
    bool? readState,
  }) {
    return MessageListItem(
      id: id ?? this.id,
      fromUser: fromUser ?? this.fromUser,
      fromUserId: fromUserId ?? this.fromUserId,
      text: text ?? this.text,
      date: date ?? this.date,
      own: own ?? this.own,
      edited: edited ?? this.edited,
      readState: readState ?? this.readState,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props =>
      [id, fromUser, fromUserId, text, date, own, edited, readState];
}
