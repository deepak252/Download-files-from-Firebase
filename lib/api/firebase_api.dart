import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:upload_files/models/firebase_file.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi {
  static Future<List<FirebaseFile>> listAll(String path)async {
    final ref=FirebaseStorage.instance.ref(path);
    final result=await ref.listAll();   // getting list of files

    final urls = await _getDownloadLinks(result.items);

    return urls.asMap().map((index,url){
        final ref=result.items[index];
        final name=ref.name;
        final file=FirebaseFile(
          ref:ref,
          name:name,
          url:url
        );
        return MapEntry(index, file);
    }).values.toList();
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs){
    return Future.wait(refs.map((ref)=>ref.getDownloadURL()).toList());
  }

  static Future downloadFile(Reference ref) async{
    final dir=await getApplicationDocumentsDirectory();
    final file=File('${dir.path}/${ref.name}');
    print('${dir.path}/${ref.name}');
    // await ref.writeToFile(file);
  }
} 