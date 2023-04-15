import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'google_sign_in_configs_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //       fit: BoxFit.fill, image: AssetImage('assets/login_bg.gif')),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Fund Trail Analysis",
                  style: GoogleFonts.bioRhyme(
                    fontSize: 30,
                    color: Colors.amber.shade700,
                  ),
                ),
              ),
              // Image.asset('assets/logo.png'),
              const SizedBox(
                height: 40,
              ),
              const GoogleSignInButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButtonWidget extends StatelessWidget {
  const GoogleSignInButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color? color = Colors.amber.shade700;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(60),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: OutlinedButton.icon(
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
          icon: const FaIcon(
            FontAwesomeIcons.google,
            color: Colors.white,
            size: 25,
          ),
          label: Text(' Sign In With Google ',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24,
              )),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
