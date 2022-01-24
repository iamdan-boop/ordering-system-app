// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ordering_system/app/bloc/authentication_bloc.dart';
import 'package:ordering_system/app/bloc/authentication_event.dart';
import 'package:ordering_system/app/bloc/authentication_state.dart';
import 'package:ordering_system/features/authentication/bloc/login/login_bloc.dart';
import 'package:ordering_system/features/authentication/bloc/register/register_bloc.dart';
import 'package:ordering_system/features/authentication/login.dart';
import 'package:ordering_system/features/dashboard/admin/dashboard.dart';
import 'package:ordering_system/features/dashboard/user/products/prodcuts.dart';
import 'package:ordering_system/infrastructure/authentication_repository.dart';
import 'package:ordering_system/injection_container.dart';
import 'package:ordering_system/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get _navigator => _navigatorKey.currentState;
  String guestCheck = '';
  // bool isLoading = false;

  @override
  void initState() {
    // getIt<FlutterSecureStorage>().delete(key: 'authToken');
    _guestCheck(context);
    super.initState();
  }

  void _guestCheck(BuildContext context) async {
    final guest = await getIt<FlutterSecureStorage>().read(key: 'guest_login');
    if (guest != null && guest.isNotEmpty) {
      guestCheck = guest;
      return;
    }
    final user = await getIt<FlutterSecureStorage>().read(key: 'authToken');
    if (user != null && user.isNotEmpty) {
      await getIt<AuthenticationRepository>().me();
    }
    return;
  }

  @override
  void dispose() {
    context.read<AuthenticationBloc>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // ignore: avoid_dynamic_calls
          create: (context) => guestCheck.isNotEmpty
              ? getIt<AuthenticationBloc>()
              : getIt<AuthenticationBloc>()
            ..add(AuthenticationGuestCheck()),
        ),
        BlocProvider(
          create: (context) => getIt<LoginBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<RegisterBloc>(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          accentColor: const Color(0xFF13B9FF),
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          fontFamily: 'Poppins',
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        navigatorKey: _navigatorKey,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              print('currentState: ${state.status}');
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  if (state.isGuest) {
                    _navigator?.pushAndRemoveUntil<void>(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ProductScreen(),
                      ),
                      (route) => false,
                    );
                    break;
                  }
                  _navigator?.pushAndRemoveUntil<void>(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Dashboard(),
                    ),
                    (route) => false,
                  );
                  break;
                case AuthenticationStatus.guest:
                  _navigator?.pushAndRemoveUntil<void>(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ProductScreen(),
                    ),
                    (route) => false,
                  );
                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator?.pushAndRemoveUntil<void>(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                  break;
                default:
                  break;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
