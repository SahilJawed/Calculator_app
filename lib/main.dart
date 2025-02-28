import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';
  String _operator = '';
  double? _firstOperand;
  double? _secondOperand;
  bool _decimalAdded = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '';
        _operator = '';
        _firstOperand = null;
        _secondOperand = null;
        _decimalAdded = false;
      } else if (value == '.') {
        if (!_decimalAdded && (!_display.contains('.') || _operator.isNotEmpty)) {
          _display += value;
          _decimalAdded = true;
        }
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        if (_display.isNotEmpty) {
          _firstOperand = double.tryParse(_display);
          _operator = value;
          _display = '';
          _decimalAdded = false;
        }
      } else if (value == '=') {
        if (_firstOperand != null && _operator.isNotEmpty && _display.isNotEmpty) {
          _secondOperand = double.tryParse(_display);
          if (_secondOperand != null) {
            switch (_operator) {
              case '+':
                _display = (_firstOperand! + _secondOperand!).toString();
                break;
              case '-':
                _display = (_firstOperand! - _secondOperand!).toString();
                break;
              case '*':
                _display = (_firstOperand! * _secondOperand!).toString();
                break;
              case '/':
                _display = _secondOperand == 0 ? 'Error' : (_firstOperand! / _secondOperand!).toString();
                break;
            }
            _firstOperand = null;
            _operator = '';
            _secondOperand = null;
            _decimalAdded = _display.contains('.');
          }
        }
      } else {
        _display += value;
      }
    });
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        child: Text(text, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Text(
                _display,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              ['7', '8', '9', '/'],
              ['4', '5', '6', '*'],
              ['1', '2', '3', '-'],
              ['C', '0', '.', '='],
              ['+']
            ].map((row) {
              return Row(
                children: row.map((text) => _buildButton(text)).toList(),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}