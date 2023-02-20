import 'package:firebase_report2/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Gender{Man, Woman}
enum Type{Dog, Cat}

class _RegisterPageState extends State<RegisterPage> {

  Gender _gender = Gender.Man;
  Type _type = Type.Dog;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController breedEditingController = TextEditingController();
  TextEditingController ageEditingController = TextEditingController();

  void addPets() async {
    await FirebaseFirestore.instance.collection('pet').add({
      '名前': nameEditingController.text,
      '品種': breedEditingController.text,
      '年齢': int.parse(ageEditingController.text),
      '性別': _gender == Gender.Man? 'オス' : 'メス',
      '種族': _type == Type.Dog? '犬' : '猫'
    });
    nameEditingController.clear();
    breedEditingController.clear();
    ageEditingController.clear();
  }
  _selectedType(value) {
    setState((){
      _type = value;
    });
  }
  _selectedGender(value) {
    setState((){
      _gender = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context){return const MyHomePage();})),
            icon:Icon(Icons.arrow_back),
        )
      ),
      body: Column(
        children: [
          TextField(
            controller: nameEditingController,
            decoration: InputDecoration(
              labelText: '名前',
                border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 20),
              RadioListTile(
              title: Text('犬'),
              value: Type.Dog,
              groupValue: _type,
              onChanged: (value) => _selectedType(value),
          ),
          RadioListTile(
            title: Text('猫'),
            value: Type.Cat,
            groupValue: _type,
            onChanged: (value) => _selectedType(value),
          ),
          TextField(
            controller: breedEditingController,
            decoration: InputDecoration(
                labelText: '品種',
                border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 20),
          RadioListTile(
            title: Text('オス'),
            value: Gender.Man,
            groupValue: _gender,
            onChanged: (value) => _selectedGender(value),
          ),
          RadioListTile(
            title: Text('メス'),
            value: Gender.Woman,
            groupValue: _gender,
            onChanged: (value) => _selectedGender(value),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: ageEditingController,
            decoration: InputDecoration(
                labelText: '年齢',
                border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              child: Text('登録'),
              onPressed: (){addPets();},
          )
        ],
      ),

    );
  }
}



