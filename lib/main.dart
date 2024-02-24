import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = "";
  var userAnswer = "";
  var previousAnswer = "";

  final myTextstyle = TextStyle(
    color: Colors.deepPurple[900],
    fontFamily: "Poppins",
    fontSize: 30,
  );

  final List<String> buttons = [
    "C",
    "DEL",
    "%",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "0",
    ".",
    "ANS",
    "=",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userQuestion,
                      style: myTextstyle,
                    )),
                Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userAnswer,
                      style: myTextstyle,
                    ))
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  child: GridView.builder(
                      itemCount: buttons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  userQuestion = "";
                                });
                              },
                              buttonText: buttons[index],
                              color: Colors.green,
                              textColor: Colors.white);
                        } else if (index == 1) {
                          return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  userQuestion = userQuestion.substring(
                                      0, userQuestion.length - 1);
                                });
                              },
                              buttonText: buttons[index],
                              color: Colors.red,
                              textColor: Colors.white);
                        } else if (index == buttons.length - 2) {
                          // Gérer le bouton "ANS"
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                userQuestion +=
                                    previousAnswer; // Ajouter la réponse précédente à la question
                              });
                            },
                            buttonText: buttons[index],
                            color: Colors
                                .orange, // Modifier la couleur comme souhaité
                            textColor: Colors
                                .white, // Modifier la couleur du texte comme souhaité
                          );
                        } else if (index == buttons.length - 1) {
                          return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  equalPressed();
                                });
                              },
                              buttonText: buttons[index],
                              color: Colors.deepPurple,
                              textColor: Colors.white);
                        } else {
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                userQuestion += buttons[index];
                              });
                            },
                            buttonText: buttons[index],
                            color: isOperator(buttons[index])
                                ? Colors.deepPurple
                                : Colors.deepPurple[50],
                            textColor: isOperator(buttons[index])
                                ? Colors.white
                                : Colors.deepPurple,
                          );
                        }
                      })))
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == "%" || x == "/" || x == "*" || x == "-" || x == "+" || x == "=") {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;

    finalQuestion = finalQuestion.replaceAll('%', '*0.01');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
    previousAnswer = userAnswer; // Stockez la réponse calculée
  }
}
