import 'package:branch/feature/view/link_generator.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails(this.title, this.desc, this.price, this.imageUrl);
  final String title;
  final String desc;
  final String price;
  final String imageUrl;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product Details Page (Deep Link result)'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.imageUrl.isNotEmpty) Image.network(widget.imageUrl),
              ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(widget.title),
                    Text(
                      widget.price,
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  ],
                ),
                subtitle: Text(widget.desc),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LinkGenerator(
                                  widget.title,
                                  widget.desc,
                                  widget.price,
                                  widget.imageUrl,
                                  true)));
                    },
                    icon: Icon(Icons.share)),
              )
            ],
          ),
        ));
  }
}
