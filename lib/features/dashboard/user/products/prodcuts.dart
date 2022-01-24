import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/domain/constants.dart';
import 'package:ordering_system/features/authentication/login.dart';
import 'package:ordering_system/features/dashboard/user/cart/cart.dart';
import 'package:ordering_system/features/dashboard/user/products/add_product.dart';
import 'package:ordering_system/features/dashboard/user/products/bloc/product_bloc.dart';
import 'package:ordering_system/features/dashboard/user/products/bloc/product_event.dart';
import 'package:ordering_system/features/dashboard/user/products/bloc/product_state.dart';
import 'package:ordering_system/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductBloc>()..add(GetProducts()),
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.submissionStatus.isSubmissionInProgress) {
            _refreshController.requestRefresh();
          }
          if (state.submissionStatus.isSubmissionSuccess) {
            _refreshController.refreshCompleted();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {
                    getIt<FlutterSecureStorage>().delete(key: 'guest_login');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                )
              ],
              backgroundColor: Colors.deepOrange,
              centerTitle: true,
              title: const Text(
                'Products',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: SmartRefresher(
              header: const WaterDropMaterialHeader(
                backgroundColor: Colors.deepOrange,
                distance: 30.0,
              ),
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: () => context.read<ProductBloc>().add(GetProducts()),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   height: 150,
                    //   width: double.infinity,
                    //   child: state.products.topSelling.isNotEmpty
                    //       ? ListView.builder(
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: state.products.topSelling.length,
                    //           shrinkWrap: true,
                    //           itemBuilder: (context, index) {
                    //             return ListTile(
                    //               onTap: () => Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (_) => AddProductScreen(
                    //                     product:
                    //                         state.products.topSelling[index],
                    //                   ),
                    //                 ),
                    //               ),
                    //               title: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Text(state
                    //                       .products.topSelling[index].name),
                    //                   TextButton(
                    //                     onPressed: () {},
                    //                     child: const Text('Add to Cart'),
                    //                   ),
                    //                 ],
                    //               ),
                    //               subtitle: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     'PHP ${state.products.topSelling[index].price}',
                    //                   ),
                    //                   const SizedBox(height: 10),
                    //                   Image.network(
                    //                     '$baseURL/storage/${state.products.topSelling[index].folderName}/${state.products.topSelling[index].fileName}',
                    //                     // height: 100,
                    //                     width: double.infinity,
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           },
                    //         )
                    //       : const Center(
                    //           child: Text('No Current Top Products'),
                    //         ),
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(
                    //     horizontal: 10,
                    //     vertical: 10,
                    //   ),
                    //   height: 150,
                    //   width: double.infinity,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       const Text(
                    //         'Top Selling Products',
                    //         style: TextStyle(
                    //           fontSize: 19,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Top Selling Products',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 250,
                      width: double.infinity,
                      child: state.products.topSelling.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.products.topSelling.length,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final topSelling =
                                    state.products.topSelling[index];
                                return Card(
                                  elevation: 2,
                                  color: Colors.white,
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: ListTile(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddProductScreen(
                                            product: state
                                                .products.topSelling[index],
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(topSelling.name),
                                          // TextButton(
                                          //   onPressed: () {},
                                          //   child: const Text('Add to Cart'),
                                          // ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'PHP ${topSelling.price}',
                                          ),
                                          const SizedBox(height: 10),
                                          Image.network(
                                            '$baseURL/storage/${topSelling.folderName}/${topSelling.fileName}',
                                            // height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No Current Silog Products'),
                            ),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'SILOG',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 250,
                      width: double.infinity,
                      child: state.products.silog.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.products.silog.length,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final silog = state.products.silog[index];
                                return Card(
                                  elevation: 2,
                                  color: Colors.white,
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: ListTile(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddProductScreen(
                                            product:
                                                state.products.silog[index],
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(silog.name),
                                          // TextButton(
                                          //   onPressed: () {},
                                          //   child: const Text('Add to Cart'),
                                          // ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'PHP ${silog.price}',
                                          ),
                                          const SizedBox(height: 10),
                                          Image.network(
                                            '$baseURL/storage/${silog.folderName}/${silog.fileName}',
                                            // height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No Current Silog Products'),
                            ),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'BEVERAGES',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 250,
                      width: double.infinity,
                      child: state.products.beverages.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.products.beverages.length,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final beverages =
                                    state.products.beverages[index];
                                return Card(
                                  elevation: 2,
                                  color: Colors.white,
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: ListTile(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddProductScreen(
                                            product: beverages,
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(beverages.name),
                                          // TextButton(
                                          //   onPressed: () {},
                                          //   child: const Text('Add to Cart'),
                                          // ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'PHP ${beverages.price}',
                                          ),
                                          const SizedBox(height: 10),
                                          Image.network(
                                            '$baseURL/storage/${beverages.folderName}/${beverages.fileName}',
                                            // height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No Current Beverages Products'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              ),
              tooltip: 'CART',
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.deepOrange,
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 4.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.transparent,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.transparent,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// class SilogTile extends StatelessWidget {
//   const SilogTile({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 150,
//       width: 70,
//       child: ListTile(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => AddProductScreen(
//               product: state.products.silog[index],
//             ),
//           ),
//         ),
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(state.products.silog[index].name),
//             TextButton(
//               onPressed: () {},
//               child: const Text('Add to Cart'),
//             ),
//           ],
//         ),
//         subtitle: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'PHP ${state.products.silog[index].price}',
//             ),
//             const SizedBox(height: 10),
//             Image.network(
//               '$baseURL/storage/${state.products.silog[index].folderName}/${state.products.silog[index].fileName}',
//               // height: 100,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ],
//         ),
//       ),
//     );
  // }
// }
