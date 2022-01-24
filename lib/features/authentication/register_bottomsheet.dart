import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_system/features/authentication/bloc/login/login_bloc.dart';
import 'package:ordering_system/features/authentication/bloc/login/login_event.dart';
import 'package:ordering_system/features/authentication/bloc/register/register_bloc.dart';
import 'package:ordering_system/features/authentication/bloc/register/register_event.dart';
import 'package:ordering_system/features/authentication/bloc/register/register_state.dart';
import 'package:ordering_system/features/widgets/input_widget.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/injection_container.dart';

class RegisterBottomSheet extends StatefulWidget {
  const RegisterBottomSheet({Key? key}) : super(key: key);

  @override
  _RegisterBottomSheetState createState() => _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends State<RegisterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
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
                        .read<RegisterBloc>()
                        .add(RegisterEmailChanged(email: value ?? '')),
                  ),
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
                        border: Border.all(color: Colors.lightBlue),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                        onPressed: () => context
                            .read<RegisterBloc>()
                            .add(RegisterSubmitted()),
                        child: const Text(
                          'Login as guest',
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
    );
  }
}
