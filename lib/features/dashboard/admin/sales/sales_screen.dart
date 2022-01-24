import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_system/domain/constants.dart';
import 'package:ordering_system/features/dashboard/admin/sales/cubit/sales_cubit.dart';
import 'package:ordering_system/features/dashboard/admin/sales/cubit/sales_state.dart';
import 'package:ordering_system/infrastructure/models/product.dart';
import 'package:ordering_system/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:formz/formz.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Sales',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: BlocProvider(
        create: (context) => getIt<SalesCubit>()..getSales(),
        child: BlocConsumer<SalesCubit, SalesState>(
          listener: (context, state) {
            if (state.submissionStatus.isSubmissionInProgress) {
              _refreshController.requestRefresh();
            }
            if (state.submissionStatus.isSubmissionSuccess) {
              _refreshController.refreshCompleted();
            }
          },
          builder: (context, state) {
            return SmartRefresher(
              header: const WaterDropMaterialHeader(
                backgroundColor: Colors.deepOrange,
                distance: 30.0,
              ),
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: () => context.read<SalesCubit>().getSales(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SafeArea(
                      child: SfCartesianChart(
                        // Initialize category axis
                        primaryXAxis: CategoryAxis(),
                        series: <SplineSeries<Product, String>>[
                          SplineSeries(
                            dataSource: state.sales.sales,
                            dataLabelMapper: (Product sales, _) => sales.name,
                            xValueMapper: (Product sales, _) => sales.name,
                            yValueMapper: (Product sales, _) =>
                                sales.quantity!.toDouble() * sales.price,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Product')),
                        DataColumn(label: Text('TOTAL')),
                        DataColumn(label: Text('Daily')),
                        DataColumn(label: Text('Yearly')),
                      ],
                      rows: state.sales.yearDailySales
                          .map(
                            (e) => DataRow(cells: [
                              DataCell(Text(e.name.toString())),
                              DataCell(
                                  Text('${double.parse(e.daily!) * e.price}')),
                              DataCell(Text(e.daily.toString())),
                              DataCell(
                                Text(e.yearly.toString()),
                              )
                            ]),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Best Beverages Products',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 250,
                      width: double.infinity,
                      child: state.sales.topBeverages.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.sales.topBeverages.length,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final beverage =
                                    state.sales.topBeverages[index];
                                return Card(
                                  elevation: 2,
                                  color: Colors.white,
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: ListTile(
                                      title: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(beverage.name),
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
                                            'PHP ${beverage.price}',
                                          ),
                                          const SizedBox(height: 10),
                                          Image.network(
                                            '$baseURL/storage/${beverage.folderName}/${beverage.fileName}',
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
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Best  Silog Products',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 250,
                      width: double.infinity,
                      child: state.sales.topSilogs.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.sales.topSilogs.length,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final silog = state.sales.topSilogs[index];
                                return Card(
                                  elevation: 2,
                                  color: Colors.white,
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: ListTile(
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.name, this.quantity);

  final String name;
  final String quantity;
}
