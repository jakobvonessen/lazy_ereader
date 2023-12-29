import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Viewer',
      home: TextViewer(),
    );
  }
}

class TextViewer extends StatefulWidget {
  @override
  _TextViewerState createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  String fileContent = '';
  List<String> fileChunks = [];
  int chunkIndex = 0;
  final int chunkSize = 1000; // Define your chunk size (e.g., 1000 characters)
  double fontSize = 14;
  double maxFontSize = 300;
  double minFontSize = 10;

  void loadTextFile() async {
    String content = await rootBundle.loadString('assets/file.txt');
    int startIndex = 0;
    while (startIndex < content.length) {
      int endIndex = startIndex + chunkSize;
      if (endIndex > content.length) endIndex = content.length;
      fileChunks.add(content.substring(startIndex, endIndex));
      startIndex += chunkSize;
    }
    setState(() {
      fileContent = fileChunks[chunkIndex];
    });
  }

  void changePage(int delta) {
    int newIndex = chunkIndex + delta;
    if (newIndex > 0 && newIndex < fileChunks.length) {
      setState(() {
        chunkIndex += delta;
        fileContent = fileChunks[chunkIndex];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTextFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          print("onNotification");
          if (notification is ScrollUpdateNotification) {
            print("Notification is ScrollUpdateNotification");
            double scrollDelta = notification.scrollDelta ?? 0;
            double tempFontSize = fontSize;
            double incrementDelta = scrollDelta > 0 ? 1 : -1;
            tempFontSize += incrementDelta;

            tempFontSize = tempFontSize.roundToDouble();
            if (tempFontSize < minFontSize) tempFontSize = minFontSize;
            if (tempFontSize > maxFontSize) tempFontSize = maxFontSize;
            print("New font size: " + fontSize.toString());
            setState(() {
              fontSize = tempFontSize;
            });
          }
          return true;
        },
        child: GestureDetector(
          onSecondaryTap: () => changePage(1), // Right mouse button for next page
          onTap: () => changePage(-1), // Left mouse button for previous page
          onLongPress: () => changePage(20),
          child: SingleChildScrollView(
            child: Text(
              fileContent,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
