import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(AuthApp());
}

class AuthApp extends StatefulWidget {
  const AuthApp({Key? key}) : super(key: key);

  @override
  _AuthAppState createState() => _AuthAppState();
}

class _AuthAppState extends State<AuthApp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:
              Text('Auth User (Logged ' + (user == null ? 'out' : 'in') + ')'),
        ),
        body: Form(
          key: _key,
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  // validator: validateEmail(emailController.text),
                ),
                TextFormField(
                  controller: passwordController,
                  // validator: validatePassword(passwordController.text),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(
                    child:
                        Text(errorMessage, style: TextStyle(color: Colors.red)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Sign Up'),
                        onPressed: user != null
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                  errorMessage = '';
                                });
                                if (_key.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  } on FirebaseAuthException catch (error) {
                                    errorMessage = error.message!;
                                  }
                                  setState(() => isLoading = false);
                                }
                              }),
                    ElevatedButton(
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Sign In'),
                        onPressed: user != null
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                  errorMessage = '';
                                });
                                if (_key.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  } on FirebaseAuthException catch (error) {
                                    errorMessage = error.message!;
                                  }
                                  setState(() => isLoading = false);
                                }
                              }),
                    ElevatedButton(
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Log Out'),
                        onPressed: user == null
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                  errorMessage = '';
                                });
                                try {
                                  await FirebaseAuth.instance.signOut();
                                  errorMessage = '';
                                } on FirebaseAuthException catch (error) {
                                  errorMessage = error.message!;
                                }
                                setState(() => isLoading = false);
                              }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validateEmail(String formEmail) {
    if (formEmail.isEmpty) return 'E-mail address is required.';

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) {
      return 'Invalid E-mail Address format.';
    }
    return '';
  }

  String validatePassword(String formPassword) {
    if (formPassword.isEmpty) return 'Password is required.';

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formPassword)) {
      return '''
      Password must be at least 8 characters,
      include an uppercase letter, number and symbol.
      ''';
    }

    return '';
  }
}
