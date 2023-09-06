import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class hakkinda_genel extends StatefulWidget {
  const hakkinda_genel({super.key});

  @override
  State<hakkinda_genel> createState() => _hakkinda_genelState();
}

class _hakkinda_genelState extends State<hakkinda_genel> {

  String _genel = '';


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), (){
      _getGenelData();
    });
  }


  _getGenelData() async {
    final DatabaseReference dbrefg = FirebaseDatabase.instance.ref('14800').child('infos');

    final snapshot = await dbrefg.child('genel').get();
    if(snapshot.exists) {
      setState(() {
        _genel = snapshot.value.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Genel',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
      ),

      body: _genel == '' ? Center(child: CircularProgressIndicator(),) :
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
              child: Text(_genel,style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.black),),
            ),
            Image.asset('images/img_148002.jpg')

          ],
        ),
      ),
    );
  }
}
