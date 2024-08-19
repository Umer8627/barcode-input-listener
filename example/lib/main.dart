import 'package:flutter/material.dart';
import 'package:barcode_input_listener/barcode_input_listener.dart';

void main() {
  runApp(const BarcodeInputExampleApp());
}

class BarcodeInputExampleApp extends StatelessWidget {
  const BarcodeInputExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Barcode Input Listener Example',
      home: BarcodeInputExamplePage(),
    );
  }
}

class BarcodeInputExamplePage extends StatefulWidget {
  const BarcodeInputExamplePage({super.key});

  @override
  State<BarcodeInputExamplePage> createState() =>
      _BarcodeInputExamplePageState();
}

class _BarcodeInputExamplePageState extends State<BarcodeInputExamplePage> {
  String _scannedBarcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Input Listener Example'),
      ),
      body: BarcodeInputListener(
        useKeyDownEvent: true,
        onBarcodeScanned: (barcode) {
          setState(() {
            _scannedBarcode = barcode;
          });
        },
        child: Center(
          child: Text(
            'Scanned Barcode: $_scannedBarcode',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
