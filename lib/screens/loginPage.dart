import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/components/round_Button.dart';
import 'package:newsapp/ui/auth/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

//for handling empty box
final _formKey=GlobalKey<FormState>();
//for email and password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //calling dispose function
  //dispose when screen is not available =>releasing from memory
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //check if input is empty Form used
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefix: Icon(Icons.supervised_user_circle_outlined)
              ),
              validator: (value) {
                if(value!.isEmpty){
                  return 'Enter Email';
                }
                return null;
              },
            ),
            SizedBox(height: 50),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                prefix: Icon(Icons.lock)
              ),
              validator: (value) {
                if(value!.isEmpty){
                  return 'Enter Password';
                }
                return null;
              },
            ),
                ],
              )
              ),
            
            RoundButton(
              title: 'Login',
              onTap: (){
                if(_formKey.currentState!.validate()){

                }
              },
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                  }, 
                  child: Text("Sign up"))
              ],
            )
          ],
        ),
      ),
    );
  }
}