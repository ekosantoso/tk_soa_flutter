import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TV extends StatefulWidget {
  const TV({Key? key}) : super(key: key);

  @override
  _TVState createState() => _TVState();
}

class _TVState extends State<TV> {
  String dropdownValue = 'MNC Play';
  final myController = TextEditingController();
  String result="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getResult(FirebaseAuth.instance.currentUser!.uid);
  }
  Future<void> addTV(String user,String provider,String nopelanggan) async {
    var url = Uri.parse('http://34.101.81.236/tv/bayartv.php');

    Map<String,String> headers = {
      'Content-type' : 'application/x-www-form-urlencoded',
    };
    final response = await http.post(url,
        body: {
          "user": user,
          "provider": provider,
          "nopelanggan": nopelanggan
        },
        headers: headers);
    _getResult(FirebaseAuth.instance.currentUser!.uid);
  }
  Future<void> _getResult(String user) async {
    var url = Uri.parse('http://34.101.81.236/tv/historytv.php');

    Map<String,String> headers = {
      'Content-type' : 'application/x-www-form-urlencoded',
    };
    final response = await http.post(url,
        body: {
          "user": user
        },
        headers: headers);

    final extractedData = json.decode(response.body);
    setState(() {
      result=extractedData['message'];
    });


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
                Text('Pembayaran tipe ' + dropdownValue),
                Text('dengan Id pelanggan ' + myController.text),
                Text('sebesar Rp 300.000,-')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Konfirmasi'),
              onPressed: () async {
                addTV(FirebaseAuth.instance.currentUser!.uid,
                    dropdownValue, myController.text);
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
                  child: Text('Layanan TV Kabel   '),
                ),
                Card(
                  elevation: 3,
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['MNC Play', 'MyRepublic','First Media']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
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
