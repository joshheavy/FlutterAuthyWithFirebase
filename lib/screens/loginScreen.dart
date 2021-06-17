import 'package:authy_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:authy_app/bloc/login_bloc/login_bloc.dart';
import 'package:authy_app/screens/screens.dart';
import 'package:authy_app/utils/AppColors.dart';
import 'package:authy_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc _loginBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !(state.isSubmitting!);
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isFailure!) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Login Failure"),
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
                      const Text("Logging In..."),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/Allura.png'),
                SizedBox(height: 10.0),
                Text(
                  'Sign In',
                  style: TextStyle(
                      color: AppColors.textColors,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: AppColors.textColors),
                                onPressed: () {},
                                child: Text('Forgot Password?')),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          CustomButton(
                            text: 'Sign In',
                            onPressed: () {
                              if(isButtonEnabled(state)){
                                _onFormSubmitted();
                              }
                            }
                          ),
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
                      "I'm a new User.",
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
                        'Sign Up',
                        style: TextStyle(
                            color: AppColors.buttonColors,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      ),
                    ),
                  ],
                ),
              ],
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
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
