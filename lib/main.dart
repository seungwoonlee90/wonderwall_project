import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  getData() async {
    var res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    var result = jsonDecode(res.body);
    if (res.statusCode == 200) {
      setState((){
        data = result;
      });
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            onPressed: (){},
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

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        //더보기 기능
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty){
      return ListView.builder(itemCount: 10, controller: scroll, itemBuilder: (c, i){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text("title_${i} is : ${widget.data[i]['title']}"),
            ]);
      });
    } else {
        return Container(
          child:
            Text("Now Loading...")
        );
      }
  }
}