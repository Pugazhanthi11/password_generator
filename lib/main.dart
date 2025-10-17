import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const PasswordGeneratorApp());
}

class PasswordGeneratorApp extends StatelessWidget {
  const PasswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const PasswordGeneratorPage(),
    );
  }
}

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  String _password = '';
  int _length = 16;
  bool _useLower = true;
  bool _useUpper = true;
  bool _useNumbers = true;
  bool _useSymbols = true;

  final String _lower = 'abcdefghijklmnopqrstuvwxyz';
  final String _upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final String _numbers = '0123456789';
  final String _symbols = r'!@#\$%^&*()-_=+[]{};:,.<>?/~`';
  final Random _rnd = Random();

  void _generate() {
    final pools = <String>[];
    if (_useLower) pools.add(_lower);
    if (_useUpper) pools.add(_upper);
    if (_useNumbers) pools.add(_numbers);
    if (_useSymbols) pools.add(_symbols);

    if (pools.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Select at least one character type.'),
      ));
      return;
    }

    List<String> chars = [];
    for (var pool in pools) {
      chars.add(pool[_rnd.nextInt(pool.length)]);
    }

    final all = pools.join();
    for (int i = chars.length; i < _length; i++) {
      chars.add(all[_rnd.nextInt(all.length)]);
    }

    chars.shuffle(_rnd);

    setState(() {
      _password = chars.join();
    });
  }

  void _copy() {
    if (_password.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final str = _strength();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/main.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: AssetImage('assets/bg_card.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.25,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white54),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.network(
                        'https://assets8.lottiefiles.com/packages/lf20_kyu7xb1v.json',
                        height: 120,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Password Generator',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password display
                      Card(
                        color: Colors.white.withOpacity(0.15),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: SelectableText(
                                  _password.isEmpty
                                      ? 'Tap Generate'
                                      : _password,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _copy,
                                icon: const Icon(Icons.copy, color: Colors.white),
                                tooltip: 'Copy',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Length: $_length',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Slider(
                        value: _length.toDouble(),
                        min: 6,
                        max: 64,
                        divisions: 58,
                        label: '$_length',
                        onChanged: (v) => setState(() => _length = v.round()),
                        activeColor: Colors.amber,
                      ),
                      _buildSwitch('Lowercase (a-z)', _useLower,
                          (v) => setState(() => _useLower = v)),
                      _buildSwitch('Uppercase (A-Z)', _useUpper,
                          (v) => setState(() => _useUpper = v)),
                      _buildSwitch('Numbers (0-9)', _useNumbers,
                          (v) => setState(() => _useNumbers = v)),
                      _buildSwitch('Symbols (!@#...)', _useSymbols,
                          (v) => setState(() => _useSymbols = v)),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _generate,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Generate'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _length = 16;
                                _useLower = true;
                                _useUpper = true;
                                _useNumbers = true;
                                _useSymbols = true;
                                _password = '';
                              });
                            },
                            icon: const Icon(Icons.restore, color: Colors.white),
                            label: const Text('Reset',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Text(
                        'Strength: ${str['label']}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: str['pct'],
                        color: str['color'],
                        backgroundColor: Colors.white24,
                      ),

                      const SizedBox(height: 24),
                      Lottie.network(
                        'https://assets1.lottiefiles.com/packages/lf20_u4yrau.json',
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      activeColor: Colors.amber,
    );
  }

  Map<String, dynamic> _strength() {
    int score = 0;
    if (_useLower) score++;
    if (_useUpper) score++;
    if (_useNumbers) score++;
    if (_useSymbols) score++;
    if (_length >= 12) score++;
    if (_length >= 16) score++;

    String label;
    double pct;
    Color color;

    if (score <= 2) {
      label = 'Weak';
      pct = 0.25;
      color = Colors.redAccent;
    } else if (score == 3) {
      label = 'Fair';
      pct = 0.5;
      color = Colors.orange;
    } else if (score == 4) {
      label = 'Good';
      pct = 0.75;
      color = Colors.lightGreen;
    } else {
      label = 'Strong';
      pct = 1.0;
      color = Colors.green;
    }

    return {'label': label, 'pct': pct, 'color': color};
  }
}
