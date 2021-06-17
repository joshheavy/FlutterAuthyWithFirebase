import 'package:authy_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:authy_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  // final User? user;
  const HomeScreen({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Best Ui with Flutter', 
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut()
              );
            }, 
            icon: Icon(Icons.exit_to_app)
          )
        ],
      ),
      body: Center(
        child: Text(
          'Hey there welcome home',
          style: TextStyle(
            color: AppColors.textColors, 
            fontSize: 30, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}