import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const CalculatorScreen({required this.onThemeToggle, super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';      // what the user sees
  String _current = '0';    // number being typed
  String _operand = '';     // +, -, ×, ÷
  double _num1 = 0;
  bool _shouldClear = false;
  String _expression = '';  // <-- NEW: full expression shown

  // ---------- UI ----------
  Widget _button(String text, {Color? color, VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(20),
          ),
          onPressed: onTap,
          child: Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  // ---------- Logic ----------
  void _onDigit(String digit) {
    setState(() {
      if (_shouldClear) {
        _current = digit;
        _shouldClear = false;
      } else {
        _current = _current == '0' ? digit : _current + digit;
      }
      _updateExpression();
    });
  }

  void _onDecimal() {
    setState(() {
      if (!_current.contains('.')) _current += '.';
      _updateExpression();
    });
  }

  void _onOperator(String op) {
    setState(() {
      _num1 = double.tryParse(_current) ?? 0;
      _operand = op;
      _shouldClear = true;
      _updateExpression();   // <-- show operator immediately
    });
  }

  void _updateExpression() {
    // Build the expression that the user sees
    final left = _num1 == 0 && _current == '0' ? '' : _num1.toString();
    final op = _operand.isEmpty ? '' : ' $_operand ';
    final right = _shouldClear ? '' : _current;
    _expression = '$left$op$right'.trim();
    _output = _expression.isEmpty ? '0' : _expression;
  }

  void _onEqual() {
    setState(() {
      final num2 = double.tryParse(_current) ?? 0;
      double result = 0;

      switch (_operand) {
        case '+': result = _num1 + num2; break;
        case '-': result = _num1 - num2; break;
        case '×': result = _num1 * num2; break;
        case '÷': result = num2 != 0 ? _num1 / num2 : 0; break;
      }

      // Show full expression + result
      _output = '$_expression = $result';
      _current = result.toString();
      if (_current.endsWith('.0')) {
        _current = _current.substring(0, _current.length - 2);
      }
      _shouldClear = true;
      _operand = '';
      _num1 = result;   // allow chain calculations
    });
  }

  void _onClear() {
    setState(() {
      _output = '0';
      _current = '0';
      _operand = '';
      _num1 = 0;
      _shouldClear = false;
      _expression = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Column(
        children: [
          // ---- DISPLAY ----
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.centerRight,
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Divider(height: 1),

          // ---- BUTTONS (unchanged) ----
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(children: [
                    _button('AC', color: Colors.redAccent, onTap: _onClear),
                    _button('±', onTap: () {}),
                    _button('%', onTap: () {}),
                    _button('÷', color: Colors.orange, onTap: () => _onOperator('÷')),
                  ]),
                  Row(children: [
                    _button('7', onTap: () => _onDigit('7')),
                    _button('8', onTap: () => _onDigit('8')),
                    _button('9', onTap: () => _onDigit('9')),
                    _button('×', color: Colors.orange, onTap: () => _onOperator('×')),
                  ]),
                  Row(children: [
                    _button('4', onTap: () => _onDigit('4')),
                    _button('5', onTap: () => _onDigit('5')),
                    _button('6', onTap: () => _onDigit('6')),
                    _button('-', color: Colors.orange, onTap: () => _onOperator('-')),
                  ]),
                  Row(children: [
                    _button('1', onTap: () => _onDigit('1')),
                    _button('2', onTap: () => _onDigit('2')),
                    _button('3', onTap: () => _onDigit('3')),
                    _button('+', color: Colors.orange, onTap: () => _onOperator('+')),
                  ]),
                  Row(children: [
                    _button('0', onTap: () => _onDigit('0')),
                    _button('.', onTap: _onDecimal),
                    _button('=', color: Colors.green, onTap: _onEqual),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}