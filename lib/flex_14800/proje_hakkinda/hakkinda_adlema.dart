import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class hakkinda_adlema extends StatefulWidget {
  const hakkinda_adlema({super.key});

  @override
  State<hakkinda_adlema> createState() => _hakkinda_adlemaState();
}

class _hakkinda_adlemaState extends State<hakkinda_adlema> {

  String _adlema = '';
  bool _circularprogress = false;


  @override
  void initState() {
    super.initState();



    Future.delayed(Duration(milliseconds: 500), (){
      _getadlemaaData();
    });
  }




  _getadlemaaData() async {


    final DatabaseReference dbrefc = FirebaseDatabase.instance.ref().child('14800').child('infos');

    final snapshot = await dbrefc.child('adlema').get();
    if (snapshot.exists) {
      setState(() {
        _adlema = snapshot.value.toString();
        if(_circularprogress == true) {
          Navigator.of(context).pop();
          _circularprogress = false;
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Adlema Test Cihazları',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
      ),

      body: _adlema == '' ? Center(child: CircularProgressIndicator(),) :
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                  child: Text(_adlema,style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.black),),
                ),
                Image.asset('images/14800_diagram.png'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_downward,size: 25,color: Colors.black,),
                    Icon(Icons.arrow_upward,size: 25,color: Colors.black,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Operator',style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.black),),
                    Icon(Icons.person,size: 40,color: Colors.blue,),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
