import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class hakkinda_iiot extends StatefulWidget {
  const hakkinda_iiot({super.key});

  @override
  State<hakkinda_iiot> createState() => _hakkinda_iiotState();
}





class _hakkinda_iiotState extends State<hakkinda_iiot> {
String _iiot = '';

@override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), (){
      _getiiotData();
    });

}

      _getiiotData() async {
          final DatabaseReference dbrefg = FirebaseDatabase.instance.ref('14800').child('infos');
          
           final snapshot = await dbrefg.child('iiot').get();
           if(snapshot.exists) {
             setState(() {
               _iiot = snapshot.value.toString();
             });
           }
        
      }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IIoT Uzaktan Takip',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
      ),
      body: _iiot == ''? Center(child: CircularProgressIndicator(),) :
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
              child: Text(_iiot,style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.black),),
            ),
            Image.asset('images/iiot_module.jpeg')

          ],
        ),
      ),
    );
  }
}
 