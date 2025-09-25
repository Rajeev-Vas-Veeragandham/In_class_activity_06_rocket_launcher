import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 156, 109, 239),
        ),
      ),
      home: const MyHomePage(title: '🚀 Mission Control'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Color based on counter
  Color _getTextColor() {
    if (_counter == 0) return Colors.redAccent;
    if (_counter > 50) return Colors.greenAccent;
    return Colors.orangeAccent;
  }

  // Popup for liftoff
  void _showLiftoffPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          "🚀 LIFTOFF!",
          style: TextStyle(fontSize: 28, color: Colors.purpleAccent),
        ),
        content: const Text(
          "Mission successful! The rocket has launched.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Roger That!",
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _increment() {
    setState(() {
      if (_counter < 100) {
        _counter++;
        if (_counter == 100) {
          _showLiftoffPopup();
        }
      }
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Counter Display Card
            Card(
              elevation: 12,
              color: Colors.black.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Text(
                      _counter == 100 ? "🔥 LIFTOFF!" : '$_counter',
                      style: TextStyle(
                        fontSize: _counter == 100 ? 60 : 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: _counter == 100
                            ? Colors.purpleAccent.withOpacity(
                                0.7 + 0.3 * _controller.value,
                              )
                            : _getTextColor(),
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: _getTextColor(),
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.blueAccent,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.lightBlueAccent,
                  overlayColor: Colors.blue.withOpacity(0.2),
                  trackHeight: 6,
                ),
                child: Slider(
                  min: 0,
                  max: 100,
                  value: _counter.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      _counter = value.toInt();
                      if (_counter == 100) {
                        _showLiftoffPopup();
                      }
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Stylish Buttons
            Wrap(
              spacing: 15,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.withOpacity(0.2),
                    foregroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  onPressed: _increment,
                  icon: const Icon(Icons.local_fire_department),
                  label: const Text("Ignite"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    foregroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove_circle),
                  label: const Text("Decrement"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withOpacity(0.2),
                    foregroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),

      // Floating Action Button (Ignite)
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.rocket_launch),
      ),
    );
  }
}
