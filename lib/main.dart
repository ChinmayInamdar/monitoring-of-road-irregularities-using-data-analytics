import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Road Irregularities Images',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _picker = ImagePicker();
  final _images = <File>[];

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _images.add(imageFile);
      });

      final url = Uri.parse('https://your-server.com/upload-photo');
      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);
      // Do something with the response data...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Road Irregularities Images'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          for (final imageFile in _images)
            Image.file(imageFile),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _getImage(ImageSource.camera),
            tooltip: 'Take a photo',
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _getImage(ImageSource.gallery),
            tooltip: 'Select a photo',
            child: Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}
