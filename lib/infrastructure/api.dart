import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ordering_system/domain/constants.dart';
import 'package:ordering_system/infrastructure/inputs/register_request.dart';
import 'package:ordering_system/infrastructure/models/auth_token.dart';
import 'package:ordering_system/infrastructure/models/cart.dart';
import 'package:ordering_system/infrastructure/models/checkout.dart';
import 'package:ordering_system/infrastructure/models/product.dart';
import 'package:ordering_system/infrastructure/models/product_preview.dart';
import 'package:ordering_system/infrastructure/models/sales.dart';
import 'package:retrofit/http.dart';

part 'api.g.dart';

@RestApi(baseUrl: '$baseURL/api')
abstract class OrderingClient {
  factory OrderingClient(Dio dio, {String baseUrl}) = _OrderingClient;

  @GET('/me')
  Future<AuthToken> me();

  @GET('/guest-me')
  Future<Cart> guestCheck();

  // AUTHENTICATION
  @POST('/login')
  Future<AuthToken> login({
    @Field() required String email,
    @Field() required String password,
  });

  @POST('/login-guest')
  Future<Cart> loginGuest({
    @Query('email') required String email,
  });

  @POST('/register')
  Future<AuthToken> register({
    @Body() required RegisterRequest registerRequest,
  });

  // CART

  @POST('/cart/addProduct')
  Future<void> addProductToCart({
    @Field('id') required int productId,
    @Field('quantity') required int productQuantity,
  });

  @POST('/cart/removeProduct')
  Future<void> removeProductToCart({
    @Field() required int productId,
    @Field() required String email,
  });

  @PUT('/cart/product/increment/{product_id}')
  Future<void> incrementCartProductQuantity({
    @Path('product_id') required int productId,
  });

  @PUT('/cart/product/decrement/{product_id}')
  Future<void> decrementCartProductQuantity({
    @Path('product_id') required int productId,
  });

  @GET('/cart')
  Future<Cart> getCart();

  // CHECKOUTS

  @POST('/checkouts')
  Future<String> checkout();

  @GET('/checkouts')
  Future<List<Checkout>> getCheckouts();

  @GET('/checkouts/{reference_number}')
  Future<Checkout> getCheckout({
    @Path('reference_number') required String referenceNumber,
  });

  @PUT('/checkouts/{reference_number}')
  Future<void> confirmCheckout({
    @Path('reference_number') required String referenceNumber,
  });

  // PRODUCTS

  @GET('/products')
  Future<ProductPreview> getProducts({
    @Query('status') required String status,
  });

  @GET('/products/admin')
  Future<List<Product>> getAdminProducts();

  @DELETE('/products/{product}')
  Future<void> deleteProduct({
    @Path('product') required int productId,
  });

  @POST('/products')
  @MultiPart()
  Future<void> createProduct({
    @Part() required String name,
    @Part() required double price,
    @Part() required File preview,
    @Part() required String type,
  });

  @POST('/products/{product}')
  @MultiPart()
  Future<void> updateProduct({
    @Path('product') required int productId,
    @Query('_method') required String method,
    @Part() required String name,
    @Part() required double price,
    @Part() required File preview,
    @Part() required String type,
  });

  @DELETE('/checkouts/{checkout}')
  Future<void> deleteCheckout({
    @Path('checkout') required int checkoutId,
  });

  @GET('/sales')
  Future<Sales> getSales();
}
