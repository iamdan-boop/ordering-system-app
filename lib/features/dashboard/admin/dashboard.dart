import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/app/bloc/authentication_bloc.dart';
// import 'package:ordering_system/app/bloc/authentication_bloc.dart';
import 'package:ordering_system/app/bloc/authentication_event.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/order_event.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/order_state.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/orders_bloc.dart';
import 'package:ordering_system/features/dashboard/admin/products/products.dart';
import 'package:ordering_system/features/dashboard/admin/qr_scanner.dart';
import 'package:ordering_system/features/dashboard/admin/sales/sales_screen.dart';
import 'package:ordering_system/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final bloc = getIt<OrdersBloc>();

  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        title: const Text('Orders'),
        actions: [
          IconButton(
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => bloc..add(GetOrders()),
        child: BlocConsumer<OrdersBloc, OrderState>(
          listener: (context, state) {
            if (state.submissionStatus.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Cannot get Products')));
            }
            if (state.submissionStatus.isSubmissionSuccess) {
              _refreshController.refreshCompleted();
            }
          },
          builder: (context, state) {
            return state.checkouts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SmartRefresher(
                    header: const WaterDropMaterialHeader(
                      backgroundColor: Colors.deepOrange,
                      distance: 30.0,
                    ),
                    enablePullDown: true,
                    controller: _refreshController,
                    onRefresh: () =>
                        context.read<OrdersBloc>().add(GetOrders()),
                    child: SafeArea(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.checkouts.length,
                        itemBuilder: (context, index) {
                          final checkout = state.checkouts[index];

                          final price = checkout.products.map((value) {
                            return value.price * value.quantity!.toDouble();
                          }).reduce((value, element) => value + element);
                          return GestureDetector(
                            onTap: () => context
                                .read<OrdersBloc>()
                                .add(DeleteOrder(checkoutId: checkout.id)),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Card(
                                elevation: 2,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reference No. ${checkout.referenceNumber}',
                                      ),
                                      Text(
                                        'Booked by:  ${checkout.email}',
                                      ),
                                      Row(
                                        children: [
                                          const Text('Order STATUS:'),
                                          const SizedBox(width: 10),
                                          Container(
                                            height: 25,
                                            width: 70,
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color:
                                                  checkout.status == 'PENDING'
                                                      ? Colors.blue
                                                      : Colors.green,
                                              border: Border.all(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                                child: Text(
                                              checkout.status,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Total: $price',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.deepOrange,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const QRScanner(),
            // const QRScanner(),
          ),
        ),
        tooltip: 'CAMERA',
        child: const Icon(
          Icons.camera,
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
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SalesScreen())),
              child: const Text(
                'Sales',
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
            ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.add,
            //     // color: Colors.transparent,
            //   ),
            //   onPressed: () => Navigator.push(context,
            //       MaterialPageRoute(builder: (_) => const QRScanner())),
            // )
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminProductScreen())),
              child: const Text(
                'Products',
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
