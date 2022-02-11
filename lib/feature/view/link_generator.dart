import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkGenerator extends StatefulWidget {
  const LinkGenerator(
      this.title, this.desc, this.price, this.imageUrl, this.isShare);

  final String title;
  final String desc;
  final String price;
  final String imageUrl;
  final bool isShare;

  @override
  _LinkGeneratorState createState() => _LinkGeneratorState();
}

class _LinkGeneratorState extends State<LinkGenerator> {
  StreamController<String> controllerUrl = StreamController<String>();

  String titleController = '';
  String descriptionController = '';
  String priceController = '';
  String imageUrlController = '';
  String url = '';
  bool isLoading = false;
  bool showShareLink = false;
  TextEditingController ctr = TextEditingController();

  @override
  void initState() {
    if (widget.isShare) {
      titleController = widget.title;
      descriptionController = widget.desc;
      priceController = widget.price;
      imageUrlController = widget.imageUrl;
      generateLink();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controllerUrl.close();
  }

  void generateLink() async {
    setState(() {
      isLoading = true;
    });
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        //canonicalUrl: '',
        title: 'Flutter Branch Plugin',
        imageUrl:
            'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
        contentDescription: 'Flutter Branch Description',
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('title', titleController)
          ..addCustomMetadata('price', priceController)
          ..addCustomMetadata('description', descriptionController)
          ..addCustomMetadata('imageUrl', imageUrlController),
        //  ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
        //  ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
        keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        expirationDateInMilliSec:
            DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch);
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        //alias: 'flutterplugin' //define link url,
        stage: 'new share',
        campaign: 'xxxxx',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('\$uri_redirect_mode', '1');

    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      print('********');
      print(response);
      showUrl(response.result);
      controllerUrl.sink.add('${response.result}');
    } else {
      controllerUrl.sink
          .add('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }

  showUrl(String result) {
    print('this is result *************');
    setState(() {
      isLoading = false;
      url = result;
      showShareLink = true;
    });
    if (widget.isShare) {
      Share.share(url, subject: 'Look what I made!');
    }
  }

  bool validate() {
    return titleController.isNotEmpty &&
        descriptionController.isNotEmpty &&
        priceController.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Generate Link'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: !showShareLink
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Enter Product details',
                              style: TextStyle(fontSize: 18),
                            ),
                            TextField(
                              onChanged: (val) {
                                setState(() {
                                  titleController = val;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Title'),
                            ),
                            TextField(
                              onChanged: (val) {
                                setState(() {
                                  descriptionController = val;
                                });
                              },
                              decoration:
                                  InputDecoration(labelText: 'Description'),
                            ),
                            TextField(
                              onChanged: (val) {
                                setState(() {
                                  priceController = val;
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Price'),
                            ),
                            TextField(
                              controller: ctr,
                              keyboardType: TextInputType.url,
                              onChanged: (val) {
                                setState(() {
                                  imageUrlController = val;
                                });
                              },
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          ctr.text =
                                              "https://2xawx0gmudy471po527lbxcd-wpengine.netdna-ssl.com/wp-content/uploads/2015/03/deeplink-me.jpg";
                                          imageUrlController =
                                              "https://2xawx0gmudy471po527lbxcd-wpengine.netdna-ssl.com/wp-content/uploads/2015/03/deeplink-me.jpg";
                                        });
                                      },
                                      icon: Icon(Icons.copy)),
                                  labelText: 'Image Url (optional)'),
                            ),
                            ElevatedButton(
                                onPressed: validate()
                                    ? () {
                                        generateLink();
                                      }
                                    : null,
                                child: Text('Generate link'))
                          ],
                        ),
                ),
              )
            : SingleChildScrollView(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                'assets/share.png',
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: size.height / 4,
                              ),
                              ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      Share.share(
                                        url,
                                      );
                                    },
                                    icon: Icon(Icons.share)),
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Generate Url (Deep link) ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: url,
                                        style:
                                            const TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            if (await canLaunch(url)) {
                                              launch(url);
                                              print('launched ************');
                                            } else {
                                              print('can launch url');
                                              setState(() {
                                                showShareLink = false;
                                              });
                                            }
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height / 3,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    //launch(url);
                                    setState(() {
                                      showShareLink = false;
                                      ctr.clear();
                                    });
                                  },
                                  child: Text('Generate another link'))
                            ]))),
              ));
  }
}
