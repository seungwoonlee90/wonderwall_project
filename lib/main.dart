import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MaterialApp(
      theme: style.theme,
      home : MyApp())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'ethan');
    var stResult = storage.get('name');
    print(stResult);
  }

  getData() async {
    var res = await http.get(Uri.parse('https://yts.mx/api/v2/list_movies.json'));
    var result = jsonDecode(res.body);
    if (res.statusCode == 200) {
      setState((){
        data = result['data']['movies'];
      });
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveData();
    var data = getData();
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wonderwall"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async{
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if(image != null) {
                setState((){
                  userImage = File(image.path);
                });
              }

              Navigator.push(context,
                MaterialPageRoute(builder: (c){
                  return Upload(userImage : userImage); //custom widget
                }));
            },
            iconSize: 30,
          )],),
      body: [Oasis(data:data), Text("Oh!Lolli")][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState((){
            tab=i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket_outlined), label: 'link'),
        ],
      ),
    );
  }
}

class Oasis extends StatefulWidget {
  const Oasis({Key? key, this.data}) : super(key: key);
  final data;
  @override
  State<Oasis> createState() => _OasisState();
}

class _OasisState extends State<Oasis> {

  var scroll = ScrollController();
  var itemCount = 5;

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        if (itemCount <=17) {
          setState((){
            itemCount+=3;
          });
        } else {
          itemCount = 20;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty){
      return ListView.builder(itemCount: itemCount, controller: scroll, itemBuilder: (c, i){
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Text("${widget.data[i]['title_long']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    )),
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (c) => Info()
                    )
                  );
                },
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    Text("Rating:${widget.data[i]['rating']}/10"),
                    Text("Runtime:${widget.data[i]['runtime']}min"),
                    Text("Genres: ${widget.data[i]['genres']}")
                  ]),
              Image.network("${widget.data[i]['background_image']}")
            ]));
      });
    } else {
        return Container(
          child:
            Text("Now Loading...")
        );
      }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage}) : super(key: key);
  final userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){

        }, icon: Icon(Icons.send))
      ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('upload here!'),
          TextField(),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("infomation"),
    );
  }
}
