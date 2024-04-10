import 'dart:convert';
import 'package:final_project/models/faculty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import rootBundle
import '../../helpers/color_utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Faculty>? _faculties;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    try {
      String jsonString = await rootBundle.loadString('faculties.json');

      List<dynamic> data = json.decode(jsonString);
      _faculties = data.map((item) => Faculty.fromJson(item)).toList();
      setState(() {});
    } catch (e) {
      print('Error loading countries: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color darkenedColor = darken(primaryColor, 30);

    return MaterialApp(
      title: 'Silpakorn Faculty',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: darkenedColor,
          title: Text(
            'Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _faculties != null
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _faculties!.length,
                        itemBuilder: (context, index) {
                          var faculty = _faculties![index];
                          return ListTile(
                            title: Text(faculty.name ?? ''),
                            subtitle: Text(faculty.campus ?? ''),
                            onTap: () {
                              _showPopup(faculty);
                            },
                          );
                        },
                      ),
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopup(Faculty faculty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${faculty.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${faculty.campus}"),
              SizedBox(height: 8),
              Text("แนวทางประกอบอาชีพ:",
                  style: TextStyle(decoration: TextDecoration.underline)),
              SizedBox(height: 8),
              Text("${faculty.guildline ?? ''}".replaceAll(", ", "\n"),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
