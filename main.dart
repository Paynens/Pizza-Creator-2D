
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const PizzaCreatorApp());
}

class PizzaCreatorApp extends StatelessWidget {
  const PizzaCreatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza Creator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7043),
        ),
        fontFamily: 'Roboto',
      ),
      home: const PizzaKitchen(),
    );
  }
}

class PizzaKitchen extends StatefulWidget {
  const PizzaKitchen({super.key});

  @override
  State<PizzaKitchen> createState() => _PizzaKitchenState();
}

class _PizzaKitchenState extends State<PizzaKitchen> {
  final Map<String, bool> selected = {
    'Tomato Sauce': true,
    'Mozzarella': true,
    'Pepperoni': true,
    'Olives': false,
    'Green Peppers': false,
    'Mushrooms': false,
    'Onions': false,
    'Corn': false,
  };

  final Map<String, IconData> icons = {
    'Tomato Sauce': Icons.water_drop,
    'Mozzarella': Icons.circle,
    'Pepperoni': Icons.lunch_dining,
    'Olives': Icons.circle_outlined,
    'Green Peppers': Icons.eco,
    'Mushrooms': Icons.spa,
    'Onions': Icons.grain,
    'Corn': Icons.grass,
  };

  int get score =>
      40 + selected.values.where((value) => value).length * 7 > 100
          ? 100
          : 40 + selected.values.where((value) => value).length * 7;

  void toggle(String name) {
    setState(() {
      selected[name] = !(selected[name] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = selected.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7043),
        foregroundColor: Colors.white,
        title: const Text(
          'Pizza Creator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const Icon(Icons.local_pizza),
        actions: [
          IconButton(
            tooltip: 'Reset pizza',
            onPressed: () {
              setState(() {
                for (final key in selected.keys.toList()) {
                  selected[key] = key == 'Tomato Sauce' ||
                      key == 'Mozzarella';
                }
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'Create your dream pizza!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF49352A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose your ingredients and make it yours.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: PizzaPainter(
                    selected: Map<String, bool>.from(selected),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Your ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${selected.values.where((v) => v).length} selected',
                  style: const TextStyle(
                    color: Color(0xFFE85D36),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: ingredients.map((name) {
                final active = selected[name] ?? false;
                return FilterChip(
                  avatar: Icon(
                    icons[name] ?? Icons.circle,
                    size: 19,
                    color: active
                        ? Colors.white
                        : const Color(0xFFE85D36),
                  ),
                  label: Text(name),
                  selected: active,
                  showCheckmark: false,
                  selectedColor: const Color(0xFFFF7043),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: active ? Colors.white : Colors.brown.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color: active
                        ? const Color(0xFFFF7043)
                        : Colors.brown.shade100,
                  ),
                  onSelected: (_) => toggle(name),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    size: 42,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pizza rating',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$score / 100 points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF388E3C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                final count =
                    selected.values.where((value) => value).length;
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pizza ready! 🍕'),
                    content: Text(
                      'Great job, chef!\n'
                      'You selected $count ingredients.\n'
                      'Your pizza score is $score/100.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to kitchen'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.local_pizza),
              label: const Text(
                'Finish my pizza!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'PIZZA CREATOR 2D • VERSION 1.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.black38,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PizzaPainter extends CustomPainter {
  final Map<String, bool> selected;

  PizzaPainter({required this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.45;

    void circle(Offset c, double r, Color color) {
      canvas.drawCircle(c, r, Paint()..color = color);
    }

    circle(
      center.translate(0, 7),
      radius + 5,
      const Color(0xFFDD9C54),
    );
    circle(center, radius, const Color(0xFFE8B66C));
    circle(center, radius * 0.91, const Color(0xFFFFD990));

    if (selected['Tomato Sauce'] == true) {
      circle(center, radius * 0.84, const Color(0xFFD94B36));
      circle(center, radius * 0.80, const Color(0xFFE75C42));
    }

    if (selected['Mozzarella'] == true) {
      final cheese = Paint()
        ..color = const Color(0xFFFFE9A9)
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < 18; i++) {
        final angle = i * math.pi / 9;
        final r = radius * 0.67;
        final start = Offset(
          center.dx + math.cos(angle) * r,
          center.dy + math.sin(angle) * r,
        );
        final end = Offset(
          center.dx + math.cos(angle + 0.24) * r,
          center.dy + math.sin(angle + 0.24) * r,
        );
        canvas.drawLine(start, end, cheese);
      }
    }

    const toppings = [
      'Pepperoni',
      'Olives',
      'Green Peppers',
      'Mushrooms',
      'Onions',
      'Corn',
    ];

    final random = math.Random(17);

    for (final topping in toppings) {
      if (selected[topping] != true) continue;

      for (int i = 0; i < 12; i++) {
        final angle = random.nextDouble() * math.pi * 2;
        final distance = radius *
            (0.18 + random.nextDouble() * 0.57);
        final point = Offset(
          center.dx + math.cos(angle) * distance,
          center.dy + math.sin(angle) * distance,
        );

        switch (topping) {
          case 'Pepperoni':
            circle(point, radius * 0.075, const Color(0xFFAC3026));
            circle(
              point.translate(-2, -2),
              radius * 0.025,
              const Color(0xFFE97955),
            );
            break;
          case 'Olives':
            final olive = Paint()
              ..color = const Color(0xFF29251E)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4;
            canvas.drawCircle(point, radius * 0.045, olive);
            break;
          case 'Green Peppers':
            final pepper = Paint()
              ..color = const Color(0xFF399447)
              ..strokeWidth = 5
              ..strokeCap = StrokeCap.round;
            canvas.drawLine(
              point.translate(-5, -4),
              point.translate(5, 4),
              pepper,
            );
            break;
          case 'Mushrooms':
            circle(point, radius * 0.06, const Color(0xFFD9C1A0));
            circle(
              point.translate(0, -2),
              radius * 0.035,
              const Color(0xFFF4E5CD),
            );
            break;
          case 'Onions':
            final onion = Paint()
              ..color = const Color(0xFFFFF2D8)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3;
            canvas.drawCircle(point, radius * 0.05, onion);
            break;
          case 'Corn':
            circle(point, radius * 0.035, const Color(0xFFFFD32A));
            break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant PizzaPainter oldDelegate) {
    return true;
  }
}
