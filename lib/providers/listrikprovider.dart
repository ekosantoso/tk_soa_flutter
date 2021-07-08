import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Listrik {
  final int id;
  final String jenis;
  final String idpelanggan;
  final String idtagihan;
  final int nominal;
  final DateTime transactiondate;

  Listrik({
    required this.id,
    required this.jenis,
    required this.idpelanggan,
    required this.idtagihan,
    required this.nominal,
    required this.transactiondate,
  });

  factory Listrik.fromJson(Map<String, dynamic> parsedJson){
    return Listrik(
        id: parsedJson['id'],
        jenis : parsedJson['jenis'].toString(),
        idpelanggan: parsedJson['idpelanggan'].toString(),
        idtagihan: parsedJson['idtagihan'].toString(),
        nominal : parsedJson['nominal'],
        transactiondate:new DateFormat("yyyy-MM-dd hh:mm:ss").parse(parsedJson['transactiondate'])
    );
  }
}

class ListrikProvider with ChangeNotifier {
 List <Listrik> _items = [];

 List<Listrik> get items {

   return [..._items];
 }

  int get itemCount {
    return _items.length;
  }

  Future<void> addListrik(Listrik listrikItem) async {
    var url = Uri.parse('http://34.101.81.236:8777/tugassoa/listrik');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    final timestamp = DateTime.now();
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(url,
        body: json.encode({
          'jenis': listrikItem.jenis,
          'idpelanggan': listrikItem.idpelanggan,
          'idtagihan': listrikItem.idtagihan,
          'nominal': listrikItem.nominal,
          'transactiondate': formattedDate,
        }),
        headers: headers);
    final newProduct = Listrik(
      id: json.decode(response.body)['id'],
      jenis:listrikItem.jenis,
      idpelanggan: listrikItem.idpelanggan,
      idtagihan: listrikItem.idtagihan,
      nominal: listrikItem.nominal,
      transactiondate: now,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> fetchAndSetListrik(String uid) async {
    var url = Uri.parse('http://34.101.81.236:8777/tugassoa/listrik/$uid');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);

      if(extractedData==null){
        return;
      }
    final List<Listrik> loadedProducts  = (extractedData as List)
          .map((data) => new Listrik.fromJson(data))
          .toList();

      _items = loadedProducts;
      print(response);
    } catch (error) {
      throw (error);
    }
  }
}
