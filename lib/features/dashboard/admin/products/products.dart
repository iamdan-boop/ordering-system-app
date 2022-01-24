import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/domain/constants.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_bloc.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_event.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_state.dart';
import 'package:ordering_system/features/dashboard/admin/products/create-product.dart';
import 'package:ordering_system/features/dashboard/admin/products/edit-product.dart';
import 'package:ordering_system/injection_container.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({Key? key}) : super(key: key);

  @override
  _AdminProductScreenState createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  @override
  Widget build(BuildContext context) {
    final productBloc = getIt<AdminProductBloc>();
    return BlocProvider(
      create: (_) => productBloc..add(GetProducts()),
      child: BlocConsumer<AdminProductBloc, ProductState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.deepOrange,
              centerTitle: true,
              title: const Text('Products'),
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateProductScreen(
                        bloc: productBloc,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: Container(
              child: state.submissionStatus.isSubmissionInProgress
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProductScreen(
                                product: product,
                                bloc: productBloc,
                              ),
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(product.name),
                              TextButton(
                                onPressed: () => context
                                    .read<AdminProductBloc>()
                                    .add(DeleteProduct(productId: product.id)),
                                child: Text(
                                  'Delete Product',
                                  style: TextStyle(color: Colors.red[600]),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PHP ${product.price}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.network(
                                '$baseURL/storage/${product.folderName}/${product.fileName}',
                                // height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
