import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScrollAndView extends StatefulWidget {
  @override
  _CustomScrollAndViewState createState() => _CustomScrollAndViewState();
}

class _CustomScrollAndViewState extends State<CustomScrollAndView> {
  String fileContent = "\n\n\nYour long text content here..."; // Example text content
  final ScrollController _scrollController = ScrollController();
  double fontSize = 14;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScrollWheel(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final newOffset = _scrollController.offset + event.scrollDelta.dy;
      if (newOffset < _scrollController.position.minScrollExtent) {
        print("Scrolled up.");
        setState(() {
          fontSize += 1;
        });
      } else if (newOffset > _scrollController.position.maxScrollExtent) {
        print("Scrolled down.");
        setState(() {
          fontSize -= 1;
        });
      }
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    print(event.buttons);
    if (event.buttons == 1) { //Left
      setState(() {
        fileContent += "left";
      });
    }
    if (event.buttons == 2) { //Right
      setState(() {
        fileContent += "right";
      });
    }
    if (event.buttons == 4) { //Middle
      setState(() {
        fileContent += "middle";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerSignal: _handleScrollWheel,
        onPointerDown: _handlePointerDown,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Text(
            fileContent,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: CustomScrollAndView()));
}
