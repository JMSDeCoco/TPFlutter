import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapplicationsqyavril2022/library/constants.dart';
import 'package:flutter/material.dart';
import 'fonctions/firestoreHelper.dart';
import 'model/message.dart';
import 'model/utilisateur.dart';

class ChatPage extends StatefulWidget {
  Utilisateur user;
  ChatPage({required this.user});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController msgController = new TextEditingController();
  late ScrollController controller = ScrollController();
  late String content;

  Future scrollToItem() async {
    controller.jumpTo(controller.position.maxScrollExtent * 1.5);
  }

  @override
  void initState() {
    super.initState();
    msgController.addListener(() {
      setState(() {}); // setState every time text changes
    });
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                radius: 20,
              ),
            ),
            Column(
              children: [Text(widget.user.prenom)],
            ),
          ],
        ),
      ),
      body: bodyPage(),
      bottomSheet: Container(
          width: size.width,
          color: Colors.white,
          child: Container(
            height: 100,
            width: Size.infinite.width,
            child: Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Write message"),
                      controller: msgController,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (msgController.text.isNotEmpty) {
                      String uid = profilUser.uid;
                      Map<String, dynamic> map = {
                        "IDRECEVER": widget.user.uid,
                        "IDSENDER": profilUser.uid,
                        "UID": uid,
                        "TEXT": msgController.text,
                        "DATE": DateTime.now()
                      };
                      FirestoreHelper().addMessage(uid, map);
                      msgController.clear();
                      setState(() {
                        scrollToItem();
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.send,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget bodyPage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_message.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            List documents = snapshot.data!.docs;
            List<Message> messages = [];
            documents.forEach((element) {
              Message msg = Message(element);
              if (((profilUser.uid == msg.idSender) &&
                      (widget.user.uid == msg.idRecever)) |
                  ((profilUser.uid == msg.idRecever) &&
                      (widget.user.uid == msg.idSender))) {
                messages.add(msg);
              }
            });
            messages.sort(((a, b) => a.date.compareTo(b.date)));

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: controller,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (profilUser.uid == messages[index].idSender) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Flexible(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color.fromARGB(
                                              255, 93, 173, 238)),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          messages[index].text,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 15,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (profilUser.uid == messages[index].idRecever) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flexible(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Color.fromARGB(255, 216, 213, 213)),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        messages[index].text,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  }),
            );
          }
        });
  }
}
