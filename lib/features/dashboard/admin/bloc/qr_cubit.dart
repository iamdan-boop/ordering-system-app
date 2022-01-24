import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/qr_state.dart';
import 'package:ordering_system/infrastructure/api.dart';

class QRCubit extends Cubit<QRState> {
  QRCubit({required OrderingClient orderingClient})
      : _orderingClient = orderingClient,
        super(const QRState());

  void getCheckout({
    required String referenceNumber,
  }) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      final checkout =
          await _orderingClient.getCheckout(referenceNumber: referenceNumber);
      emit(state.copyWith(
          checkout: checkout, submissionStatus: FormzStatus.submissionSuccess));
    } catch (err) {
      emit(state.copyWith(submissionStatus: FormzStatus.submissionFailure));
    }
  }

  void confirmOrder({
    required String referenceNumber,
  }) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      await _orderingClient.confirmCheckout(referenceNumber: referenceNumber);

      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionSuccess,
        message: 'Confirm Order Successfully',
      ));
    } catch (err) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  final OrderingClient _orderingClient;
}
