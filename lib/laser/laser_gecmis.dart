import 'package:beta_flex/laser/laser_drawer_menu.dart';
import 'package:flutter/material.dart';


class laser_gecmis extends StatefulWidget {
  const laser_gecmis({super.key});

  @override
  State<laser_gecmis> createState() => _laser_gecmisState();
}

class _laser_gecmisState extends State<laser_gecmis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sıcaklık Geçmişi',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
      ),
      drawer: laser_drawer_menu(),
      body: Center(
        child: Text(''),
      ),
    );
  }
}
