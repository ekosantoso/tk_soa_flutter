import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class air extends StatefulWidget {
  const air({Key? key}) : super(key: key);

  @override
  _airState createState() => _airState();
}

class _airState extends State<air> {
  final myController = TextEditingController();
  String result="belum ada pembayaran";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getResult(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> addAir(String user,String nopelanggan) async {
    var url = Uri.parse('https://tugassoa-d546a-default-rtdb.asia-southeast1.firebasedatabase.app/air/$user.json');


    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "idtagihan": nopelanggan,
          'datetime': timestamp.toIso8601String(),
        }),
       );
    _getResult(FirebaseAuth.instance.currentUser!.uid);
  }
  Future<void> _getResult(String user) async {
    var url = Uri.parse(
        'https://tugassoa-d546a-default-rtdb.asia-southeast1.firebasedatabase.app/air/$user.json');


    final response = await http.get(url,
    );
  if(json.decode(response!.body)!=null){
    final Map<String, dynamic> extractedData = json.decode(response!.body);
    extractedData.forEach((k, v) => result = v['idtagihan']);
    setState(() {
      result = 'Pembayaran air terakhir dengan id pelanggan :'+ result;
    });
  }

  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Pembayaran'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Pembayaran air '),
                Text('dengan Id pelanggan ' + myController.text),
                Text('sebesar Rp 300.000,-')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Konfirmasi'),
              onPressed: () async {
                addAir(FirebaseAuth.instance.currentUser!.uid,
                     myController.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text('Id Pelanggan   '),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      labelText: 'Input Id Pelanggan',
                    ),
                  ),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                _showMyDialog();
              },
              child: Text('bayar'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Text(result),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}
