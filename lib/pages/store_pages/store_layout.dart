import 'package:flutter/material.dart';

class StoreLayout extends StatefulWidget {
  const StoreLayout({Key? key}) : super(key: key);

  @override
  _StoreLayoutState createState() => _StoreLayoutState();
}

class _StoreLayoutState extends State<StoreLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFF5F5F5),
      body: const Center(

        child: Text(
          "Hello Geeks!!" ),
      ),
    );
  }
}