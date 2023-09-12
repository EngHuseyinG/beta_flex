import 'dart:ffi';

import 'package:beta_flex/laser/laser_drawer_menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class laser_main_page extends StatefulWidget {
  const laser_main_page({super.key});

  @override
  State<laser_main_page> createState() => _laser_main_pageState();
}

class _laser_main_pageState extends State<laser_main_page> {
  TextEditingController _setsensor1name = TextEditingController();
  TextEditingController _setsensor2name = TextEditingController();
  TextEditingController _setsensor3name = TextEditingController();
  TextEditingController _setsensor4name = TextEditingController();
  TextEditingController _setsensor5name = TextEditingController();
  TextEditingController _alarmController = TextEditingController();


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final DatabaseReference dbreft = FirebaseDatabase.instance.ref().child('laser');

  late bool _firstRun = false ;
  bool _circularprogress = false;
  String _t1name = 'S1';
  String _t2name = 'S2';
  String _t3name = 'S3';
  String _t4name = 'S4';
  String _t5name = 'S5';
  int _alarmsicaklik = 0;
  late double _setalarmsicaklik = 0;
  String _cikisname = 'Çıkış';

  bool _relay1 = false;
  bool _relay2 = false;

  Map<dynamic, dynamic> data = <dynamic, dynamic> {};



  @override
  void initState() {
    super.initState();


    _checkFirstRun();
    _listenSensorNames();
    _listenliveDatas();


  }

  @override
  void dispose() {
    super.dispose();
    _listenliveDatas();
  }



  Future<void> _listenliveDatas() async{
   await dbreft.child('anlik').onValue.listen((DatabaseEvent event) {
      if(event.snapshot.exists) {
        setState(() {
          data = event.snapshot.value as dynamic;
        });
      }
    });

   final snapshot = await dbreft.child('command').child('alarm_temp').get();
   if(snapshot.exists) {
        setState(() {
          _alarmsicaklik = snapshot.value as int;
          _setalarmsicaklik = _alarmsicaklik.toDouble()/10.00;
          _alarmController.text = _setalarmsicaklik.toStringAsFixed(1);
          if(_circularprogress == true) {
            Navigator.of(context).pop();
            _circularprogress = false;
          }
        });
   }
}

Future<void> _listenSensorNames() async {
    final snapshot = await dbreft.child('names').get();
    if(snapshot.exists) {
        setState(() {
           var map = snapshot.value as dynamic;
          _t1name = map['t1name'].toString();
          _t2name = map['t2name'].toString();
          _t3name = map['t3name'].toString();
          _t4name = map['t4name'].toString();
          _t5name = map['t5name'].toString();
          _cikisname = map['cikisname'].toString();

        });
    }
}

  _buildShowDialog(BuildContext context) {
    setState(() {
      _circularprogress = true;
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Lottie.asset('animations/kas_animation.json',repeat: true),
            ),
          );
        });
  }


  Future _checkFirstRun() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    _firstRun = prefs.getBool('OK')!;
    if(_firstRun == false) {
      _openandcloseDrawer();
    }

  }

  Future _openandcloseDrawer() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 1),() {
      _scaffoldKey.currentState!.openDrawer();

       prefs.setBool('OK', true);
    });

    Future.delayed(Duration(seconds: 2),() {
      _scaffoldKey.currentState!.closeDrawer();
    });
  }

  Future <void> _savenewSettings() async {
    if(_setsensor1name.text.isNotEmpty) {
      dbreft.child('names').child('t1name').set(_setsensor1name.text.toString());
    }
    if(_setsensor2name.text.isNotEmpty) {
      dbreft.child('names').child('t2name').set(_setsensor2name.text.toString());
    }
    if(_setsensor3name.text.isNotEmpty) {
      dbreft.child('names').child('t3name').set(_setsensor3name.text.toString());
    }
    if(_setsensor4name.text.isNotEmpty)  {
      dbreft.child('names').child('t4name').set(_setsensor4name.text.toString());
    }
      if(_setsensor5name.text.isNotEmpty) {
        dbreft.child('names').child('t5name').set(_setsensor5name.text.toString());
      }


      dbreft.child('command').child('alarm_temp').set((_setalarmsicaklik * 10.0).toInt());
      dbreft.child('command').child('c').set(22);
  }


  void _bottomdialog()  {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setState)
    {
      return SingleChildScrollView(

        child: Padding(
          padding:MediaQuery.of(context).viewInsets,

          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.9,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings,color: Colors.blue,),
                    SizedBox(width: 10,),
                    Text('Ayarlar',style: TextStyle(fontSize: 20,color: Colors.blue,),),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.thermostat_rounded,color: Colors.red,),
                    Text('Sensör-1 İsmi',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child:   TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12,color: Colors.black),
                    autofocus: false,
                    controller: _setsensor1name,
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      hintText: _t1name == '' ? 'Yeni Sensör ismi gir' : _t1name,
                      hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      suffixIcon: Icon(Icons.numbers),
                      suffixIconColor: Colors.blue.shade700,
                      border:  OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.thermostat_rounded,color: Colors.red,),
                    Text('Sensör-2 İsmi',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child:   TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12,color: Colors.black),
                    autofocus: false,
                    controller: _setsensor2name,
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      hintText: _t2name == '' ? 'Yeni Sensör ismi gir' : _t2name,
                      hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      suffixIcon: Icon(Icons.numbers),
                      suffixIconColor: Colors.blue.shade700,
                      border:  OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.thermostat_rounded,color: Colors.red,),
                    Text('Sensör-3 İsmi',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child:   TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12,color: Colors.black),
                    autofocus: false,
                    controller: _setsensor3name,
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      hintText: _t3name == '' ? 'Yeni Sensör ismi gir' : _t3name,
                      hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      suffixIcon: Icon(Icons.numbers),
                      suffixIconColor: Colors.blue.shade700,
                      border:  OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.thermostat_rounded,color: Colors.red,),
                    Text('Sensör-4 İsmi',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child:   TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12,color: Colors.black),
                    autofocus: false,
                    controller: _setsensor4name,
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      hintText: _t4name == '' ? 'Yeni Sensör ismi gir' : _t4name,
                      hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      suffixIcon: Icon(Icons.numbers),
                      suffixIconColor: Colors.blue.shade700,
                      border:  OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.thermostat_rounded,color: Colors.red,),
                    Text('Sensör-5 İsmi',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child:   TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12,color: Colors.black),
                    autofocus: false,
                    controller: _setsensor5name,
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      hintText: _t5name == '' ? 'Yeni Sensör ismi gir' : _t5name,
                      hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      suffixIcon: Icon(Icons.numbers),
                      suffixIconColor: Colors.blue.shade700,
                      border:  OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber,color: Colors.red,),
                    Text('Alarm verilecek sıcaklık',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _setalarmsicaklik = _setalarmsicaklik - 0.10;
                            _alarmController.text = _setalarmsicaklik.toStringAsFixed(1);
                          });
                        }, icon: Icon(Icons.keyboard_arrow_down,size: 12,),),
                      SizedBox(height: 65, width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _alarmController,
                          style: TextStyle(fontSize: 18,color: Colors.black),maxLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: _setalarmsicaklik.toStringAsFixed(1),
                          ),
                          onChanged: (String value) {
                            _alarmController.text = value;
                            _setalarmsicaklik = double.parse(_alarmController.text) ;
                          },
                        ),
                      ),
                      Text('°C'),
                      IconButton(onPressed: () {
                        setState(() {
                          _setalarmsicaklik = _setalarmsicaklik + 0.10;
                          _alarmController.text = _setalarmsicaklik.toStringAsFixed(1);
                        });
                      }, icon: Icon(Icons.keyboard_arrow_up,size: 12,),),
                    ],
                  ),
                ),
                Text('Örn: 45.5 °C',style: TextStyle(fontSize: 12,color: Colors.grey),maxLines: 1,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    _buildShowDialog(context);
                    Future.delayed(Duration(seconds: 2),() {
                      _savenewSettings();
                      _listenSensorNames();
                      _listenliveDatas();

                    });
                  },
                  child: Text('KAYDET ',style: TextStyle(fontSize: 12, color: Colors.blue.shade700),maxLines: 1,),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                ),
              ],
            ),
          ),),
      );
    }
        ),
    );
  }

  Future<void> _checkiiotDevice() async {
    dbreft.child('command').child('c').set(23);

     Future.delayed(Duration(seconds: 3), () async{
      final hop =  await dbreft.child('command').child('c').get();
      if(hop.exists) {
       if(hop.value == 10) {
         Fluttertoast.showToast(
             msg: "Cihaz Devrede",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.CENTER,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.red,
             textColor: Colors.white,
             fontSize: 16.0
         );
       }
       else {
         Fluttertoast.showToast(
             msg: "Cihazda Sorun görünüyor",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.CENTER,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.red,
             textColor: Colors.white,
             fontSize: 16.0
         );
       }
      }
      if(_circularprogress == true) {
        Navigator.of(context).pop();
        _circularprogress = false;
      }
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Anlık Sıcaklık Takip',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
      centerTitle: true,
      backgroundColor: Color(0xff283773),
        actions: [
          IconButton(
            onPressed: () {
              _bottomdialog();
            },
            icon: Icon(Icons.settings,size: 25,color: Colors.white,),
          ),
        ],
      ),
      drawer: laser_drawer_menu(),
      body:
      Center(
        child:
            data.isEmpty ? CircularProgressIndicator() :
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                SfCartesianChart(
                  enableAxisAnimation: false,
                    isTransposed: false,
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      // Initialize line series
                      LineSeries<ChartData, String>(
                        isVisible: true,
                        isVisibleInLegend: true,
                        dataSource: [
                          // Bind data source
                          ChartData(_t1name, data['t1'].toDouble()/10.00),
                          ChartData(_t2name, data['t2'].toDouble()/10.00),
                          ChartData(_t3name, data['t3'].toDouble()/10.00),
                          ChartData(_t4name, data['t4'].toDouble()/10.00),
                          ChartData(_t5name, data['t5'].toDouble()/10.00)
                        ],
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        color: Colors.green,
                        dataLabelSettings:DataLabelSettings(isVisible : true),
                      )
                    ]
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_active_rounded,size: 20,color: Colors.red,),
                    SizedBox(width: 10,),
                    Text(data['r2'] == true ? 'Alarm Devrede' : data['r2'] == false ? 'Alarm Devrede Değil' : 'Alarm Durumu bilinmiyor',style: TextStyle(fontSize: 12, color: data['r2'] == true ? Colors.green : data['r2'] == false ? Colors.red : Colors.black),maxLines: 1,),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _buildShowDialog(context);
                              Future.delayed(Duration(seconds: 2),()
                              {
                                _checkiiotDevice();
                              });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.all(5),
                                child: Icon(Icons.question_mark),
                              ),
                              Text('Cihazı Kontrol Et',style: TextStyle(fontSize: 10),)
                            ],
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        ),
                      ],
                    ),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.warning,size: 20,color: Colors.red,),
                          SizedBox(width: 10,),
                          Text('Alarm Sıcaklığı: ${_alarmsicaklik.toDouble()/10.00}°C',style: TextStyle(fontSize: 12, color: Colors.red),maxLines: 1,),
                        ],),
                  ],
                ),

                SizedBox(height: 15,),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     Container(
                       height: MediaQuery.of(context).size.height * 0.05,
                       width: MediaQuery.of(context).size.width * 0.35,
                       child:  ElevatedButton(
                         onPressed: () {
                           dbreft.child('command').child('c').set(20);
                         },
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Padding(padding: EdgeInsets.all(5),
                               child: Icon(Icons.flash_on),
                             ),
                             Text('${_cikisname} ON',style: TextStyle(fontSize: 10),)
                           ],
                         ),
                         style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                       ),
                     ),
                      FittedBox(
                        child: Text(data['r1'] == false ? 'Kapalı' : data['r1'] == true ? 'Açık' : '?',style: TextStyle(fontWeight: FontWeight.bold,color: data['r1'] == false ? Colors.red : data['r1'] == true ? Colors.green : Colors.blue,fontSize: 12),),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.35,
                        child:  ElevatedButton(
                          onPressed: () {
                            dbreft.child('command').child('c').set(21);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.all(5),
                                child: Icon(Icons.flash_off),
                              ),
                              Text('${_cikisname} OFF',style: TextStyle(fontSize: 10),)
                            ],
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                    ],
                  ),



              SizedBox(height: 5,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color:Colors.black
                      ),
                      child: Center(
                        child: Text('${data['t1'].toDouble()/10.00}°C',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color:Colors.red
                      ),
                      child: Center(
                        child: Text('${data['t2'].toDouble()/10.00}°C',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color:Colors.blue
                      ),
                      child: Center(
                        child: Text('${data['t3'].toDouble()/10.00}°C',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color:Colors.green
                      ),
                      child: Center(
                        child: Text('${data['t4'].toDouble()/10.00}°C',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color:Colors.brown
                      ),
                      child: Center(
                        child: Text('${data['t5'].toDouble()/10.00}°C',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}