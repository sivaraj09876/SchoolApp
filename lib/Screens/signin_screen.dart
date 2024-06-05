import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schoolapplication/Screens/bottom_screen.dart';
import 'package:http/http.dart' as http;
import 'package:schoolapplication/cubit/userdata_cubit.dart';
import 'package:schoolapplication/utils.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(width: 200, image: AssetImage("assets/logo1.jpg")),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Welcome to School",
              textAlign: TextAlign.center,
            ),
          ),
          _FormContent(),
        ],
      ),
    )));
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  TextEditingController phone_number = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _loading =false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void login_api() async {
    setState(() {
      _loading =true;
    });
    final box = await Hive.openBox("login");
   
    final Map<String, dynamic> credentials ={
      "phone_number": phone_number.text,
      "password": password.text,
       "rememberme":_rememberMe
    } ;
    try {
      String url = "$base_url/login";
      final response = await http.post(Uri.parse(url), body: {
      "phone_number": phone_number.text,
      "password": password.text
    });
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String,dynamic> data = json.decode(response.body);
         final userdataCubit =BlocProvider.of<UserdataCubit>(context);
        userdataCubit.setData(data);
        if (_rememberMe) {
          await box.put("credential", json.encode(credentials));
        }
        await box.put("token", data["token"]);
       
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
      }
    } catch (e) {
      print(e);
    }finally{ 
      setState(() {
        _loading=false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setcred();
  }
  void setcred()async{
    final box =await Hive.openBox("login");
    final data = await box.get("credential");
    if(data!=null){
         final Map<String,dynamic> decode = json.decode(data);
    if(decode.isNotEmpty){
      phone_number.text = decode["phone_number"];
      password.text =decode["password"];
      _rememberMe = decode["rememberme"];
      setState(() {
        
      });
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: phone_number,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 10 || value.length > 10) {
                  return "Phone Number must 10 digits";
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: password,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Remember me'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),
            
          _loading ? CircularProgressIndicator() :  SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    login_api();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
