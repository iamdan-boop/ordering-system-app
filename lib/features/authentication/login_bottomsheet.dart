import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_system/domain/inputs/email.dart';
import 'package:ordering_system/features/authentication/bloc/login/login_bloc.dart';
import 'package:ordering_system/features/authentication/bloc/login/login_event.dart';
import 'package:ordering_system/features/authentication/bloc/login/login_state.dart';
import 'package:ordering_system/features/widgets/input_widget.dart';
import 'package:ordering_system/injection_container.dart';
import 'package:formz/formz.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({Key? key}) : super(key: key);

  @override
  _LoginBottomSheetState createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  InputWidget(
                    hintText: 'email@exampl.com',
                    onChange: (value) => context
                        .read<LoginBloc>()
                        .add(LoginEmailChanged(email: value ?? '')),
                  ),
                  const SizedBox(height: 20),
                  InputWidget(
                    obscureText: true,
                    hintText: 'Password',
                    onChange: (value) => context
                        .read<LoginBloc>()
                        .add(LoginPasswordChanged(password: value ?? '')),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: state.message.isNotEmpty,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              state.submissionStatus.isSubmissionInProgress
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepOrange),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            context.read<LoginBloc>().add(LoginSubmitted()),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
