import 'package:flutter/material.dart';

class KeyboardLayout extends StatelessWidget {
  final List<String> _keysRow1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  final List<String> _keysRow2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  final List<String> _keysRow3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  KeyboardLayout({super.key});

  Widget _buildKey(String key, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple[800]!.withOpacity(0.15),
                Colors.purple[500]!.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.purple[300]!.withOpacity(0.2),
              width: 0.4,
            ),
          ),
          child: Center(
            child: Text(
              key,
              style: TextStyle(
                color: Colors.purple[100],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> keys, {double horizontalPadding = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: keys.map((k) => _buildKey(k)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenPaddingBottom = mediaQuery.viewPadding.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: screenPaddingBottom + 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow(_keysRow1, horizontalPadding: 2),
            const SizedBox(height: 6),
            _buildRow(_keysRow2, horizontalPadding: 22),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  _buildKey('⇧'),
                  ..._keysRow3.map((k) => _buildKey(k)).toList(),
                  _buildKey('⌫'),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                children: [
                  _buildKey('123'),
                  _buildKey('🌐'),
                  Expanded(
                    flex: 5,
                    child: _buildKey('Space'),
                  ),
                  _buildKey('.'),
                  _buildKey('⏎'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
