import 'package:flutter/material.dart';

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  // Calculator state variables
  String _display = '0';
  String _storedValue = '';
  String _operation = '';
  bool _shouldResetDisplay = false;

  String _formatNumber(String numStr) {
    if (numStr.contains('.')) {
      double num = double.parse(numStr);
      if (num == num.toInt()) {
        return num.toInt().toString();
      }
      // Limit to 4 decimal places and remove trailing zeros
      String formatted = num.toStringAsFixed(4);
      formatted = formatted.replaceAll(RegExp(r'\.?0*$'), '');
      return formatted;
    }
    return numStr;
  }

  // Button layout
  final List<List<String>> _buttons = [
    ['AC', '+/-', '%', '÷'],
    ['7', '8', '9', 'x'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '.', 'Del', '='],
  ];

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _resetCalculator();
      } else if (buttonText == '+/-') {
        _toggleSign();
      } else if (buttonText == '%') {
        _calculatePercentage();
      } else if (['÷', 'x', '-', '+'].contains(buttonText)) {
        _handleOperation(buttonText);
      } else if (buttonText == '=') {
        _calculateResult();
      } else if (buttonText == '.') {
        _addDecimal();
      } else if (buttonText == 'Del') {
        _deleteLastNumber();
      } else {
        _appendNumber(buttonText);
      }
    });
  }

  void _resetCalculator() {
    _display = '0';
    _storedValue = '';
    _operation = '';
    _shouldResetDisplay = false;
  }

  void _toggleSign() {
    if (_display != '0') {
      _display =
          _display.startsWith('-') ? _display.substring(1) : '-$_display';
    }
  }

  void _calculatePercentage() {
    final num value = double.parse(_display);
    _display = (value / 100).toString();
    _shouldResetDisplay = true;
  }

  void _handleOperation(String newOperation) {
    if (_storedValue.isEmpty) {
      _storedValue = _display;
    } else if (!_shouldResetDisplay) {
      _calculateResult();
    }
    _operation = newOperation;
    _shouldResetDisplay = true;
  }

  void _calculateResult() {
    if (_storedValue.isEmpty || _operation.isEmpty) return;
    final num num1 = double.parse(_storedValue);
    final num num2 = double.parse(_display);
    num result = 0;

    switch (_operation) {
      case '÷':
        result = num1 / num2;
        break;
      case 'x':
        result = num1 * num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '+':
        result = num1 + num2;
        break;
    }
    _display = _formatNumber(result.toString());
    _storedValue = _display;
    _operation = '';
    _shouldResetDisplay = true;
  }

  void _addDecimal() {
    if (_shouldResetDisplay) {
      _display = '0.';
      _shouldResetDisplay = false;
    } else if (!_display.contains('.')) {
      _display += '.';
    }
  }

  void _appendNumber(String number) {
    if (_shouldResetDisplay) {
      _display = number;
      _shouldResetDisplay = false;
    } else {
      _display = _display == '0' ? number : _display + number;
    }
  }

  _deleteLastNumber() {
    if (_display.length == 1) {
      _display = '0';
    } else if (_display != '0') {
      _display = _display.substring(0, _display.length - 1);
    }
    if (_operation.isEmpty) {
      _storedValue = _display;
    }
  }

  Widget _buildButton(String text) {
    // final bool isNumber = double.tryParse(text) != null || text == '.';
    final bool isZero = text == '0';
    final bool isOperator = ['÷', 'x', '-', '+', '='].contains(text);
    final bool isFunction = ['AC', '+/-', '%'].contains(text);
    final bool isDelete = 'Del'.contains(text);

    Color backgroundColor;
    if (isFunction) {
      backgroundColor = Colors.grey;
    } else if (isOperator) {
      backgroundColor = Colors.orange;
    } else if (isDelete) {
      backgroundColor = Colors.red;
    } else {
      backgroundColor = Colors.grey[850]!;
    }

    Color textColor;
    if (isFunction || isDelete) {
      textColor = Colors.black;
    } else {
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => _buttonPressed(text),
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
        // margin: EdgeInsets.all(8),
        width: isZero ? 75 : 75,
        height: 75,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(isZero ? 40 : 75),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Output Display
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.fromLTRB(10, 0, 50, 30),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _display,
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Buttons Placeholder
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children:
                    _buttons.map((row) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: row.map((btn) => _buildButton(btn)).toList(),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
