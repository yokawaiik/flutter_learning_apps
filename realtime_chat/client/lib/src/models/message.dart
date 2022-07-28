import 'package:intl/intl.dart';

class Message {
  late DateTime dateTime;
  late String uid;
  late String content;
  late bool isCurrentUser;

  Message({
    required this.dateTime,
    required this.uid,
    required this.content,
    this.isCurrentUser = false,
  });

  String get date {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  Message.fromMap(Map<String, dynamic> data, String currentUserUid) {
    dateTime = DateTime.fromMillisecondsSinceEpoch(data["dateTime"]);
    uid = data["uid"];
    content = data["content"];

    isCurrentUser = uid == currentUserUid ? true : false;
   
  }

  Map<String, dynamic> toMap() {
    return {
      "dateTime": dateTime.millisecondsSinceEpoch,
      "uid": uid,
      "content": content,
    };
  }
}
