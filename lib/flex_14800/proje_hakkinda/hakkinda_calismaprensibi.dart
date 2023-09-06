import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class hakkinda_calismaprensibi extends StatefulWidget {
  const hakkinda_calismaprensibi({super.key});

  @override
  State<hakkinda_calismaprensibi> createState() => _hakkinda_calismaprensibiState();
}

class _hakkinda_calismaprensibiState extends State<hakkinda_calismaprensibi> {

  String _calisma = '';


@override
  void initState() {
    super.initState();


    Future.delayed(Duration(milliseconds: 500), (){
      _getcalismaData();
    });
  }




  _getcalismaData() async {
    final DatabaseReference dbrefc = FirebaseDatabase.instance.ref().child(
        '14800').child('infos');

    final snapshot = await dbrefc.child('calisma').get();
    if (snapshot.exists) {
      setState(() {
        _calisma = snapshot.value.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Çalışma Prensibi',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
      ),
      body: _calisma == ''  ? Center(child: CircularProgressIndicator(),) :
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
              child: Text(_calisma,style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.black),),
            ),
           Image.asset('images/14800_HMI.jpeg')
          ],
        ),
      ),
    );
  }
}
