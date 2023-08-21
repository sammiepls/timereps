import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'button.dart';

void main() {
  runApp(const TimeReps());
}

class TimeReps extends StatelessWidget {
  const TimeReps({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeReps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MainTimer(title: 'TimeReps'),
    );
  }
}

class MainTimer extends StatefulWidget {
  const MainTimer({super.key, required this.title});
  final String title;

  @override
  State<MainTimer> createState() => _MainTimerState();
}

class _MainTimerState extends State<MainTimer> {
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  String inputSeconds = "";
  Timer? timer;

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer(reset: false);
        }
      });
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() {
      timer?.cancel();
    });
  }

  void resetTimer() {
    setState(() => seconds = int.parse(inputSeconds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [0.1, 0.9],
            colors: [Colors.grey.shade900, Colors.brown.shade900],
          )),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildTimer(),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          if (value != "") {
                            int intValue = int.parse(value);
                            if (intValue <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Not a valid value')));
                            } else {
                              inputSeconds = value;
                              resetTimer();
                            }
                          }
                        });
                      },
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white, fontSize: 40),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.datetime,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const Text('s',
                      style: TextStyle(color: Colors.white30, fontSize: 30))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: buildButtons())
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == 0 || seconds == int.parse(inputSeconds);

    return isRunning || !isCompleted
        ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Button(
                text: isRunning ? 'Pause' : 'Resume',
                onClicked: () {
                  isRunning
                      ? stopTimer(reset: false)
                      : startTimer(reset: false);
                }),
            Button(
              text: 'Cancel',
              onClicked: () {
                stopTimer(reset: true);
              },
            )
          ])
        : Button(
            text: 'Start Timer',
            onClicked: () {
              if (inputSeconds != "" && int.parse(inputSeconds) > 0) {
                startTimer();
              }
            },
            color: Colors.brown,
            backgroundColor: Colors.white);
  }

  Widget buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(fit: StackFit.expand, children: [
          CircularProgressIndicator(
            value: seconds / int.parse(inputSeconds),
            strokeWidth: 12,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            backgroundColor: Colors.greenAccent,
          ),
          Center(
            child: buildTime(),
          )
        ]),
      );

  Widget buildTime() {
    return Text('$seconds',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: seconds == 0 ? Colors.greenAccent : Colors.white,
          fontSize: 80,
        ));
  }
}
