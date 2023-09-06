import 'package:auto_size_text/auto_size_text.dart';
import 'package:beta_flex/flex_14800/anasayfa.dart';
import 'package:beta_flex/flex_14800/electrical_drawing.dart';
import 'package:beta_flex/flex_14800/gunluk_testler.dart';
import 'package:beta_flex/flex_14800/null_controller.dart';
import 'package:beta_flex/flex_14800/proje_hakkinda.dart';
import 'package:beta_flex/flex_14800/tests_forDate.dart';
import 'package:beta_flex/laser/laser_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class drawer_menu extends StatefulWidget {
  const drawer_menu({super.key});

  @override
  State<drawer_menu> createState() => _drawer_menuState();
}

class _drawer_menuState extends State<drawer_menu> {

  Future _setFirstRun() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.setBool('OK', false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.65,
      child: Drawer(

        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(image: AssetImage('images/img_148002.jpg'),filterQuality: FilterQuality.low,),
                  Text('14800 - Flex Test',style: TextStyle(fontSize: 20,color: Colors.blue.shade900, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 30,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [ TextButton.icon(
                     onPressed: () {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const gunluk_testler()));
                     }, icon: Icon(Icons.date_range_outlined,size: 30,color: Colors.blue.shade900,),
                     label: const AutoSizeText('Bugünün Testleri',style: TextStyle(fontSize: 15, color: Colors.black),),
                   ),],
                 ),
                  const SizedBox(height: 10,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [ TextButton.icon(
                       onPressed: () {
                         Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const tests_forDate()));
                       } ,
                       icon: Icon(Icons.history,size: 30,color: Colors.blue.shade900,),
                       label: const AutoSizeText('Geçmiş Testler',style: TextStyle(fontSize: 15,color: Colors.black),)
                   ),],
                 ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const anasayfa()));
                        }, icon: Icon(Icons.newspaper,size: 30,color: Colors.blue.shade900,),
                        label:  const AutoSizeText('Reçete Ajandası',style: TextStyle(fontSize: 15, color: Colors.black),),
                      ),],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const electrical_drawing()));
                        }, icon: Icon(Icons.electric_bolt,size: 30,color: Colors.blue.shade900,),
                        label:  const AutoSizeText('Elektrik Plan Çizimi',style: TextStyle(fontSize: 15, color: Colors.black),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const proje_hakkkinda()));
                        }, icon: Icon(Icons.info_outline,size: 30,color: Colors.blue.shade900,),
                        label:  const AutoSizeText('Proje Hakkında',style: TextStyle(fontSize: 15, color: Colors.black),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [ TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const null_controller()));
                        } ,
                        icon: Icon(Icons.signal_cellular_null,size: 30,color: Colors.blue.shade900,),
                        label: const AutoSizeText('Null Controller',style: TextStyle(fontSize: 15,color: Colors.black),)
                    ),],
                  ),
                ],
              ),

              Column(
                children: [
                  TextButton.icon(
                      onPressed: () {
                        _setFirstRun();
                        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => laser_main_page()));
                      }, icon: Icon(Icons.thermostat,color: Colors.red,size: 30,),
                      label: const AutoSizeText('Lazer Sıcaklık Takip',style: TextStyle(fontSize: 18,color: Colors.black)),),
                  const SizedBox(height: 10,),
                  const Image(image: AssetImage('images/img_kasprojeotomasyon.png'),filterQuality: FilterQuality.medium,),
                  const SizedBox(height: 5,)
                ],
              )
            ],
        ),
      ),
    );
  }
}
