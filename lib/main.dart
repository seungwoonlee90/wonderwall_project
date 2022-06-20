import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            color : Colors.white,
            elevation: 1,
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
            actionsIconTheme: IconThemeData(color: Colors.black)
        )
      ),
      home : MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      body: Text("You're my wonderwall")
    );
  }
}
