import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          surface: Colors.grey[900],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '';
  double? _num1;
  double? _num2;
  String _operand = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '';
        _num1 = null;
        _num2 = null;
        _operand = '';
      } else if (['+', '-', '*', '/'].contains(buttonText)) {
        if (_output.isNotEmpty) {
          _num1 = double.tryParse(_output);
          _operand = buttonText;
          _output = '$_num1 $buttonText ';
        }
      } else if (buttonText == '=') {
        if (_num1 != null && _output.isNotEmpty) {
          _num2 = double.tryParse(_output.split(' ').last);
          if (_num2 == null) return;

          switch (_operand) {
            case '+':
              _output = (_num1! + _num2!).toString();
              break;
            case '-':
              _output = (_num1! - _num2!).toString();
              break;
            case '*':
              _output = (_num1! * _num2!).toString();
              break;
            case '/':
              _output =
                  _num2 == 0
                      ? "Error: Cannot divide by zero"
                      : (_num1! / _num2!).toString();
              break;
          }
          _num1 = null;
          _num2 = null;
          _operand = '';
        }
      } else {
        _output += buttonText;
      }
    });
  }

  Widget _buildButton(
    String buttonText, {
    Color? buttonColor,
    Color? textColor,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor ?? Colors.grey[800],
            foregroundColor: textColor ?? Colors.white,
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      children:
          buttons.map((button) {
            return _buildButton(
              button,
              buttonColor:
                  button == 'C'
                      ? Colors.redAccent
                      : (['=', '+', '-', '*', '/'].contains(button)
                          ? Colors.blueGrey
                          : Colors.grey[800]),
              textColor: button == '=' ? Colors.amber : Colors.white,
            );
          }).toList(),
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
              padding: EdgeInsets.all(28.0),
              child: Text(
                _output,
                style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(height: 0.0),
          Column(
            children: [
              _buildButtonRow(['7', '8', '9', '/']),
              _buildButtonRow(['4', '5', '6', '*']),
              _buildButtonRow(['1', '2', '3', '-']),
              _buildButtonRow(['C', '0', '=', '+']),
            ],
          ),
        ],
      ),
    );
  }
}
