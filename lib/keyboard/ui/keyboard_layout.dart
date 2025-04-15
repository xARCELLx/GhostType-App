import 'package:flutter/material.dart';

class KeyboardLayout extends StatelessWidget {
  final List<String> _keysRow1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  final List<String> _keysRow2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  final List<String> _keysRow3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  KeyboardLayout({super.key});

  Widget _buildKey(String key) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 60, // Slightly taller for modern feel
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[900]!, Colors.blue[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12), // Softer curves
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              key,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent,
                    offset: Offset(0, 0),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      children: keys.map(_buildKey).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildRow(_keysRow1),
        const SizedBox(height: 8), // Increased spacing
        _buildRow(_keysRow2),
        const SizedBox(height: 8),
        _buildRow(_keysRow3),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildKey('123'),
            _buildKey(','),
            Expanded(
              flex: 4,
              child: _buildKey('Space'),
            ),
            _buildKey('.'),
            _buildKey('⏎'),
          ],
        )
      ],
    );
  }
}