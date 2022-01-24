import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CartQRScreen extends StatelessWidget {
  const CartQRScreen({
    Key? key,
    required this.referenceNumber,
  }) : super(key: key);

  final String referenceNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: QrImage(
                data: referenceNumber,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Screenshot the QR Code you might not see this next time',
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
