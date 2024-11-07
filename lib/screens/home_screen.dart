import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: FutureBuilder(
        // setup the URL for your API here
        future: future,
        builder: (context, snapshot) {
          // Consider 3 cases here
          // when the process is ongoing
          // return CircularProgressIndicator();
          
          // when the process is completed:

          // successful
          // Use the library here
          return ExpandedTileList.builder

          // error
          return Text();
        },
      ),
    );
  }
}
