import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:wallpaperzone/data_holder.dart';

import 'fullscreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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
  List<String> category = [
    'Abstract',
    'Nature',
    'Animals',
    'Beach',
    'Cute',
    'Creative',
    'Gaming',
    'Black',
    'Food',
    'Love',
    'Military',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpaper Zone"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: makeGrid(),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Drawer(
          child: ListView.builder(
            itemCount: category.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      category[index],
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Divider()
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget makeGrid() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
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
  StorageReference photoref = FirebaseStorage.instance.ref().child('gaming');

  int max_size = 10 * 1024 * 1024;
  getImage() {
    if (!requestIndex.contains(widget._index)) {
      photoref
          .child("image_${widget._index}.jpg")
          .getData(max_size)
          .then((data) {
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
    photoref.child("image_${widget._index}.jpg").getDownloadURL().then((data) {
      this.setState(() {
        url = data;
      });
    });
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Fullscreen(
                        image: imageFile,
                      )));
        },
        child: GridTile(child: decideGridTile()));
  }

  Widget decideGridTile() {
    if (imageFile == null) {
      return Center(child: Text("Loading"));
    } else {
      return Image.memory(imageFile, fit: BoxFit.cover);
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
