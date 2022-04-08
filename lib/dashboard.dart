import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapplicationsqyavril2022/chatPage.dart';
import 'package:firstapplicationsqyavril2022/fonctions/firestoreHelper.dart';
import 'package:firstapplicationsqyavril2022/library/constants.dart';
import 'package:firstapplicationsqyavril2022/model/utilisateur.dart';
import 'package:firstapplicationsqyavril2022/widgets/myDrawer.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  String uid;

  DashBoard({required this.uid});

  @override
  State<StatefulWidget> createState() {
    return DashBoardState();
  }
}

class DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    print(profilUser.uid);

    return Scaffold(
      drawer: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 1.5,
        color: Colors.blue,
        child: myDrawer(),
      ),
      appBar: AppBar(
        title: const Text("Ma Nouvelle page"),
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_user.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            List documents = snapshot.data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  Utilisateur user = Utilisateur(documents[index]);
                  if (profilUser.uid == user.uid) {
                    return Container();
                  }
                  return Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Hero(
                        tag: user.uid,
                        child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            )),
                      ),
                      title: Text("${user.prenom} ${user.nom}"),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ChatPage(user: user);
                        }));
                      },
                    ),
                  );
                });
          }
        });
  }
}
