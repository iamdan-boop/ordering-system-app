import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_system/domain/constants.dart';
import 'package:ordering_system/features/dashboard/user/products/cubit/add_product_cubit.dart';
import 'package:ordering_system/features/dashboard/user/products/cubit/add_product_state.dart';
import 'package:ordering_system/infrastructure/models/product.dart';
import 'package:ordering_system/injection_container.dart';
import 'package:formz/formz.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<AddProductCubit>()
          ..setProductId(productId: widget.product.id),
        child: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state.submissionStatus.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state.submissionStatus.isSubmissionSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text('Product Added to Cart Successfully'),
                ));
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        widget.product.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 27,
                        ),
                      ),
                      Text(
                        'P ${widget.product.price.toString()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          // color: Colors.lightBlue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.network(
                          '$baseURL/storage/${widget.product.folderName}/${widget.product.fileName}',
                          height: 120,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          roundedButton(
                            context: context,
                            icon: Icons.remove,
                            onTap: () => context
                                .read<AddProductCubit>()
                                .decrementProductQuantity(),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            state.productQuantity.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(width: 20),
                          roundedButton(
                            context: context,
                            icon: Icons.add,
                            onTap: () => context
                                .read<AddProductCubit>()
                                .incrementProductQuantity(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  state.submissionStatus.isSubmissionInProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightBlue),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextButton(
                            onPressed: () => context
                                .read<AddProductCubit>()
                                .addProductToCart(),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Container roundedButton({
    required BuildContext context,
    required IconData icon,
    required Function() onTap,
  }) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
