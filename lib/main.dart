import 'package:branch/feature/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FlutterBranchSdk.validateSDKIntegration(); //uncomment to validate
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.grey,

          // or from RGB
        ),
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        appBarTheme: AppBarTheme(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.red,
                displayColor: const Color(0xff22215B),
              ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: const Color(0xff22215B),
            ),
      ),
      home: const BranchHome(), //Redirecting user to the Branch Home Page
    );
  }
}
