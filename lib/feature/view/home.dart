import 'dart:async';

import 'package:branch/feature/view/car_details_page.dart';
import 'package:branch/feature/view/link_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class BranchHome extends StatefulWidget {
  const BranchHome({Key? key}) : super(key: key);

  @override
  _BranchHomeState createState() => _BranchHomeState();
}

class _BranchHomeState extends State<BranchHome> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  BranchContentMetaData metadata = BranchContentMetaData();
  BranchUniversalObject? buo;
  BranchLinkProperties lp = BranchLinkProperties();
  BranchEvent? eventStandart;
  BranchEvent? eventCustom;

  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();

  @override
  void initState() {
    FlutterBranchSdk.initWeb(
        branchKey: 'key_live_hd0VcLnQuvS6jzsuQS2I4lmlwCpGV7vF');
    listenDynamicLinks();
    initDeepLinkData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controllerData.close();
    controllerInitSession.close();
    streamSubscription?.cancel();
  }

  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      print('listenDynamicLinks - DeepLink Data: $data');
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        print(
            '------------------------------------Link clicked----------------------------------------------');
        print(data);
        print('Custom string: ${data['title']}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetails(
                    data['title'],
                    data['description'],
                    data['price'],
                    data['imageUrl'] ?? '')));
        print(
            '------------------------------------------------------------------------------------------------');
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSession.add(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  void initDeepLinkData() {
    metadata = BranchContentMetaData()
        .addCustomMetadata('custom_string', 'abc')
        .addCustomMetadata('custom_number', 12345)
        .addCustomMetadata('custom_bool', true)
        .addCustomMetadata('custom_list_number', [
      1,
      2,
      3,
      4,
      5
    ]).addCustomMetadata('custom_list_string', ['a', 'b', 'c']);
    //--optional Custom Metadata
    /*
    metadata.contentSchema = BranchContentSchema.COMMERCE_PRODUCT;
    metadata.price = 50.99;
    metadata.currencyType = BranchCurrencyType.BRL;
    metadata.quantity = 50;
    metadata.sku = 'sku';
    metadata.productName = 'productName';
    metadata.productBrand = 'productBrand';
    metadata.productCategory = BranchProductCategory.ELECTRONICS;
    metadata.productVariant = 'productVariant';
    metadata.condition = BranchCondition.NEW;
    metadata.rating = 100;
    metadata.ratingAverage = 50;
    metadata.ratingMax = 100;
    metadata.ratingCount = 2;
    metadata.setAddress(
        street: 'street',
        city: 'city',
        region: 'ES',
        country: 'Brazil',
        postalCode: '99999-987');
    metadata.setLocation(31.4521685, -114.7352207);
*/

    buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        //canonicalUrl: '',
        title: 'Flutter Branch Plugin',
        imageUrl:
            'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
        contentDescription: 'Flutter Branch Description',
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('custom_string', 'abc')
          ..addCustomMetadata('custom_number', 12345)
          ..addCustomMetadata('custom_bool', true)
          ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
          ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
        keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        expirationDateInMilliSec:
            DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch);

    //parameter canonicalUrl
    //If your content lives both on the web and in the app, make sure you set its canonical URL
    // (i.e. the URL of this piece of content on the web) when building any BUO.
    // By doing so, we’ll attribute clicks on the links that you generate back to their original web page,
    // even if the user goes to the app instead of your website! This will help your SEO efforts.

    FlutterBranchSdk.registerView(buo: buo!);

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        //alias: 'flutterplugin' //define link url,
        stage: 'new share',
        campaign: 'xxxxx',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('\$uri_redirect_mode', '1');

    //parameter alias
    //Instead of our standard encoded short url, you can specify the vanity alias.
    // For example, instead of a random string of characters/integers, you can set the vanity alias as *.app.link/devonaustin.
    // Aliases are enforced to be unique** and immutable per domain, and per link - they cannot be reused unless deleted.

    eventStandart = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART);
    //--optional Event data
    /*
    eventStandart!.transactionID = '12344555';
    eventStandart!.currency = BranchCurrencyType.BRL;
    eventStandart!.revenue = 1.5;
    eventStandart!.shipping = 10.2;
    eventStandart!.tax = 12.3;
    eventStandart!.coupon = 'test_coupon';
    eventStandart!.affiliation = 'test_affiliation';
    eventStandart!.eventDescription = 'Event_description';
    eventStandart!.searchQuery = 'item 123';
    eventStandart!.adType = BranchEventAdType.BANNER;
    eventStandart!.addCustomData(
        'Custom_Event_Property_Key1', 'Custom_Event_Property_val1');
    eventStandart!.addCustomData(
        'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
     */
    eventCustom = BranchEvent.customEvent('Custom_event');
    eventCustom!.addCustomData(
        'Custom_Event_Property_Key1', 'Custom_Event_Property_val1');
    eventCustom!.addCustomData(
        'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  }

  void showSnackBar(
      {required BuildContext context,
      required String message,
      int duration = 1}) {
    scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Share Product (Generate Deep Link)':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LinkGenerator('', '', '', '', false)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Branch Home Page'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Share Product (Generate Deep Link)',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.more_vert),
          //     onPressed: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => LinkGenerator()));
          //     },
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/link.png',
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                Text(
                  'You are in home page',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ));
  }
}
