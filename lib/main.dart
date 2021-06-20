import 'package:authy_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:authy_app/bloc/login_bloc/login_bloc.dart';
import 'package:authy_app/bloc/register_bloc/register_bloc.dart';
import 'package:authy_app/bloc/simple_bloc_observer.dart';
import 'package:authy_app/repositories/user_repository.dart';
import 'package:authy_app/screens/screens.dart';
import 'package:authy_app/utils/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final UserRepository userRepository = UserRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(userRepository: userRepository),
        ), 
        BlocProvider(
          create: (context) => LoginBloc(userRepository: userRepository)
        ), 
        BlocProvider(
          create: (context) => RegisterBloc(userRepository: userRepository)
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.buttonColors,
        accentColor: Colors.blue,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen();
          } else if (state is AuthenticationSuccess) {
            return HomeScreen();
          } else if (state is AuthenticationInitial) {
            return MainScreen();
          }
          return Center(
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}


      // routes: {
      //   '/': (context) => MainScreen(),
      //   '/login': (context) => LoginScreen(),
      //   '/register': (context) => RegisterScreen(),
      //   '/home': (context) => HomeScreen()
      // },