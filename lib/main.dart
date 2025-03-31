import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CW5',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CW5 Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Fish> fishList = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    fishList = List.generate(5, (_) => Fish.random()); 

    _controller.addListener(() {
      setState(() {
        for (var fish in fishList) {
          fish.move();
        }
      });
    });
  }

  void _addFish() {
    if (fishList.length < 10) { 
      setState(() {
        fishList.add(Fish.random());
      });
    }
  }

  void _removeFish() {
    if (fishList.isNotEmpty) {
      setState(() {
        fishList.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your Aquarium',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            CustomPaint(
              size: const Size(300, 300),
              painter: AquariumPainter(fishList),
              child: Container(
                width: 300,
                height: 300,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addFish,
                  child: const Text('Add Fish'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _removeFish,
                  child: const Text('Remove Fish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AquariumPainter extends CustomPainter {
  final List<Fish> fishes;

  AquariumPainter(this.fishes);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.blue;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final fishPaint = Paint()..color = Colors.orange;
    for (var fish in fishes) {
      canvas.drawCircle(Offset(fish.x, fish.y), 5, fishPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Fish {
  double x;
  double y;
  double dx;
  double dy;

  Fish(this.x, this.y, this.dx, this.dy);

  Fish.random()
      : x = Random().nextDouble() * 300,
        y = Random().nextDouble() * 300,
        dx = (Random().nextDouble() * 2 - 1) * 2,
        dy = (Random().nextDouble() * 2 - 1) * 2;

  void move() {
    x += dx;
    y += dy;

    if (x <= 0 || x >= 300) dx = -dx;
    if (y <= 0 || y >= 300) dy = -dy;
  }
}