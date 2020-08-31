import 'dart:async';
import 'dart:typed_data';

import 'dart:ui';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:save_in_gallery/save_in_gallery.dart';

import 'package:flutter/material.dart';
const String testDevice = 'Mobile_ID';

class Fullscreen extends StatefulWidget {
  final Uint8List image;

  const Fullscreen({Key key, this.image}) : super(key: key);
  @override
  _FullscreenState createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {








   static const MobileAdTargetingInfo  targetingInfo= MobileAdTargetingInfo(
      testDevices: testDevice!=null ? <String>[testDevice]: null,
      nonPersonalizedAds: true,
      keywords: ['Games' , 'Pubg' , 'snapchat' , 'unity']
  );







   InterstitialAd myInterstitial = InterstitialAd(

    adUnitId: "ca-app-pub-3937702122719326/6723205383",
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );




  @override
  void dispose(){
    myInterstitial.dispose();
    super.dispose();
  }
















  final _imageSaver = ImageSaver();
  bool _isLoading = false;
  bool _showResult = false;
  String _resultText = "";
  Color _resultColor = Colors.red;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(padding: EdgeInsets.only(bottom: 50.0),
      child: FloatingActionButton(

        splashColor: Colors.grey,
        backgroundColor: Colors.white,
        onPressed: () {
          Fluttertoast.showToast(
              msg: "Saving in Gallery",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          saveNetworkImage();
          myInterstitial
            ..load()
            ..show(
              anchorType: AnchorType.bottom,
              anchorOffset: 0.0,
              horizontalCenterOffset: 0.0,
            );
        },
        child: Icon(
          Icons.save_alt,
          color: Colors.black,
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color(000080),
      appBar: AppBar(
        title: Text("Download",style: TextStyle(
            fontFamily: "Roboto")),
          flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.black, Color(000099)])),
        ),
      ),
      body: Container(
        child: Center(child: Image.memory(widget.image)),
      ),
    );
  }

  void _displaySuccessMessage() {
    setState(() {
      _resultText = "Images saved successfullty";
      _resultColor = Colors.green;
    });
  }

  void _displayErrorMessage() {
    setState(() {
      _resultText = "An error occurred while saving images";
      _resultColor = Colors.red;
    });
  }

  void _hideResult() {
    setState(() {
      _showResult = false;
    });
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void _displayResult(bool success) {
    _showResult = true;
    if (success) {
      _displaySuccessMessage();
    } else {
      _displayErrorMessage();
    }
    Timer(Duration(seconds: 2), () {
      _hideResult();
    });
  }

  Future<void> saveNetworkImage() async {
    _startLoading();
    // final url = widget.image;
    // final image = NetworkImage(
    //     "https://i.pinimg.com/originals/1f/b9/a3/1fb9a31d23b9c6ccfb2e8c65e73f2cc4.jpg");
    // final key = await image.obtainKey(ImageConfiguration());
    // final load = image.load(
    //     key, (bytes, {allowUpscaling, cacheHeight, cacheWidth}) => null);
    // load.addListener(
    //   ImageStreamListener((listener, err) async {
    //     final byteData =
    //         await listener.image.toByteData(format: ImageByteFormat.png);
    //     final bytes = byteData.buffer.asUint8List();
    //     final res = await _imageSaver.saveImage(
    //       imageBytes: widget.image,
    //       directoryName: "Pictures",
    //     );
    //     _stopLoading();
    //     _displayResult(res);
    //     print(res);
    //   }),
    // );

    final res = await _imageSaver.saveImage(imageBytes: widget.image);
    _stopLoading();
    _displayResult(res);
    print(res);
  }
}
