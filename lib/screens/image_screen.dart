import 'package:flutter/material.dart';
import 'package:upload_files/api/firebase_api.dart';
import 'package:upload_files/models/firebase_file.dart';


class ImageScreen extends StatelessWidget {
  final FirebaseFile file;
  const ImageScreen({@required this.file});

  @override
  Widget build(BuildContext context) {
    final isImage=['.jpg','.jpeg','.png'].any(file.name.contains);
    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              await FirebaseApi.downloadFile(file.ref);

              final snackBar = SnackBar(
                content: Text('Downloaded ${file.name}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: isImage
          ? Image.network(
              file.url,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          : Center(
              child: Text(
                'Cannot be displayed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
      
    );
  }
}