import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_bloc.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_event.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_state.dart';
import 'package:ordering_system/features/widgets/input_widget.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final AdminProductBloc bloc;

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AdminProductBloc, ProductState>(
        bloc: widget.bloc,
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  state.productPreview == null
                      ? const Placeholder(
                          fallbackHeight: 150,
                          fallbackWidth: 150,
                        )
                      : Image.file(
                          state.productPreview!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          final file = File(result.files.single.path!);
                          widget.bloc.add(ProductPreviewChanged(file));
                        }
                      },
                      child: const Text(
                        'Upload File',
                        style: TextStyle(
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: Colors.deepOrange,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [],
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  InputWidget(
                    hintText: 'Product Name',
                    onChange: (val) =>
                        widget.bloc.add(ProductNameChanged(val!)),
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    hintText: 'Product Price',
                    onChange: (val) => widget.bloc
                        .add(ProductPriceChanged(double.parse(val!))),
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    hintText: 'Product Type',
                    onChange: (val) =>
                        widget.bloc.add(ProductTypeChanged(val!)),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepOrange),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () => widget.bloc.add(ProductSubmitted()),
                      child: const Text(
                        'Upload Product',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
