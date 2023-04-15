import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:pdf_text/pdf_text.dart';
import 'transactions.dart';
import 'accountnumber.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_login_configs_provider/google_sign_in_configs_app.dart';
import 'google_login_configs_provider/login_page.dart';
import 'tax.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(

    MaterialApp(
      home: FirstPage(),
    )
);
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MyApp();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),

    );
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  PDFDoc? _pdfDoc;
  String _text = "";
  int _computerCount=0;
  double sum =0;
  bool _buttonsEnabled = true;
  String _numbers = r'\d+(\.\d+)?';
  String numbers = "([0-9]{1,3}(,[0-9]{3})*([.][0-9]+)?)";
  String number = "([0-9]{1,3}(,[0-9]{3})*([.][0-9]+)?)";
  double tax=0;
  var popularNumbers = [];
  int elevatorButtonNumber = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bank Statement Analyser'),
          backgroundColor: Colors.blueAccent,
        ),

        body:
        Center(
          child: Container(

            alignment: Alignment.center,
            padding: EdgeInsets.all(20),

            child:
              ListView(

                children: <Widget>[

                  TextButton(
                    child: Text(
                      "Pick the Bank Statement",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor: Colors.blueAccent),
                    onPressed: _pickPDFText,
                  ),
                  /*TextButton(
                    child: Text(
                      "Read random page",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor: Colors.blueAccent),
                    onPressed: _buttonsEnabled ? _readRandomPage : () {},
                  ),*/
                  TextButton(
                    child: Text(
                      "Read whole document",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor: Colors.blueAccent),
                    onPressed: _buttonsEnabled ? _readWholeDoc : () {},
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // pattern to match numbers without commas and decimals
                      RegExp reExp = RegExp(_numbers);
                      Iterable<Match> match = reExp.allMatches(_text);
                      List<double> numberset = [];
                      for (Match match in match) {
                        String matchText = match.group(0)!;
                        double number = double.parse(matchText);
                        if (number > 100000000) {
                          numberset.add(number);
                        }
                      }
                          print("Account numbers: $numberset");
                          Navigator.push(context,MaterialPageRoute(builder: (context) => AccountnumberPage(numberset: numberset)));
                          },
                    child: Text("Find Account number"),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor: Colors.blueAccent),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // pattern to match numbers
                      RegExp regExp = new RegExp(numbers);
                      Iterable<Match> matches = regExp.allMatches(_text);
                      List<double> numbersSet = [];
                      for (Match match in matches) {
                        String matchText = match.group(0)!;
                        double number = double.parse(matchText.replaceAll(",", ""));
                        if(number > 499999 && number<10000000) {
                          numbersSet.add(number);
                        }
                        sum=numbersSet.sum ;
                        tax=sum*0.45;

                      }
                      print("Numbers in the document: $numbersSet");
                      print(tax);
                      Navigator.push(context,MaterialPageRoute(builder: (context) => TransactionsPage(numbersSet: numbersSet,tax:tax)));
                    },
                    child: Text("Find the transactions above 500000"),
                      style: TextButton.styleFrom(
                  padding: EdgeInsets.all(15),
              backgroundColor: Colors.blueAccent),
                  ),



          // pattern to match numbers


      ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => taxPage(tax: tax)),
                  );
                },
                child: Text('Go to Tax Page'),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    backgroundColor: Colors.blueAccent),
              ),



      Padding(
                    child: Text(
                      _pdfDoc == null
                          ? "Pick a new bank statement and wait for it to load..."
                          : "PDF document loaded, ${_pdfDoc!.length} pages\n",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(15),
                  ),
                  Padding(
                    child: Text(
                      _text == "" ? "" : "Information in the bank statement",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(15),
                  ),
                  Text(_text),





                ],
              ),
          ),


        ),
        drawer:Drawer(
          child:Column(
            children: <Widget>[
              UserAccountsDrawerHeader(accountName: Text(FirebaseAuth.instance.currentUser!.displayName!.toString()), accountEmail: Text(FirebaseAuth.instance.currentUser!.email!.toString()),
              currentAccountPicture:CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('FTA')
              ) ,

              ),
              ListTile(
                title: Text('Settings'),
                leading:Icon(Icons.settings),

              ),
              Divider(
                height: 1.0,
              ),
        ListTile(
            onTap: () {
              final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },

          leading: Icon (Icons.logout), title: const Text(

          "Logout",

          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        ),

            ],
          )
        )
      ),
    );
  }

  /// Picks a new PDF document from the device
  Future _pickPDFText() async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);
      setState(() {});
    }
  }

  /// Reads a random page of the document
  Future _readRandomPage() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text =
    await _pdfDoc!.pageAt(Random().nextInt(_pdfDoc!.length) + 1).text;

    setState(() {
      _text = text;
      _buttonsEnabled = true;
    });
  }

  /// Reads the whole document
  Future _readWholeDoc() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text = await _pdfDoc!.text;



    setState(() {
      _text = text;
      _buttonsEnabled = true;
    });
  }
}

