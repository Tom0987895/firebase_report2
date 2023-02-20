import 'dart:async';
import 'package:firebase_report2/register.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_report2/dog.dart';
import 'package:firebase_report2/cat.dart';
import 'package:firebase_report2/ascending.dart';
import 'package:firebase_report2/descending.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Query',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
enum Query{Pet, Dog, Cat, AgeAscending, AgeDescending}
Query queryValue = Query.Dog;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Stream<QuerySnapshot> petStream =
  FirebaseFirestore.instance.collection('pet').snapshots();

  void popupMenuSelected(Query selectedMenu){
    switch(selectedMenu){
      case Query.Dog:
        Navigator.of(context).push(MaterialPageRoute(builder: (context){return const DogPage();}));
        break;
      case Query.Cat:
        Navigator.of(context).push(MaterialPageRoute(builder: (context){return const CatPage();}));
        break;
      case Query.AgeAscending:
        Navigator.of(context).push(MaterialPageRoute(builder: (context){return const AscendingPage();}));
        break;
      case Query.AgeDescending:
        Navigator.of(context).push(MaterialPageRoute(builder: (context){return const DescendingPage();}));
        break;
      case Query.Pet:
        Navigator.of(context).push(MaterialPageRoute(builder: (context){return const MyHomePage();}));
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Query'),
          actions: [
            PopupMenuButton<Query>(
              initialValue: queryValue,
              onSelected: popupMenuSelected,
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<Query>>[
                PopupMenuItem<Query>(
                  value: Query.Pet,
                  child: Text('全て'),
                ),
                PopupMenuItem<Query>(
                  value: Query.Dog,
                  child: Text("犬のみ"),

                ),
                PopupMenuItem<Query>(
                  value: Query.Cat,
                  child: Text('猫のみ'),
                ),
                PopupMenuItem<Query>(
                  value: Query.AgeAscending,
                  child: Text('年齢: 昇順'),
                ),
                PopupMenuItem<Query>(
                  value: Query.AgeDescending,
                  child: Text('年齢: 降順'),
                ),
              ],
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: petStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> petsData = snapshot.data!.docs;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: petsData.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> petData = petsData[index]
                                  .data()! as Map<String, dynamic>;
                              return petsCard(petData);
                            }
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator(),);
                  }
              ),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () =>
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const RegisterPage();
                        })),
              )
            ],
          ),
        )
    );
  }
}



class PetData extends StatelessWidget {
  const PetData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Widget petsCard(Map<String, dynamic> petData){
  return Card(
    child: ListTile(
      title: Text('名前：${petData['名前']}　品種：${petData['品種']}　性別：${petData['性別']}　年齢：${petData['年齢']}'
      )
    ),
  );
}


