import 'package:beta_flex/flex_14800/drawer_menu.dart';
import 'package:beta_flex/flex_14800/proje_hakkinda/hakkinda_adlema.dart';
import 'package:beta_flex/flex_14800/proje_hakkinda/hakkinda_calismaprensibi.dart';
import 'package:beta_flex/flex_14800/proje_hakkinda/hakkinda_ekip.dart';
import 'package:beta_flex/flex_14800/proje_hakkinda/hakkinda_genel.dart';
import 'package:beta_flex/flex_14800/proje_hakkinda/hakkinda_iiot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class proje_hakkkinda extends StatefulWidget {
  const proje_hakkkinda({super.key});

  @override
  State<proje_hakkkinda> createState() => _proje_hakkkindaState();
}

class _proje_hakkkindaState extends State<proje_hakkkinda> {
  late String _selectedstart = DateTime.now().toString();



  Future<void> _showDatePicker() async {
    final DateTimeRange? dateTimeRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2023),
        lastDate: DateTime(3000),
        saveText: 'Kaydet'
    );
    if(dateTimeRange != null) {

      setState(() {
        _selectedstart = dateTimeRange.start.day.toString();
        print(_selectedstart);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proje Hakkında',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
      ),



      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => hakkinda_genel()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Genel',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),maxLines: 1,
                  ),
                  Icon(Icons.arrow_forward_ios,size: 20,color: Colors.blue.shade700,),
                ],
              ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => hakkinda_adlema()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adlema Test Cihazları',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black),maxLines: 1,
                ),
                Icon(Icons.arrow_forward_ios,size: 20,color: Colors.blue.shade700,),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => hakkinda_calismaprensibi()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Çalışma Prensibi',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),maxLines: 1,
                ),
                Icon(Icons.arrow_forward_ios,size: 20,color: Colors.blue.shade700,),
              ],
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => hakkinda_iiot()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'IIoT(Uzaktan Takip)',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),maxLines: 1,
                ),
                Icon(Icons.arrow_forward_ios,size: 20,color: Colors.blue.shade700,),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => hakkinda_ekip()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Proje Otomasyon Departmanı',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),maxLines: 1,
                ),
                Icon(Icons.arrow_forward_ios,size: 20,color: Colors.blue.shade700,),
              ],
            ),
          ),

        ],
      ),
      drawer: drawer_menu(),
    );
  }
}
