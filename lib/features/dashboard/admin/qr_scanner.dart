import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/domain/constants.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/qr_cubit.dart';
import 'package:ordering_system/features/dashboard/admin/order.dart';
import 'package:ordering_system/injection_container.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'bloc/qr_state.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<QRCubit>(),
        child: BlocConsumer<QRCubit, QRState>(
          listener: (context, state) {
            if (state.submissionStatus.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text('Order not found please try again'),
                ));
            }
            if (state.submissionStatus.isSubmissionSuccess &&
                state.message.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
            }
          },
          builder: (context, state) {
            if (state.submissionStatus.isSubmissionInProgress) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.submissionStatus.isSubmissionSuccess) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.checkout.email),
                                Text(
                                  'Reference Number: ${state.checkout.referenceNumber}',
                                ),
                                Text('Date Booked: ${state.checkout.date}'),
                                Text('Order Status: ${state.checkout.status}')
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.checkout.products.length,
                                itemBuilder: (context, index) {
                                  final product =
                                      state.checkout.products[index];
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Image.network(
                                                  '$baseURL/storage/${product.folderName}/${product.fileName}',
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.contain,
                                                )
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[900],
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 40),
                                              ],
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('PHP ${product.price}'),
                                                const SizedBox(height: 40),
                                                Text(
                                                  'PHP ${product.price}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        state.submissionStatus.isSubmissionInProgress
                            ? const Center(child: CircularProgressIndicator())
                            : state.checkout.products.isNotEmpty
                                ? Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.deepOrange),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: TextButton(
                                      onPressed: () =>
                                          context.read<QRCubit>().confirmOrder(
                                                referenceNumber: state
                                                    .checkout.referenceNumber,
                                              ),
                                      child: const Text(
                                        'Confirm Order',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink()
                      ],
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: [
                Expanded(flex: 4, child: _buildQrView(context)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) => _onQRViewCreated(controller, context),
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        context.read<QRCubit>().getCheckout(referenceNumber: scanData.code!);
        return;
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
