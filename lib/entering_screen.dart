import 'package:beta_flex/flex_14800/gunluk_testler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class entering_screen extends StatefulWidget {
  const entering_screen({super.key});

  @override
  State<entering_screen> createState() => _entering_screenState();
}

class _entering_screenState extends State<entering_screen> {

  late double _opacity = 0.1 ;

  @override
  void initState() {
    super.initState();
    _sendFirstRun();
      _animation();
  }

  Future _sendFirstRun() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      await prefs.setBool('OK', false);
    });
  }

  _animation() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1;
      });
      Future.delayed(Duration(seconds: 4), () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => gunluk_testler()));
      });
  });
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             SizedBox(width: 10,),
              AnimatedOpacity(
                duration: const Duration(seconds: 2),
                curve: Curves.linear,
                opacity: _opacity,
                child: Image.asset('images/img_kaslogo.png',),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    curve: Curves.linear,
                    opacity: _opacity,
                    child: Image.asset('images/img_kasprojeotomasyon.png',height: MediaQuery.of(context).size.height * 0.05,),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
