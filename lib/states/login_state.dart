import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class OtpSentState extends LoginState {
  final String phoneNumber;

  OtpSentState(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class OtpVerifiedState extends LoginState {
  final String phoneNumber;
  final String otp;

  OtpVerifiedState(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object> get props => [message];
}
