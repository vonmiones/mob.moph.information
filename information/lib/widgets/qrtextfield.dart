import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;

  QRTextField({required this.controller, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        suffixIcon: InkWell(
          onTap: () async {
            String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                '#ff6666', 'Cancel', true, ScanMode.QR);
            controller.text = barcodeScanRes;
          },
          child: Icon(Icons.qr_code),
        ),
      ),
    );
  }
}
