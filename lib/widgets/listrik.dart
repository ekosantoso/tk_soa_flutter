import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tk_soa_flutter/providers/listrikprovider.dart';
import 'package:tk_soa_flutter/widgets/listrik_item.dart';

class listrik extends StatefulWidget {
  const listrik({Key? key}) : super(key: key);

  @override
  _listrikState createState() => _listrikState();
}

class _listrikState extends State<listrik> {
  String dropdownValue = 'Token Listrik';
  String dropdownValue2 = '20000';
  final myController = TextEditingController();
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<ListrikProvider>(context, listen: false)
        .fetchAndSetListrik(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    // TODO: implement initState
    super.initState();
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
                Text('sebesar ' + dropdownValue2)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Konfirmasi'),
              onPressed: () async {
                Listrik l = new Listrik(
                    id: 0,
                    idpelanggan: FirebaseAuth.instance.currentUser!.uid,
                    idtagihan: myController.text,
                    jenis: dropdownValue,
                    nominal: int.parse(dropdownValue2),
                    transactiondate: DateTime.now());
                await Provider.of<ListrikProvider>(context, listen: false)
                    .addListrik(l);
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
    final listrik = Provider.of<ListrikProvider>(context);

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
                  child: Text('Jenis Produk Listrik   '),
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
                    items: <String>['Token Listrik', 'Tagihan Listrik']
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
            dropdownValue == 'Token Listrik'
                ? Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text('Nominal   Rp.'),
                      ),
                      Card(
                        elevation: 3,
                        child: DropdownButton<String>(
                          value: dropdownValue2,
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
                              dropdownValue2 = newValue!;
                            });
                          },
                          items: <String>['20000', '50000', '100000']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )
                : Container(),
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
            FutureBuilder(
              future: _ordersFuture,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    return Center(
                      child: Text('error'),
                    );
                  } else {
                    return Consumer<ListrikProvider>(
                      builder: (ctx, orderData, child) => SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          children: [
                            Row(children: [
                              SizedBox(
                                child: Text("Jenis"),
                                width: 85,
                              ),
                              SizedBox(
                                child: Text("Id Pelanggan"),
                                width: 70,
                              ),
                              SizedBox(
                                child: Text("Nominal"),
                                width: 70,
                              ),
                              SizedBox(
                                child: Text("Tanggal"),
                                width: 85,
                              ),
                            ],),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (ctx, i) => ListrikItem(
                                  id: listrik.items[i]!.id,
                                  jenis: listrik.items[i]!.jenis,
                                  idtagihan: listrik.items[i]!.idtagihan,
                                  nominal: listrik.items[i]!.nominal,
                                  idpelanggan: listrik.items[i]!.idpelanggan,
                                  transactiondate:
                                      listrik.items[i]!.transactiondate),
                              itemCount: listrik.items.length,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
