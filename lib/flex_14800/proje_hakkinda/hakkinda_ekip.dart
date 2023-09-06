import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class hakkinda_ekip extends StatefulWidget {
  const hakkinda_ekip({super.key});

  @override
  State<hakkinda_ekip> createState() => _hakkinda_ekipState();
}

class _hakkinda_ekipState extends State<hakkinda_ekip> {
  String _ekip = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      _getekipData();
    });
  }

  _getekipData() async {
    final DatabaseReference dbrefe =
        FirebaseDatabase.instance.ref().child('14800').child('infos');

    final snapshot = await dbrefe.child('ekip').get();
    if (snapshot.exists) {
      setState(() {
        _ekip = snapshot.value.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Proje Otomasyon',
          style: TextStyle(fontSize: 15, color: Colors.white),
          maxLines: 1,
        ),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
      ),
      body: _ekip == ''  ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _ekip,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bölüm Amiri',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          'Ömer Faruk SARIOĞLU',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          'Mekatronik Mühendisi',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Semih ÖZCAN',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          'Mekatronik Mühendisi',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Enes ÜZÜMCÜ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          'Mekatronik Mühendisi',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Hüseyin GÜREL',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          'Elektrik Elektronik Mühendisi',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
