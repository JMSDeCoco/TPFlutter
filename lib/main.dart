import 'package:firstapplicationsqyavril2022/dashboard.dart';
import 'package:firstapplicationsqyavril2022/fonctions/firestoreHelper.dart';
import 'package:firstapplicationsqyavril2022/library/constants.dart';
import 'package:firstapplicationsqyavril2022/registerPage.dart';
import 'package:firstapplicationsqyavril2022/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAA1yJuUrlr60CerwbeVsxqy0wxB7Er5fs",
          appId: "1:957021119476:web:ef852b2dfef65f746f0fa1",
          messagingSenderId: "957021119476",
          projectId: "projettpipssinicolasdenis",
          storageBucket: "projettpipssinicolasdenis.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patto el mexicano',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Patto el mexicano'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
//Variable
  late String mail;
  late String password;
  late String uid;
  late Animation animation;
  late AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      reverseDuration: const Duration(seconds: 5),
    );
    controller.repeat();

    animation = Tween<double>(begin: 150, end: 200).animate(controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            Background(),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: bodyPage(),
              ),
            )
          ],
        ));
  }

  Widget bodyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: controller.value,
              child: child,
            );
          },
          child: Container(
            height: 250,
            width: 250,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:
                      AssetImage("assets/Duval méxicain-LAPTOP-LMFD4HT9.png"),
                  fit: BoxFit.fill,
                )),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail),
            hintText: "Taper votre adresse mail",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onChanged: (value) {
            setState(() {
              mail = value;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_rounded),
            hintText: "Taper votre mot de passe",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          obscureText: true,
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.amber,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            FirestoreHelper().connect(mail, password).then((value) {
              setState(() {
                FirestoreHelper().getIdenfiant().then((value) {
                  setState(() {
                    uid = value;
                  });

                  FirestoreHelper().getUtilisateur(uid).then((value) {
                    setState(() {
                      profilUser = value;
                    });
                  });
                });
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DashBoard(uid: uid);
              }));
            }).onError((error, stackTrace) {
              print("Problème de connexion");
            });
          },
          child: const Text("Connexion"),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          child: const Text(
            "Inscription",
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return registerPage();
            }));
          },
        )
      ],
    );
  }
}
