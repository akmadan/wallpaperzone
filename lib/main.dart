import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperzone/data_holder.dart';
import 'fullscreen.dart';
const String testDevice = 'Mobile_ID';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {














  static const MobileAdTargetingInfo  targetingInfo= MobileAdTargetingInfo(
      testDevices: testDevice!=null ? <String>[testDevice]: null,
      nonPersonalizedAds: true,
      keywords: ['Games' , 'Pubg' , 'snapchat' , 'unity']
  );




  BannerAd _bannerAd;
  BannerAd createBannerAd(){
    return BannerAd(
        adUnitId: "ca-app-pub-3937702122719326/7872635529",
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("BannerAd $event");
        }
    );
  }



   @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-3937702122719326~5438043873');
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }







  @override
  void dispose(){
    _bannerAd.dispose();
    super.dispose();
  }






  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("Something Went wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(brightness: Brightness.dark),
            home: MyHomePage(),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text("4K Black Wallpapers" , style: TextStyle(
            fontFamily: "Roboto"
          ),),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.black, Color(000099)])),
          ),
        ),
        body: Padding(padding: EdgeInsets.only(bottom: 50.0),
        child: Container(
            child: makeGrid())));
  }

  Widget makeGrid() {
    return GridView.builder(
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5 / 4,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0),
        itemBuilder: (context, index) {
          return ImageGridItem(index);
        });
  }
}

class ImageGridItem extends StatefulWidget {
  int _index;
  ImageGridItem(int index) {
    this._index = index;
  }
  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  Uint8List imageFile;
  String url;
  StorageReference photoref = FirebaseStorage.instance.ref().child('black');

  int max_size = 10 * 1024 * 1024;
  getImage() {
    if (!requestIndex.contains(widget._index)) {
      photoref.child("1(${widget._index}).jpg").getData(max_size).then((data) {
        this.setState(() {
          imageFile = data;
        });
        imageData.putIfAbsent(widget._index, () {
          return data;
        });
      });
      requestIndex.add(widget._index);
    }
  }

  getImageUrl() {
    photoref.child("1(${widget._index}).jpg").getDownloadURL().then((data) {
      this.setState(() {
        url = data;
      });
    });
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(child: decideGridTile());
  }

  Widget decideGridTile() {
    if (imageFile == null) {
      return Center(
        child: Image.asset(
          'assets/default.jpg',
          fit: BoxFit.cover,
        ),
      );
    } else {
      return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Fullscreen(
                          image: imageFile,
                        )));
          },
          child: Image.memory(imageFile, fit: BoxFit.cover));
    }
  }

  @override
  void initState() {
    super.initState();
    if (!imageData.containsKey(widget._index)) {
      getImage();
      getImageUrl();
    } else {
      this.setState(() {
        imageFile = imageData[widget._index];
      });
    }
  }
}
