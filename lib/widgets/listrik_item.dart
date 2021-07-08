import 'package:flutter/material.dart';

class ListrikItem extends StatelessWidget {
  const ListrikItem({
    Key? key,
    required this.id,
    required this.jenis,
    required this.idtagihan,
    required this.nominal,
    required this.idpelanggan,
    required this.transactiondate,
  }) : super(key: key);
  final int id;
  final String jenis;
  final String idpelanggan;
  final String idtagihan;
  final int nominal;
  final DateTime transactiondate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Text(this.jenis),
          width: 100,
        ),
        SizedBox(
          child: Text(this.idtagihan),
          width: 100,
        ),
      ],
    );
  }
}
