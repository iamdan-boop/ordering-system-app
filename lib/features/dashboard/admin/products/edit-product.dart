import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_system/domain/constants.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_bloc.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_event.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_state.dart';
import 'package:ordering_system/features/widgets/input_widget.dart';
import 'package:ordering_system/infrastructure/models/product.dart';

import 'package:formz/formz.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    Key? key,
    required this.bloc,
    required this.product,
  }) : super(key: key);

  final AdminProductBloc bloc;
  final Product product;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AdminProductBloc, ProductState>(
        bloc: widget.bloc
          ..add(ProductNameChanged(widget.product.name))
          ..add(ProductPriceChanged(widget.product.price))
          ..add(ProductTypeChanged(widget.product.type)),
        listener: (context, state) {
          if (state.submissionStatus.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Product Updated Successfully'),
              ));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  state.productPreview == null
                      ? Image.network(
                          '$baseURL/storage/${widget.product.folderName}/${widget.product.fileName}',
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
                    defaultText: widget.product.name,
                    hintText: 'Product Name',
                    onChange: (val) =>
                        widget.bloc.add(ProductNameChanged(val!)),
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    defaultText: widget.product.price.toString(),
                    hintText: 'Product Price',
                    onChange: (val) => widget.bloc
                        .add(ProductPriceChanged(double.parse(val!))),
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    defaultText: widget.product.type,
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
                      onPressed: () => widget.bloc
                          .add(ProductUpdateSubmitted(widget.product.id)),
                      child: const Text(
                        'Update Product',
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
