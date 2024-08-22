import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../event/login_event.dart';
import '../states/login_state.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => LoginBloc(),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildIllustration(),
                    SizedBox(height: 30.0),
                    state is LoginInitial
                        ? _buildPhoneInput(context)
                        : state is OtpSentState
                        ? _buildOtpInput(context, state.phoneNumber)
                        : state is OtpVerifiedState
                        ? _buildSuccessScreen(context, state.phoneNumber, state.otp)
                        : Container(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Image.asset(
        'assets/images/login.png',
        height: 200,
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter your phone number',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20.0),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: Icon(Icons.phone),
              errorText: !_isValid ? 'Please enter a valid 10-digit phone number' : null,
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: (value) {
              if (value == null || value.length != 10) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isValid = _formKey.currentState!.validate();
            });

            if (_isValid) {
              BlocProvider.of<LoginBloc>(context).add(PhoneNumberEntered(_phoneController.text));
              BlocProvider.of<LoginBloc>(context).add(OtpSent());
            }
          },
          child: Text('Send OTP'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput(BuildContext context, String phoneNumber) {
    return Column(
      children: [
        Text(
          'Phone Number: $phoneNumber',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _otpController,
          decoration: InputDecoration(
            labelText: 'Enter OTP',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: Icon(Icons.lock),
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: (value) {
            if (value.length == 6) {
              BlocProvider.of<LoginBloc>(context).add(OtpEntered(value));
            }
          },
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: _otpController.text.length == 6
              ? () {
            BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed());
          }
              : null,
          child: Text('Login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessScreen(BuildContext context, String phoneNumber, String otp) {
    return Column(
      children: [
        Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
        SizedBox(height: 20.0),
        Text(
          'Login Successful!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        SizedBox(height: 20.0),
        Card(
          color: Colors.teal[50],
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Phone Number: $phoneNumber',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10.0),
                Text(
                  'OTP: $otp',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<LoginBloc>(context).add(PhoneNumberEntered(''));
          },
          child: Text('Return to Login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}



