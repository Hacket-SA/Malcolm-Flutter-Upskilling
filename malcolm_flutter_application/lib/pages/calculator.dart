import 'dart:ffi';
import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../components/calculator/numpad.dart';

enum SYMBOL_VALUES {
  // ignore: constant_identifier_names
  BRACKET,
  // ignore: constant_identifier_names
  PERCENTAGE,
  // ignore: constant_identifier_names
  DIVIDE,
  // ignore: constant_identifier_names
  MULTIPLY,
  // ignore: constant_identifier_names
  SUBTRACT,
  // ignore: constant_identifier_names
  ADD,
  // ignore: constant_identifier_names
  DEFAULT
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const String divide = "÷";
  static const String multiply = "×";
  static const String subtract = "-";
  static const String add = "+";
  static const String percentage = "%";
  static const String openingBracket = "(";
  static const String closingBracket = ")";

  // text controller
  final TextEditingController _answerTextController = TextEditingController();
  final TextEditingController _inputTextController = TextEditingController();
  String decimalSymbol = ".";
  bool decimalSymbolInserted = false;
  bool overflowAnswer = false;
  int openedBrackets = 0;
  String currentNumberInput = "";
  List<double> inputNumbers = <double>[];
  List<String> inputSymbols = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hacket Calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // display the entered numbers
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 70,
              child: Center(
                  child: TextField(
                controller: _inputTextController,
                textAlign: TextAlign.right,
                textAlignVertical: TextAlignVertical.center,
                showCursor: false,
                readOnly: true,
                maxLines: 1,
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
                // Disable the default soft keybaord
                keyboardType: TextInputType.none,
              )),
            ),
          ),
          // display the calculated answer
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 70,
              width: ,
              child: Center(
                  child: TextField(
                controller: _answerTextController,
                textAlign: TextAlign.right,
                textAlignVertical: TextAlignVertical.center,
                showCursor: false,
                readOnly: true,
                maxLines: 1,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
                // Disable the default soft keybaord
                keyboardType: TextInputType.none,
              )),
            ),
          ),
          // implement the custom NumPad
          Numpad(
            clear: () {
              clearInputs();
              _answerTextController.text = "";
            },
            // do something with the input numbers
            addSymbol: (SYMBOL_VALUES symbolValue) {
              addSymbol(symbolValue);
            },
            addNumber: (int number) {
              addNumber(number);
            },
            addDecimalSymbol: () {
              addDecimalSymbol();
            },
            equals: () {
              addSymbol(SYMBOL_VALUES.DEFAULT);
              calculateAnswer();
            },
            backspace: () {
              backspace();
            },
          ),
        ],
      ),
    );
  }

  void clearInputs() {
    inputNumbers.clear();
    inputSymbols.clear();
    decimalSymbolInserted = false;
    overflowAnswer = false;
    openedBrackets = 0;
    currentNumberInput = "";
    _inputTextController.text = "";
  }

  void addSymbol(SYMBOL_VALUES symbolValue) {
    if (overflowAnswer) {
      overflowAnswer = false;
      for (var currentChar in inputNumbers.last.toString().characters) {
        if (currentChar == decimalSymbol || currentChar == ".") {
          addDecimalSymbol();
        } else {
          addNumber(int.parse(currentChar));
        }
      }
      _answerTextController.text = "";
    }
    if (decimalSymbol != ".") {
      currentNumberInput = currentNumberInput.replaceAll(decimalSymbol, ".");
    }
    switch (symbolValue) {
      case SYMBOL_VALUES.SUBTRACT:
        if (currentNumberInput == "" &&
            (inputSymbols.isNotEmpty && inputSymbols.last == closingBracket)) {
          inputSymbols.add(subtract);
          _inputTextController.text += subtract;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        } else if (currentNumberInput == "") {
          currentNumberInput += subtract;
          _inputTextController.text += subtract;
        } else if (inputSymbols.isEmpty && currentNumberInput == subtract) {
          currentNumberInput = "";
          decimalSymbolInserted = false;
          _inputTextController.text += subtract;
          _inputTextController.text =
              _inputTextController.text.replaceAll(subtract + subtract, "");
        } else if (inputSymbols.isNotEmpty && currentNumberInput == subtract) {
          currentNumberInput = "";
          decimalSymbolInserted = false;
          _inputTextController.text = _inputTextController.text
              .replaceAll(inputSymbols.last + subtract, inputSymbols.last);
        } else if (currentNumberInput != subtract) {
          inputNumbers.add(double.parse(currentNumberInput));
          inputSymbols.add(subtract);
          _inputTextController.text += subtract;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        }
        break;
      case SYMBOL_VALUES.BRACKET:
        if (currentNumberInput == "" &&
            (inputSymbols.isNotEmpty && inputSymbols.last != closingBracket)) {
          openedBrackets++;
          _inputTextController.text += openingBracket;
          inputSymbols.add(openingBracket);
        } else if (currentNumberInput == "" && inputSymbols.isEmpty) {
          openedBrackets++;
          _inputTextController.text += openingBracket;
          inputSymbols.add(openingBracket);
        } else if (currentNumberInput == "" &&
            (inputSymbols.isNotEmpty && inputSymbols.last == closingBracket) &&
            openedBrackets == 0) {
          addSymbol(SYMBOL_VALUES.MULTIPLY);
          openedBrackets++;
          _inputTextController.text += openingBracket;
          inputSymbols.add(openingBracket);
        } else if ((inputSymbols.isNotEmpty &&
                inputSymbols.last == closingBracket) &&
            openedBrackets > 0) {
          openedBrackets--;
          inputSymbols.add(closingBracket);
          _inputTextController.text += closingBracket;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        } else if ((currentNumberInput != "" &&
                currentNumberInput != subtract) &&
            openedBrackets > 0) {
          openedBrackets--;
          inputNumbers.add(double.parse(currentNumberInput));
          inputSymbols.add(closingBracket);
          _inputTextController.text += closingBracket;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        } else if ((currentNumberInput != "" &&
                currentNumberInput != subtract) &&
            openedBrackets == 0) {
          addSymbol(SYMBOL_VALUES.MULTIPLY);
          openedBrackets++;
          inputSymbols.add(openingBracket);
          _inputTextController.text += openingBracket;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        }
        break;
      case SYMBOL_VALUES.PERCENTAGE:
        if (currentNumberInput != "" && currentNumberInput != subtract) {
          currentNumberInput =
              (double.parse(currentNumberInput) / 100).toString();
          inputNumbers.add(double.parse(currentNumberInput));
          inputSymbols.add(multiply);
          _inputTextController.text += percentage + multiply;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        }
        break;
      case SYMBOL_VALUES.ADD:
        if (currentNumberInput != "" && currentNumberInput != subtract) {
          inputNumbers.add(double.parse(currentNumberInput));
          inputSymbols.add(add);
          _inputTextController.text += add;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        } else if ((inputSymbols.isNotEmpty &&
            inputSymbols.last == closingBracket)) {
          inputSymbols.add(add);
          _inputTextController.text += add;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        }
        break;
      case SYMBOL_VALUES.MULTIPLY:
        if (currentNumberInput != "" && currentNumberInput != subtract) {
          inputNumbers.add(double.parse(currentNumberInput));
          inputSymbols.add(multiply);
          _inputTextController.text += multiply;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        } else if ((inputSymbols.isNotEmpty &&
            inputSymbols.last == closingBracket)) {
          inputSymbols.add(multiply);
          _inputTextController.text += multiply;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        }
        break;
      case SYMBOL_VALUES.DIVIDE:
        if (currentNumberInput != "" && currentNumberInput != subtract) {
          inputNumbers.add(double.parse(currentNumberInput));
          inputSymbols.add(divide);
          _inputTextController.text += divide;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        } else if ((inputSymbols.isNotEmpty &&
            inputSymbols.last == closingBracket)) {
          inputSymbols.add(divide);
          _inputTextController.text += divide;
          currentNumberInput = "";
          decimalSymbolInserted = false;
        }
        break;
      default:
        if (currentNumberInput != "" && currentNumberInput != subtract) {
          inputNumbers.add(double.parse(currentNumberInput));
          currentNumberInput = "";
          decimalSymbolInserted = false;
        }
    }
  }

  void addDecimalSymbol() {
    if (overflowAnswer) {
      inputSymbols.removeLast();
      overflowAnswer = false;
    }
    if (!decimalSymbolInserted) {
      decimalSymbolInserted = true;
      if (currentNumberInput == "") {
        currentNumberInput += "0" + decimalSymbol;
        _inputTextController.text += "0" + decimalSymbol;
      } else {
        currentNumberInput += decimalSymbol;
        _inputTextController.text += decimalSymbol;
      }
    }
  }

  void addNumber(int number) {
    if (overflowAnswer) {
      inputSymbols.removeLast();
      overflowAnswer = false;
    }
    if (inputSymbols.isNotEmpty && inputSymbols.last == closingBracket) {
      addSymbol(SYMBOL_VALUES.MULTIPLY);
    }
    currentNumberInput += number.toString();
    _inputTextController.text += number.toString();
  }

  void backspace() {
    if (_inputTextController.text != "") {
      String beforeBackspace = _inputTextController.text;

      _inputTextController.text = _inputTextController.text
          .substring(0, _inputTextController.text.length - 1);
      try {
        int lastNumber = int.parse(beforeBackspace.characters.last);
        if (currentNumberInput != "") {
          currentNumberInput =
              currentNumberInput.substring(0, currentNumberInput.length - 1);
          if (currentNumberInput == subtract) {
            currentNumberInput =
                currentNumberInput.substring(0, currentNumberInput.length - 1);
            _inputTextController.text = _inputTextController.text
                .substring(0, _inputTextController.text.length - 1);
          }
        } else {
          var newNumber = removeDigit(inputNumbers.last);
          if (newNumber == null) {
            _inputTextController.text = _inputTextController.text
                .substring(0, _inputTextController.text.length - 1);
            inputNumbers.removeLast();
          } else {
            inputNumbers.last = newNumber;
          }
        }
      } on FormatException {
        inputSymbols.removeLast();
      }
    }
  }

  removeDigit(double currentNumber) {
    String numberString = currentNumber.toString();

    numberString = numberString.substring(0, numberString.length - 1);

    if (numberString != "" && numberString != subtract) {
      return double.parse(numberString);
    }
    return null;
  }

  void calculateAnswer() {
    if (_inputTextController.text != "") {
      if (_inputTextController.text.characters.last != closingBracket) {
        try {
          int.parse(_inputTextController.text.characters.last);
        } on FormatException {
          if (inputSymbols.isNotEmpty) {
            inputSymbols.removeLast();
          }
          _inputTextController.text = _inputTextController.text
              .substring(0, _inputTextController.text.length - 1);
        }
      }

      if (currentNumberInput != "" ||
          (inputSymbols.isNotEmpty && inputSymbols.last == closingBracket)) {
        while (openedBrackets > 0) {
          addSymbol(SYMBOL_VALUES.BRACKET);
        }
      }

      _inputTextController.text =
          _inputTextController.text.replaceAll(multiply, "*");

      _inputTextController.text =
          _inputTextController.text.replaceAll(divide, "/");

      Parser p = Parser();
      Expression exp = p.parse(_inputTextController.text);

      ContextModel cm = ContextModel();

      String eval = exp.evaluate(EvaluationType.REAL, cm).toString();

      if (eval.substring(eval.lastIndexOf(".")) == ".0") {
        eval = eval.replaceAll(".0", "");
      }

      _answerTextController.text = eval;
      clearInputs();
      inputNumbers.add(double.parse(_answerTextController.text));
      overflowAnswer = true;
    }
  }
}
