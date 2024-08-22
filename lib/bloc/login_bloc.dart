import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/login_event.dart';
import '../states/login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<PhoneNumberEntered>((event, emit) {
      emit(OtpSentState(event.phoneNumber));
    });

    on<OtpSent>((event, emit) {
      final currentState = state;
      if (currentState is OtpSentState) {
        emit(OtpSentState(currentState.phoneNumber));
      }
    });

    on<OtpEntered>((event, emit) {
      final currentState = state;
      if (currentState is OtpSentState) {
        emit(OtpVerifiedState(currentState.phoneNumber, event.otp));
      }
    });

    on<LoginButtonPressed>((event, emit) {
      final currentState = state;
      if (currentState is OtpVerifiedState) {

        emit(OtpVerifiedState(currentState.phoneNumber, currentState.otp));
      }
    });
  }
}


