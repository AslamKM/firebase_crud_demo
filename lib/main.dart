import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // brightness: Brightness.dark,
        // primaryColor: Colors.lightBlue[800],
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //   secondary: Colors.cyan[600],
        // ),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String name, description;
  late double price;
  getName(name) {
    this.name = name;
  }

  getDescription(description) {
    this.description = description;
  }

  getPrice(price) {
    this.price = double.parse(price);
  }

  createData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("dishes").doc(name);
    Map<String, dynamic> dish = {
      "name": name,
      "description": description,
      "price": price,
    };
    documentReference.set(dish).whenComplete(() {
      print("$name created");
    });
  }

  readData() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("dishes").doc(name);
    documentReference.get().then((datasnapshot) {
      print(datasnapshot.get('name'));
      print(datasnapshot.get('description'));
      print(datasnapshot.get('price'));
    });
  }

  updateData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("dishes").doc(name);
    Map<String, dynamic> dish = {
      "name": name,
      "description": description,
      "price": price,
    };
    documentReference.set(dish).whenComplete(() {
      print("$name updated");
    });
  }

  deleteData() {
    final documentReference =
        FirebaseFirestore.instance.collection("dishes").doc(name);

    documentReference.delete().whenComplete(() {
      print("$name deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Crud'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: "Name"),
              onChanged: (String name) {
                getName(name);
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: "Description"),
              onChanged: (String description) {
                getDescription(description);
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: "Price"),
              onChanged: (String price) {
                getPrice(price);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.ltr,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () {
                    createData();
                  },
                  child: const Text("Create"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    readData();
                  },
                  child: const Text("Read"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  ),
                  onPressed: () {
                    updateData();
                  },
                  child: const Text("Update"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    deleteData();
                  },
                  child: const Text("Delete"),
                ),
              ],
            ),
            Row(
              textDirection: TextDirection.ltr,
              children: const <Widget>[
                Expanded(
                  child: Text("Name"),
                ),
                Expanded(
                  child: Text("Description"),
                ),
                Expanded(
                  child: Text("Price"),
                )
              ],
            ),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("dishes").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return Row(
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
                              Expanded(
                                child: Text(documentSnapshot["name"]),
                              ),
                              Expanded(
                                child: Text(documentSnapshot["description"]),
                              ),
                              Expanded(
                                child:
                                    Text(documentSnapshot["price"].toString()),
                              )
                            ],
                          );
                        });
                  } else {
                    return const Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
