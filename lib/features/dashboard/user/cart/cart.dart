import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_system/domain/constants.dart';
import 'package:ordering_system/features/dashboard/user/cart/bloc/cart_bloc.dart';
import 'package:ordering_system/features/dashboard/user/cart/bloc/cart_event.dart';
import 'package:ordering_system/features/dashboard/user/cart/bloc/cart_state.dart';
import 'package:ordering_system/features/dashboard/user/cart/cart_qr.dart';
import 'package:ordering_system/injection_container.dart';
import 'package:formz/formz.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<CartBloc>()..add(GetCartContents()),
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.submissionStatus.isSubmissionSuccess &&
                state.referenceNumber.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartQRScreen(
                      referenceNumber: state.referenceNumber,
                    ),
                  ));
            }
            if (state.submissionStatus.isSubmissionSuccess) {
              _refreshController.refreshCompleted();
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SmartRefresher(
                header: const WaterDropMaterialHeader(
                  backgroundColor: Colors.deepOrange,
                  distance: 30.0,
                ),
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: () =>
                    context.read<CartBloc>().add(GetCartContents()),
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'My Cart',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepOrange,
                        ),
                      ),
                      // const SizedBox(height: 20),
                      state.submissionStatus.isSubmissionInProgress
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.cart.products.length,
                              itemBuilder: (context, index) {
                                final product = state.cart.products[index];
                                return Card(
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
                                              fit: BoxFit.cover,
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                roundedButton(
                                                  context: context,
                                                  icon: Icons.remove,
                                                  onTap: () => context
                                                      .read<CartBloc>()
                                                      .add(DecrementProductCart(
                                                          productId:
                                                              product.id)),
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  product.quantity.toString(),
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
                                                      .read<CartBloc>()
                                                      .add(IncrementProductCart(
                                                          productId:
                                                              product.id)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 40),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              product.price.toString(),
                                            ),
                                            const SizedBox(height: 40),
                                            Text(
                                              product.price.toString(),
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
                                );
                              },
                            ),
                      const SizedBox(height: 40),
                      state.submissionStatus.isSubmissionInProgress
                          ? const Center(child: CircularProgressIndicator())
                          : state.cart.products.isNotEmpty
                              ? Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.deepOrange),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (state.cart.products.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(const SnackBar(
                                            content: Text(
                                                'You dont have Product in your cart'),
                                          ));
                                        return;
                                      }
                                      context
                                          .read<CartBloc>()
                                          .add(CheckoutCart());
                                    },
                                    child: const Text(
                                      'Checkout',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                      // const SizedBox(height: 10),
                    ],
                  ),
                ),
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
