import 'package:flutter/material.dart';

import 'package:math_expressions/math_expressions.dart';
//import 'cli_evaluator.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/services.dart';

//void main() => runApp(MyApp());

void main() async {
  ///
  /// Force the layout to Portrait mode
  ///
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(new MyApp());
}

final PageController controller = new PageController();

class PopupMenuConstants {
  static const String DarkMode = 'Dark Mode';
  static const String LightMode = 'Light Mode';

  static const List<String> choices = <String>[DarkMode, LightMode];
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        //primarySwatch: Colors.blue
      ),
      home: MyHomePage(title: 'Calculator'),
    );
  }
}*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Calculator',
            theme: theme,
            home: new MyHomePage(title: 'Calculator'),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String output = "";

  String secondOutput = "";

  String _output = "";

  String _secondOutput = "";

  buttonPressed(String buttonText) {
    String calculateExp() {
      Parser p = new Parser();

      //_output = _output.replaceAll('X', '*');
      _output = _output.replaceAll('%', '/100');

      Expression result = p.parse(_output);
      ContextModel cm = new ContextModel();

      try {
        result.evaluate(EvaluationType.REAL, cm);
      } catch (e) {
        return 'Error';
      }

      String eval = result.evaluate(EvaluationType.REAL, cm).toString();

      if (eval.endsWith('.0')) {
        eval = eval.substring(0, eval.length - 2);
      }

      return eval;
    }

    if (buttonText == "C") {
      _output = "";
      _secondOutput = "";
    } else if (buttonText == "<=") {
      _output = _output.substring(0, _output.length - 1);
      _secondOutput = _output;
    } else if (buttonText == "=") {
      _output = calculateExp();
      _secondOutput = _output;
    } else if (buttonText != "/" &&
        buttonText != "*" &&
        buttonText != "+" &&
        buttonText != "-" &&
        buttonText != "^" &&
        buttonText != "." &&
        buttonText != "%" &&
        _output.length <= 27) {
      _output += buttonText;
      _secondOutput = calculateExp();
    } else if (_output.length <= 27 && (_output != "")) {
      if ((_output.endsWith('/') ||
              _output.endsWith('*') ||
              _output.endsWith('^') ||
              _output.endsWith('+') ||
              _output.endsWith('-')) &&
          ((buttonText == "/") ||
              (buttonText == "*") ||
              (buttonText == "^") ||
              (buttonText == "%") ||
              (buttonText == "+"))) {
        _output = _output.substring(0, _output.length - 1);
        _output += buttonText;
      } else if ((_output.endsWith('/') ||
              _output.endsWith('*') ||
              _output.endsWith('^')) &&
          ((buttonText == "+") || (buttonText == "%"))) {
        // do nothing
      } else if (_output.endsWith('-') && buttonText == "+") {
        _output = _output.substring(0, _output.length - 1);
        _output += buttonText;
      } else if (buttonText == "%") {
        _output += buttonText;
        _secondOutput = calculateExp();
      } else if (buttonText == '.') {
        // check if number has only one dot
        if (!_output.contains('.')) {
          _output += buttonText;
        } else {
          int start;
          for (int i = 0; i < _output.length; ++i) {
            if (_output[i] == '+' ||
                _output[i] == '-' ||
                _output[i] == '*' ||
                _output[i] == '/' ||
                _output[i] == '^') {
              start = i;
            }
          }

          if (_output.contains('.', start)) {
            // do nothing
          } else {
            _output += buttonText;
          }
        }
      } else {
        _output += buttonText;
      }
    } else if (_output == "" && (buttonText == "-" || buttonText == ".")) {
      _output += buttonText;
    }

    setState(() {
      output = _output;
      secondOutput = _secondOutput;
    });
  }

  Widget buildButton(String buttonText) {
    if (buttonText == "=") {
      return new Expanded(
        child: new FlatButton(
          color: Colors.indigo,
          padding: new EdgeInsets.all(24.0),
          child: new Text(
            buttonText,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => buttonPressed(buttonText),
        ),
      );
    } else {
      return new Expanded(
        child: new FlatButton(
          padding: new EdgeInsets.all(24.0),
          child: new Text(
            buttonText,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => buttonPressed(buttonText),
        ),
      );
    }
  }

  Widget firstPage() {
    return new Column(
      children: [
        new Row(children: [
          buildButton("C"),
          buildButton("/"),
          buildButton("*"),
          buildButton("<=")
        ]),
        new Row(children: [
          buildButton("7"),
          buildButton("8"),
          buildButton("9"),
          buildButton("-")
        ]),
        new Row(children: [
          buildButton("4"),
          buildButton("5"),
          buildButton("6"),
          buildButton("+")
        ]),
        new Row(children: [
          buildButton("1"),
          buildButton("2"),
          buildButton("3"),
          buildButton("^")
        ]),
        new Row(children: [
          buildButton("%"),
          buildButton("0"),
          buildButton("."),
          buildButton("=")
        ]),
      ],
    );
  }

  Widget secondPage() {
    return new Column(
      children: [
        new Row(children: [
          buildButton("C"),
          buildButton("/"),
          buildButton("*"),
          buildButton("<=")
        ]),
        new Row(children: [
          buildButton("7"),
          buildButton("8"),
          buildButton("9"),
          buildButton("-")
        ]),
        new Row(children: [
          buildButton("4"),
          buildButton("5"),
          buildButton("6"),
          buildButton("+")
        ]),
        new Row(children: [
          buildButton("1"),
          buildButton("2"),
          buildButton("3"),
          buildButton("^")
        ]),
        new Row(children: [
          buildButton("%"),
          buildButton("0"),
          buildButton("."),
          buildButton("=")
        ]),
      ],
    );
  }

  void choiceAction(String choice) {
    if (choice == PopupMenuConstants.DarkMode) {
      DynamicTheme.of(context).setBrightness(Brightness.dark);
    } else if (choice == PopupMenuConstants.LightMode) {
      DynamicTheme.of(context).setBrightness(Brightness.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return PopupMenuConstants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Container(
                  alignment: Alignment.centerRight,
                  padding: new EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  child: new Text(output,
                      style: new TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.bold))),
              new Container(
                  alignment: Alignment.centerRight,
                  padding: new EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  child: new Text(secondOutput,
                      style: new TextStyle(
                          color: Colors.grey,
                          fontSize: 24.0,
                          fontWeight: FontWeight.normal))),
              new Expanded(
                child: new Divider(
                    // height: 100.0,
                    ),
              ),
              new Container(child: firstPage())

              /*new Expanded(
                child: PageView(
                  children: <Widget>[
                    Container(child: firstPage()),
                    Container(child: secondPage()),
                  ],
                  controller: controller,
                ),
              )*/
            ],
          ),
        ));
  }
}
