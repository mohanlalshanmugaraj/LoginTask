

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInDemo(),
    );
  }
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {

  String email = "";
  String name = "";
  String token = "";
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  var redirectURL = "https://SERVER_AS_PER_THE_DOCS.glitch.me/callbacks/sign_in_with_apple";

  var clientID = "517467026996-rm1gmqas4kj2efc4cd52duu2sbhu8fpd.apps.googleusercontent.com";

  void _handleSignIn() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();


      if (account != null) {
        String name = account.displayName ?? '';
        String email = account.email ?? '';
        GoogleSignInAuthentication authentication = await account
            .authentication;
        String token = authentication.accessToken ?? '';

        print('Name: $name');
        print('Email: $email');

        setState(() {
          this.name = name;
          this.email = email;
          this.token = token;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Widget getAppleSignIn() {
    return Platform.isIOS?  SignInWithAppleButton(
      onPressed: () async {

        // final session = await http.Client().post(
        //   signInWithAppleEndpoint,
        // );

        // If we got this far, a session based on the Apple ID credential has been created in your system,
        // and you can now set this as the app's session
        // ignore: avoid_print
        // print(session);




        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: clientID,
            redirectUri: Uri.parse(redirectURL),
          ),
        );

        setState(() {
          this.name = credential.givenName ?? "";
          this.email = credential.email ?? "";
          this.token = credential.identityToken ?? "";
        });

      },
    ):
    Container();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: Center(
        child: Column(
            children: [
            Spacer(),
        Text(email),
        Text(name),
        Text(token),
        SignInButton(
          Buttons.Google,
          onPressed: _handleSignIn,
        ), getAppleSignIn(),
      Spacer(),
      ],
    )),
    );
  }
}
