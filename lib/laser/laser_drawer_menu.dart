import 'package:auto_size_text/auto_size_text.dart';
import 'package:beta_flex/flex_14800/gunluk_testler.dart';
import 'package:beta_flex/laser/laser_gecmis.dart';
import 'package:beta_flex/laser/laser_main_page.dart';
import 'package:beta_flex/laser/laser_projehakkinda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class laser_drawer_menu extends StatefulWidget {
  const laser_drawer_menu({super.key});

  @override
  State<laser_drawer_menu> createState() => _laser_drawer_menuState();
}

class _laser_drawer_menuState extends State<laser_drawer_menu> {

  Future _setFirstRun() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.setBool('OK', false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.65,
      child: Drawer(

        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Column(
                  children: [
                    const Image(image: AssetImage('images/flex_hose_machine.jpg'),filterQuality: FilterQuality.low,),
                    Text('Sıcaklık Takip',style: TextStyle(fontSize: 20,color: Colors.blue.shade900, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const laser_main_page()));
                          }, icon: Icon(Icons.live_tv,size: 30,color: Colors.blue.shade900,),
                          label:  const AutoSizeText('Anlık Takip',style: TextStyle(fontSize: 15, color: Colors.black),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const laser_gecmis()));
                          }, icon: Icon(Icons.history,size: 30,color: Colors.blue.shade900,),
                          label:  const AutoSizeText('Geçmiş',style: TextStyle(fontSize: 15, color: Colors.black),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const laser_projehakkinda()));
                          }, icon: Icon(Icons.info_outline,size: 30,color: Colors.blue.shade900,),
                          label:  const AutoSizeText('Proje Hakkında',style: TextStyle(fontSize: 15, color: Colors.black),),
                        ),
                      ],
                    ),
                  ],
                ),



            Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    _setFirstRun();
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => gunluk_testler()));
                  }, icon: Icon(Icons.blinds_closed,color: Colors.red,size: 30,),
                  label: const AutoSizeText('14800-Flex Test',style: TextStyle(fontSize: 18,color: Colors.black)),),
                const SizedBox(height: 10,),
                const Image(image: AssetImage('images/img_kasprojeotomasyon.png'),filterQuality: FilterQuality.medium,),
                const SizedBox(height: 5,)
              ],
            ),
          ],
        ),
      )
    );
  }
}
