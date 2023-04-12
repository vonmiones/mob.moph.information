import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Function(Map<String, dynamic>) onDecode;

  QRTextField({
    required this.controller,
    required this.text,
    required this.onDecode,
  });

  @override
  _QRTextFieldState createState() => _QRTextFieldState();
}

class _QRTextFieldState extends State<QRTextField> {
  Map<String, dynamic>? decodedJson;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.text,
        suffixIcon: InkWell(
          onTap: () async {
            String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                '#ff6666', 'Cancel', true, ScanMode.QR);
            _decodeJson(barcodeScanRes);

            Map<String, dynamic> json = jsonDecode(barcodeScanRes);
            String hash = json['hash'];
            widget.controller.text = hash;
          },
          child: Icon(Icons.qr_code),
        ),
      ),
    );
  }

  void _decodeJson(String jsonString) {
    try {
      decodedJson = json.decode(jsonString);
      widget.onDecode(decodedJson!);
    } catch (e) {
      print(e);
      decodedJson = null;
    }
  }
}
