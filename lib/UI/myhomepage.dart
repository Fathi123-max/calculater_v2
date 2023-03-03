import 'dart:developer';

import 'package:calculater_v2/UI/compunant/button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var questionOfUser = "";
  var answerOfUser = "";
 var questions=[];

  List<String> Buttons = [
    "AC",
    "(",
    ")",
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
    "DEL",
    "="
  ];

  TextEditingController controller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            color: Colors.transparent,
           height: screenHight*.15,
             width: screenHight,
             child: ListView.builder(
               itemCount: questions.length,
               itemBuilder: (context, index) {
               return GestureDetector(
                onTap: () {
                  setState(() {
                    controller.text=questions[index];
                  });
                },
                 child: ListTile(title:Text(questions[index]
                 ,)
                 ),
               );
             },),
           ),
          Expanded(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: TextFormField(controller: controller,
                     enabled: false,
                    onChanged: (value) {
                      setState(() {
                        parse();
                        print(value);
                        log(value.toString(),name: "m");

                      });
                    },

                  )
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    answerOfUser,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
          //? pad
          Expanded(
          flex: 3,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: Buttons.length,
              itemBuilder: (BuildContext context, int index) {
                //? Delete Buttons
                if (index == 0 || index == 18) {
                  return Button(
                      buttontapped: () {
                        setState(() {
                          if (index == 0) {
                            controller.text= "";
                            answerOfUser="";
                          } else {
                            if (controller.text.isNotEmpty) {
                              controller.text = controller.text.substring(
                                  0, controller.text.length - 1);
                            }
                          }
                        });
                      },
                      buttonColor: Theme.of(context).primaryColorLight,
                      buttonText: Buttons[index],
                      textColor: Theme.of(context).backgroundColor);
                  //? Equal Button
                } else if (index == 19) {
                  return Button(
                      buttontapped: () {
                        setState(() {

                          parse();
                          
                        });
                      },
                      buttonColor: Theme.of(context).disabledColor,
                      buttonText: Buttons[index],
                      textColor: Colors.white);
                }
                //? Normal Button
                return Button(
                    buttontapped: () {
                      setState(() {
                        controller.text += Buttons[index];
                      });
                    },
                    buttonColor: operator(Buttons[index])!
                        ? Theme.of(context).errorColor
                        : Theme.of(context).toggleableActiveColor,
                    buttonText: Buttons[index],
                    textColor: Colors.white);
              },
            ),
          )
        ],
      ),
    );
  }

  bool? operator(String x) {
    if (x == "%" || x == "/" || x == "*" || x == "-" || x == "+") {
      return true;
    } else {
      return false;
    }
  }

  parse (){
    try {
      Parser p = Parser();
      Expression exp = p.parse(controller.text);
      ContextModel cm = ContextModel();
      double eval =
      exp.evaluate(EvaluationType.REAL, cm);
      answerOfUser = eval.toString();
      questions.add(controller.text);

    } catch (e) {
      print(e);
    }
  }
}
