import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PhoneNumberEntered extends LoginEvent {
  final String phoneNumber;

  PhoneNumberEntered(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class OtpSent extends LoginEvent {}

class OtpEntered extends LoginEvent {
  final String otp;

  OtpEntered(this.otp);

  @override
  List<Object> get props => [otp];
}

class LoginButtonPressed extends LoginEvent {}


