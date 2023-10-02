import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newsapp/models/news_models.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:newsapp/models/news_models.dart';

class DetailsScreen extends StatefulWidget {
  final NewsData? data;
  final String? url;
  const DetailsScreen({super.key, this.url, this.data});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late String finalUrl;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  @override
  void initState() {
    if (widget.url.toString().contains("http://")) {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
    } else {
      finalUrl = widget.url ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("NewsApp"),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.orange.shade900),
        ),
        body: WebView(
          initialUrl: widget.data!.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              controller.complete(webViewController);
            });
          },
        )

        // Column(
        //   children: [
        //     Container(

        //       width: MediaQuery.of(context).size.width,
        //       height: 200,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(12),
        //         image: DecorationImage(image: NetworkImage(widget.data!.urlToImage ??"")),
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 20,
        //     ),
        //     Text(widget.data!.title ??"",style: TextStyle(fontWeight: FontWeight.bold),),
        //     const SizedBox(
        //       height: 20,
        //     ),
        //     Text(widget.data!.content ??"",style: TextStyle(fontWeight: FontWeight.bold),),

        //run it
        // ],

        );
  }
}
