import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message {
  late final String id;
  late final String date;
  late final String text;
  late final String uid;
  late final bool isCurrentUser;

  Message(QueryDocumentSnapshot<Map<String, dynamic>> doc);

  Message.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc, String currentUserId) {
    id = doc.id;

    uid = doc.data()["uid"];
    isCurrentUser = uid == currentUserId ? true : false;
    date = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(
        (doc.data()["date"] as Timestamp).seconds * 1000));
    text = doc.data()["text"];
  }
}
