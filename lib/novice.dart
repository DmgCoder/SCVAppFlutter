import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'data.dart';

class NovicePage extends StatefulWidget{
  NovicePage({Key key, this.title,this.data}) : super(key: key);

  final String title;

  final Data data;

  _NovicePageState createState() => _NovicePageState();
}

class _NovicePageState extends State<NovicePage>{

  WebViewController _myController;
      final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context){
      return Scaffold(body:WebView(initialUrl: widget.data.izbranaSola.noviceUrl,onWebViewCreated: (controler)=>{
        _myController = controler
      },javascriptMode: JavascriptMode.unrestricted,),floatingActionButton: FloatingActionButton(onPressed: changeUrl,child: Icon(Icons.home),backgroundColor: widget.data.izbranaSola.color,));
  }

  void changeUrl(){
    _myController.loadUrl(widget.data.izbranaSola.noviceUrl);
  }

  
}

// WebView(initialUrl: widget.data.izbranaSola.noviceUrl,);