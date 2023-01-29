import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:news_app_flutter_course/services/global_methods.dart';
import 'package:news_app_flutter_course/utils/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailWebView extends StatefulWidget {
  const NewsDetailWebView({super.key, required this.url});
  final String url;
  @override
  State<NewsDetailWebView> createState() => _NewsDetailWebViewState();
}

class _NewsDetailWebViewState extends State<NewsDetailWebView> {
  late WebViewController _webViewController;
  double _progress = 0;
  // final url =
  //     "https://techcrunch.com/2022/06/17/marc-lores-food-delivery-startup-wonder-raises-350m-3-5b-valuation/";
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          //stay inside
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(onPressed: onPressed, icon: icon),
          iconTheme: IconThemeData(color: color),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.url,
            style: TextStyle(
              color: color,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                showModalSheet();
              },
              icon: const Icon(
                Icons.more_horiz,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: _progress,
              color: _progress == 1 ? Colors.transparent : Colors.blue,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            Expanded(
              child: WebView(
                initialUrl: widget.url,
                zoomEnabled: true,
                onProgress: (progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showModalSheet() async {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              //To get rid of excess space
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(20),
                Center(
                  child: Container(
                    height: 5,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const Gap(20),
                const Text(
                  'More options',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Gap(20),
                const Divider(
                  thickness: 2,
                ),
                const Gap(20),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () async {
                    try {
                      await Share.share(widget.url,
                          subject: 'Look what i made!');
                    } catch (e) {
                      GlobalMethods.errorDialog(
                        errorMessage: 'An error occured here',
                        context: context,
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.open_in_browser),
                  title: const Text('Open in browser'),
                  onTap: () async {
                    if (!await launchUrl(Uri.parse(widget.url))) {
                      throw 'Could not launch ${widget.url}';
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh'),
                  onTap: () async {
                    try {
                      await _webViewController.reload();
                    } catch (err) {
                      log('error occured $err');
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
