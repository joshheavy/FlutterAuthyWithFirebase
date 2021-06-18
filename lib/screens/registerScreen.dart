import 'package:authy_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:authy_app/bloc/register_bloc/register_bloc.dart';
import 'package:authy_app/screens/screens.dart';
import 'package:authy_app/utils/AppColors.dart';
import 'package:authy_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !(state.isSubmitting!);
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.isFailure!) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Register Failure"),
                      const Icon(Icons.error)
                    ],
                  ),
                  backgroundColor: AppColors.buttonColors,
                ),
              );
          }
          if (state.isSubmitting!) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Registering..."),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    ],
                  ),
                  backgroundColor: AppColors.buttonColors,
                ),
              );
          }
          if (state.isSuccess!) {
            BlocProvider.of<AuthenticationBloc>(context).add(
              AuthenticationLoggedIn(),
            );
            Navigator.pop(context);
          }
        },
        child: DismissKeyboard(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/Allura.png'),
                  SizedBox(height: 10.0),
                  Text(
                    'Create an Account',
                    style: TextStyle(
                        color: AppColors.textColors,
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0),
                  ),
                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      return Form(
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _fullnameController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  icon: const Icon(Icons.email),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  icon: const Icon(Icons.phone_android),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                validator: (_) {
                                  return !(state.isEmailValid!)
                                      ? 'Invalid Email'
                                      : null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  icon: const Icon(Icons.email),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                autocorrect: false,
                                validator: (_) {
                                  return !(state.isPasswordValid!)
                                      ? 'Invalid Password'
                                      : null;
                                },
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.lock),
                                  labelText: 'Password',
                                  suffixIcon: const Icon(Icons.remove_red_eye),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            CustomButton(
                                color: AppColors.buttonColors,
                                text: 'Sign Up',
                                onPressed: () {
                                  if (isButtonEnabled(state)) {
                                    _onFormSubmitted();
                                  }
                                }),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I'm already a member.",
                        style: TextStyle(
                            color: AppColors.textColors,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      TextButton(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _fullnameController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    _registerBloc
        .add(RegisterPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(RegisterSubmitted(
        email: _emailController.text, password: _passwordController.text));
  }
}
