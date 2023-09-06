import 'package:beta_flex/laser/laser_drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class laser_main_page extends StatefulWidget {
  const laser_main_page({super.key});

  @override
  State<laser_main_page> createState() => _laser_main_pageState();
}

class _laser_main_pageState extends State<laser_main_page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late bool _firstRun = false ;



  @override
  void initState() {
    super.initState();


    _checkFirstRun();


  }

  @override
  void dispose() {
    super.dispose();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Anlık Sıcaklık Takip',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
      centerTitle: true,
      backgroundColor: Color(0xff283773),
      ),



      drawer: laser_drawer_menu(),
    );
  }
}
