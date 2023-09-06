import 'package:auto_size_text/auto_size_text.dart';
import 'package:beta_flex/flex_14800/drawer_menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class anasayfa extends StatefulWidget {
  const anasayfa({super.key});

  @override
  State<anasayfa> createState() => _anasayfaState();
}

class _anasayfaState extends State<anasayfa> {
  final ScrollController _controller = ScrollController();

  final DatabaseReference dbrefx =
      FirebaseDatabase.instance.ref().child('14800');
  Map<dynamic, dynamic> _recetemap = <dynamic, dynamic>{};
  List<dynamic> _receteList = [];

  final TextEditingController _receteKodu = TextEditingController();
  final TextEditingController _urunUzunluk = TextEditingController();
  final TextEditingController _aciklama = TextEditingController();
  final TextEditingController _searchfilter = TextEditingController();
  final TextEditingController _uruntipi = TextEditingController();

  late String _key = '';
  late String _selectedkey = '';

  late bool _circularprogress = false;

  late bool _cubuklu = false;

  late int _selectedindex = 0 ;


  @override
  void initState() {
    super.initState();
    _listenAjandas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _listenAjandas() async {
    final snapshot = await dbrefx.child('ajandalar').get();
    setState(() {
      _recetemap.clear();
      if (_circularprogress == true) {
        Navigator.of(context).pop();
        _circularprogress = false;
      }
      _receteList.clear();
    });
    if (snapshot.exists) {
      setState(() {
        _recetemap = snapshot.value as dynamic;
        _receteList.addAll(_recetemap.values);
        _receteList = _receteList
          ..sort((a, b) => b['recetekodu'].compareTo(a['recetekodu']));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Reçete Ajandası',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(

              height: 10,
            ),
            Container(
              height: height * 0.25,
              child: Expanded(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: _receteList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (_receteList.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Card(

                            margin: EdgeInsets.all(5),
                            child: Container(
                              width: width * 0.35,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.newspaper,
                                          size: 45,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'Reçete Kodu:${_receteList[index]['recetekodu']}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'Uzunluk: ${_receteList[index]['urunuzunluk']}\tmm',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(_receteList[index]['cubuklu'] == true ? 'Çubuklu' : 'Çubuksuz',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                                setState(() {
                                                  _selectedindex = index;
                                                });
                                          },
                                          icon: Icon(Icons.info_outline,size: 25,color: Colors.blue.shade700,)
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _selectedkey = _receteList[index]
                                                    ['id']
                                                .toString();
                                            _showQuestionDialog(context);
                                          },
                                          icon: Icon(
                                            Icons.delete_forever,
                                            size: 25,
                                            color: Colors.red,
                                          ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                  ),
              ),
            ),
            const SizedBox(height: 30,),
        Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            controller: _searchfilter,
            decoration: InputDecoration(
              hintText: 'Uzunluk ile Ara',
              suffixIcon: FittedBox(
                child: Row( mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _searchfilter.text.isNotEmpty ? GestureDetector(
                      onTap: () {
                        _searchfilterCleaned();
                      },
                      child: Icon(Icons.cancel,size: 15,color: Colors.red,),
                    ) : Text(''),
                    SizedBox(width: 10,),
                    Icon(Icons.search),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
              suffixIconColor: Colors.blue.shade700,
              border: const OutlineInputBorder(),
            ),
            onChanged: (String value) {
              setState(() {
                _searchFilter();
              });
            },
          ),
        ),
            SizedBox(height: 10,),
            _receteList.isNotEmpty ?

                 Container(
                      height: height * 0.4,
                     child: Card(

                       child: SingleChildScrollView(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.newspaper,size: 45,color: Colors.red,),
                                 SizedBox(width: 10,),
                                 Text('Reçete Kodu:${_receteList[_selectedindex]['recetekodu']}',style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                               ],
                             ),
                             SizedBox(height: 10,),
                             AutoSizeText('Uzunluk:${_receteList[_selectedindex]['urunuzunluk']}\tmm',style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                             SizedBox(height: 10,),
                             AutoSizeText(_receteList[_selectedindex]['_cubuklu'] == true ? 'Çubuklu Reçete' : 'Çubuksuz Reçete',style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                             SizedBox(height: 10,),
                             AutoSizeText('Ürün Tipi: ${_receteList[_selectedindex]['uruntipi']}',style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                             SizedBox(height: 10,),
                             AutoSizeText('Açıklama:\n${_receteList[_selectedindex]['aciklama']}',style: TextStyle(fontSize: 15, color: Colors.blue.shade700),overflow: TextOverflow.ellipsis,maxLines: 6,),
                           ],
                         ),
                       ),
                     ),
                   )

                :
                Text('Veri Yok'),
            SizedBox(height: 10,),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _searchfilter.clear();
              _buildShowDialog(context);
              _receteList.clear();
              _listenAjandas();
            },
            backgroundColor: Colors.blueAccent.shade700,
            child: const Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              _showBottomsheet();
            },
            backgroundColor: Colors.blueAccent.shade700,
            child: const Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      drawer: const drawer_menu(),
    );
  }

  _showQuestionDialog(BuildContext context) {
    // set up the button
    Widget yesButton = TextButton(
      child: Text("EVET"),
      onPressed: () {
        Navigator.of(context).pop();
        _buildShowDialog(context);
        _deleteCard();
      },
    );
    Widget noButton = TextButton(
      child: Text("HAYIR"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Silmek istediğinize emin misiniz?"),
      content: Text("Onayladığınızda bu bilgi kartı silinir.."),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _deleteCard() {
    dbrefx.child('ajandalar').child(_selectedkey).remove();
    _listenAjandas();
  }

  void _showBottomsheet() {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(5),
                    elevation: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_box_outlined,
                              size: 35,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Ajandaya Reçete Ekle',
                              style: TextStyle(fontSize: 20, color: Colors.black),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Eklemek istediğiniz Reçete Kodu',
                              style: TextStyle(fontSize: 15, color: Colors.brown),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            controller: _receteKodu,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.control_point_duplicate_outlined),
                              suffixIconColor: Colors.blue.shade700,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Ürün Uzunluğu',
                              style: TextStyle(fontSize: 15, color: Colors.brown),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                            controller: _urunUzunluk,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.code),
                              suffixIconColor: Colors.blue.shade700,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Reçetenin Kullanılacağı Ürün',
                              style: TextStyle(fontSize: 15, color: Colors.brown),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                            controller: _uruntipi,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.device_hub),
                              suffixIconColor: Colors.blue.shade700,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Yardımcı olacak reçete açıklaması',
                              style: TextStyle(fontSize: 15, color: Colors.brown),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                            controller: _aciklama,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.description),
                              suffixIconColor: Colors.blue.shade700,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 15,),
                            Text(_cubuklu == false ? 'Çubuksuz Reçete' : 'Çubuklu Reçete',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
                            SizedBox(width: 10,),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _cubuklu = !_cubuklu;
                                });
                              },
                              icon: Icon(Icons.compare_arrows,size: 30,color: Colors.blue.shade700),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                                _sendAjanda();
                              });
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_box_outlined,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Ajandaya Ekle',
                                  style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                                  maxLines: 1,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                );
            }));
  }

  _sendAjanda() async {
    _buildShowDialog(context);

    _key = dbrefx.child('ajandalar').push().key.toString();
    await dbrefx
        .child('ajandalar')
        .child(_key)
        .child('recetekodu')
        .set(_receteKodu.text);
    await dbrefx
        .child('ajandalar')
        .child(_key)
        .child('urunuzunluk')
        .set(_urunUzunluk.text);
    await dbrefx
        .child('ajandalar')
        .child(_key)
        .child('aciklama')
        .set(_aciklama.text);
    await dbrefx
        .child('ajandalar')
        .child(_key)
        .child('id')
        .set(_key.toString());
    await dbrefx.child('ajandalar').child(_key).child('cubuklu').set(_cubuklu);
    await dbrefx.child('ajandalar').child(_key).child('uruntipi').set(_uruntipi.text);

    Future.delayed(Duration(seconds: 3), () {
      Fluttertoast.showToast(
          msg: "Gönderildi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      _receteKodu.clear();
      _urunUzunluk.clear();
      _aciklama.clear();
      _uruntipi.clear();

      _listenAjandas();
    });
  }

  _buildShowDialog(BuildContext context) {
    _circularprogress = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _searchFilter() {

    final i = _recetemap.values.where((element,) =>
    element['urunuzunluk'].toString()
        .toLowerCase()
        .startsWith(
        _searchfilter.text.toString().trim().toLowerCase()));
    _receteList.clear();
    _receteList.addAll(i);
    _receteList = _receteList
      ..sort((a, b) =>
          b['recetekodu'].compareTo(a['recetekodu']));
  }

  _searchfilterCleaned() {
    _searchfilter.clear();
    _listenAjandas();
  }
}
