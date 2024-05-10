import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:http/http.dart' as http;
import 'package:spell_check_on_client/spell_check_on_client.dart';
import 'package:mailer/mailer.dart';

import '../models/emotion_checker.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../resources/storage_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../utils/utils.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC_7Wx5IGBLVTT_m3YbxSShMP5XsG_mzG8",
        appId: "1:470511035915:web:6b775e82ac3cc737c6090e",
        messagingSenderId: "470511035915",
        projectId: "test-4444b",
        storageBucket: 'test-4444b.appspot.com'
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bambino',
        theme: ThemeData(),
      //home: SignupScreen(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (kIsWeb){
            return const sliderIntro(scale: 2, scale2: 2);
            }
            return const sliderIntro(scale: 1, scale2: 1);
          },
        ),
      ),
    );
  }
}

class sliderIntro extends StatefulWidget {
  const sliderIntro({Key? key, required this.scale, required this.scale2}) : super(key: key);
  final double scale ;
  final double scale2 ;

  @override
  State<sliderIntro> createState() => _sliderIntroState();
}

class _sliderIntroState extends State<sliderIntro> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {

              setState(() {
                onLastPage = (index == 3);
              });
            },
            children: [

              // Slide 1

              Container(
                  color: Colors.red[200],
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/slide1.gif'),
                        const Text(
                          'Welcome to Bambino',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ])),

              // Slide 2

              Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  color: Colors.deepPurpleAccent[100],
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/slide2.gif'),
                        const Text(
                          'Where you can write and post your story',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ])),

              // Slide 3

              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                color: Color(0xfff3bdb4),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/slide3.gif', scale: widget.scale,),
                      const Text(
                        'Tell stories about your pictures',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      )
                    ]),
              ),

              // Slide 4

              Container(
                //padding: EdgeInsets.all(20),
                  color: const Color(0xff386163),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/slide4.gif', scale: widget.scale2,),
                        Column(children: [
                          const Text(
                            "Let's start",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              width: 170,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                        width: 2, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen() ));
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Log in",
                                            style: TextStyle(
                                                color: Color(0xff386163),
                                                fontSize: 25)),
                                        Icon(
                                          Icons.input,
                                          color: Color(0xff386163),
                                        )
                                      ]))),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              width: 170,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: Colors.cyan[800],
                                    side: const BorderSide(
                                        width: 2, color: Color(0xff00838FFF)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Sign Up",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25)),
                                        Icon(
                                          Icons.person_add,
                                          color: Colors.white,
                                        )
                                      ])))
                        ])
                      ]))
            ],
          ),
          Container(
              alignment: const Alignment(0, 0.9),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _controller.jumpToPage(3);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SmoothPageIndicator(
                      count: 4,
                      controller: _controller,
                      effect: const SlideEffect(
                          activeDotColor: Colors.blueGrey,
                          dotColor: Colors.white
                      ),
                    ),
                    onLastPage
                        ? GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                      },
                      child: const Text(
                        'done',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                        : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                            duration: const Duration(microseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ]))
        ],
      ),
    );
  }
}