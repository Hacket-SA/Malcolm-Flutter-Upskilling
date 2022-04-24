import 'package:flutter/material.dart';

import '../../pages/calculator.dart';

class Numpad extends StatelessWidget {
  final double buttonSize;
  final Color numberButtonColor;
  final Color actionButtonColor;
  final Color equalsButtonColor;
  final String decimalSymbol;
  final Function clear;
  final Function addSymbol;
  final Function addNumber;
  final Function addDecimalSymbol;
  final Function equals;
  final Function backspace;

  const Numpad({
    Key? key,
    this.buttonSize = 70,
    this.numberButtonColor = const Color.fromARGB(100, 100, 100, 100),
    this.actionButtonColor = const Color.fromARGB(61, 0, 199, 189),
    this.equalsButtonColor = const Color.fromARGB(146, 255, 154, 39),
    this.decimalSymbol = ".",
    required this.clear,
    required this.addSymbol,
    required this.addNumber,
    required this.addDecimalSymbol,
    required this.equals,
    required this.backspace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              ActionButton(
                  text: "C",
                  size: buttonSize,
                  color: actionButtonColor,
                  action: clear),
              ActionButton(
                text: "( )",
                size: buttonSize,
                color: actionButtonColor,
                action: addSymbol,
                symbolType: SYMBOL_VALUES.BRACKET,
              ),
              ActionButton(
                text: "%",
                size: buttonSize,
                color: actionButtonColor,
                action: addSymbol,
                symbolType: SYMBOL_VALUES.PERCENTAGE,
              ),
              ActionButton(
                text: "÷",
                size: buttonSize,
                color: actionButtonColor,
                action: addSymbol,
                symbolType: SYMBOL_VALUES.DIVIDE,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                number: 7,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              NumberButton(
                number: 8,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              NumberButton(
                number: 9,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              ActionButton(
                text: "×",
                size: buttonSize,
                color: actionButtonColor,
                action: addSymbol,
                symbolType: SYMBOL_VALUES.MULTIPLY,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 4,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              NumberButton(
                number: 5,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              NumberButton(
                number: 6,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              ActionButton(
                text: "-",
                size: buttonSize,
                color: actionButtonColor,
                action: addSymbol,
                symbolType: SYMBOL_VALUES.SUBTRACT,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 1,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              NumberButton(
                number: 2,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              NumberButton(
                number: 3,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              ActionButton(
                text: "+",
                size: buttonSize,
                color: actionButtonColor,
                action: addSymbol,
                symbolType: SYMBOL_VALUES.ADD,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              iconActionButton(
                icon: Icons.backspace_rounded,
                size: buttonSize,
                customColor: actionButtonColor,
                action: backspace,
              ),
              NumberButton(
                number: 0,
                size: buttonSize,
                color: numberButtonColor,
                addNumber: addNumber,
              ),
              ActionButton(
                text: decimalSymbol,
                size: buttonSize,
                color: numberButtonColor,
                action: addDecimalSymbol,
              ),
              ActionButton(
                text: "=",
                size: buttonSize,
                color: equalsButtonColor,
                action: equals,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final Function addNumber;

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.color,
    required this.addNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color.withOpacity(0.2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
        onPressed: () {
          addNumber(number);
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final Function action;
  final SYMBOL_VALUES symbolType;

  const ActionButton(
      {Key? key,
      this.symbolType = SYMBOL_VALUES.DEFAULT,
      required this.text,
      required this.size,
      required this.color,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color.withOpacity(0.2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
        onPressed: () {
          if (symbolType != SYMBOL_VALUES.DEFAULT) {
            action(symbolType);
          } else {
            action();
          }
        },
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}

class iconActionButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color customColor;
  final Function action;
  final SYMBOL_VALUES symbolType;

  const iconActionButton(
      {Key? key,
      this.symbolType = SYMBOL_VALUES.DEFAULT,
      required this.icon,
      required this.size,
      required this.customColor,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Ink(
          width: size,
          height: size,
          decoration: ShapeDecoration(
              color: customColor.withOpacity(0.2), shape: const CircleBorder()),
          child: IconButton(
            icon: Icon(icon),
            color: Colors.white,
            onPressed: () {
              if (symbolType != SYMBOL_VALUES.DEFAULT) {
                action(symbolType);
              } else {
                action();
              }
            },
          ),
        ),
      ),
    );
  }
}
