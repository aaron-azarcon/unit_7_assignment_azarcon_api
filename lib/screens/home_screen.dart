import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> futureCombatStyles;
  List<ExpandedTileController> controllers = [];

  @override
  void initState() {
    super.initState();
    futureCombatStyles = fetchCombatStyles().then((combatStyles) {
      controllers = List.generate(combatStyles.length, (_) => ExpandedTileController());
      return combatStyles;
    });
  }

  Future<List<dynamic>> fetchCombatStyles() async {
    final response = await http.get(
      Uri.parse("https://www.demonslayer-api.com/api/v1/combat-styles"),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse["content"];
    } else {
      throw Exception('Failed to load combat styles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        title: const Center(
            child: Text(
                "Demon Slayer",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
              ),
            )
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        // setup the URL for your API here
        future: futureCombatStyles,
        builder: (context, snapshot) {
          // Consider 3 cases here
          // when the process is ongoing
          // return CircularProgressIndicator();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // when the process is completed:
          else if(snapshot.hasData ){
            // successful
            // Use the library here
            return ListView.builder(
              itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final combatStyle = snapshot.data![index];
                  final controller = controllers[index];
                  return ExpandedTile(
                      controller: controller,
                      title: Text(
                          combatStyle["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold
                          )
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          combatStyle["img"] != ""
                              ? Image.network(combatStyle["img"])
                              : const Icon(Icons.image_not_supported),

                          const SizedBox(height: 20),

                          Text(combatStyle["description"]),
                        ]
                      )
                  );
                }
            );
          }
          // error
          else{
            return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}
