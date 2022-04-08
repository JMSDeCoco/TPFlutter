import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String idMessage;
  late String idSender;
  late String idRecever;
  late String text;
  late DateTime date;

  Message(DocumentSnapshot snapshot) {
    idMessage = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    idRecever = map["IDRECEVER"];
    idSender = map["IDSENDER"];
    text = map["TEXT"];
    idMessage = map["UID"];
    Timestamp timestamp = map["DATE"];
    date = timestamp.toDate();
  }
}
