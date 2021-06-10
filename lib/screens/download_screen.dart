
import 'package:flutter/material.dart';
import 'package:upload_files/api/firebase_api.dart';
import 'package:upload_files/models/firebase_file.dart';
import 'package:upload_files/screens/image_screen.dart';


class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  
  Future<List<FirebaseFile>> futureFiles;
  
  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('files/');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text('Download Files'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default: 
              if(snapshot.hasError){
                return Center(
                  child: Text('Some Error Occured!'),
                );
              }else{
                final files=snapshot.data;
                return Column(
                  children: <Widget>[
                    HeaderWidget(length: files.length),
                    const SizedBox(height: 12,),
                    Expanded(    //required
                      child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context,index){
                          final file=files[index];
                          return buildFile(context,file);
                        },
                      ),
                    )
                  ],
                ); 
              }
          }
         
          
        }
      ),
      
    );
  }

  Widget buildFile(BuildContext context,FirebaseFile file){
    return ListTile(
      leading: ClipOval(
        child: Image.network(
          file.url,
          height:50,
          width:50,
          fit:BoxFit.cover,
        ),
      ),
      title:Text(
        file.name,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),        
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder:(context)=>ImageScreen(file: file,),
        ));
      },
    );
  }
}


class HeaderWidget extends StatelessWidget {
  final length;
  HeaderWidget({@required this.length});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.purple[300],
      leading: Icon(
        Icons.file_copy,
        color: Colors.white,
      ), 
      title: Text(
        '$length Files',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white
        ),
      ),     
    );
  }
}