// ignore_for_file: cascade_invocations

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:ordering_system/app/bloc/authentication_bloc.dart';
import 'package:ordering_system/features/authentication/bloc/login/login_bloc.dart';
import 'package:ordering_system/features/authentication/bloc/register/register_bloc.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/orders_bloc.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/qr_cubit.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_bloc.dart';
import 'package:ordering_system/features/dashboard/admin/sales/cubit/sales_cubit.dart';
import 'package:ordering_system/features/dashboard/user/cart/bloc/cart_bloc.dart';
import 'package:ordering_system/features/dashboard/user/products/bloc/product_bloc.dart';
import 'package:ordering_system/features/dashboard/user/products/cubit/add_product_cubit.dart';
import 'package:ordering_system/infrastructure/api.dart';
import 'package:ordering_system/infrastructure/auth_interceptor.dart';
import 'package:ordering_system/infrastructure/authentication_repository.dart';
import 'package:ordering_system/infrastructure/json_header_interceptor.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(),
  );

  getIt.registerSingleton<Dio>(
    Dio()
      ..interceptors.addAll([
        // JsonHeaderInterceptor(getIt()),
        AuthInterceptor(getIt()),
        LogInterceptor(requestBody: true, responseBody: true),
      ]),
  );

  getIt.registerSingleton<OrderingClient>(OrderingClient(getIt()));

  getIt.registerSingleton<AuthenticationRepository>(
    AuthenticationRepository(getIt(), getIt()),
  );

  getIt.registerLazySingleton<AuthenticationBloc>(
    () => AuthenticationBloc(
      authenticationRepository: getIt(),
      // flutterSecureStorage: getIt(),
    ),
  );

  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt()));

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      authenticationRepository: getIt(),
      // secureStorage: getIt(),
    ),
  );

  getIt
      .registerFactory<ProductBloc>(() => ProductBloc(orderingClient: getIt()));

  getIt.registerFactory<AddProductCubit>(
      () => AddProductCubit(orderingClient: getIt()));

  getIt.registerFactory<CartBloc>(() => CartBloc(orderingClient: getIt()));

  getIt.registerFactory<OrdersBloc>(() => OrdersBloc(orderingClient: getIt()));
  getIt.registerFactory<QRCubit>(() => QRCubit(orderingClient: getIt()));
  getIt.registerFactory<AdminProductBloc>(
      () => AdminProductBloc(orderingClient: getIt()));
  getIt.registerFactory<SalesCubit>(() => SalesCubit(orderingClient: getIt()));
}
