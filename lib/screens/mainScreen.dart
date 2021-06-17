import 'package:authy_app/screens/screens.dart';
import 'package:authy_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'package:authy_app/utils/AppColors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Allura.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'The Best Way to Make Your Ui',
                    style: TextStyle(
                      color: AppColors.textColors, 
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Sign Up', 
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  ),
                  color: AppColors.buttonColors,
                ), 
                SizedBox(height: 10.0),
                CustomButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> LoginScreen()),
                  ), 
                  text: 'Sign In',
                ), 
              ],
            )
          ],
        ),
      ),
    );
  }
}
