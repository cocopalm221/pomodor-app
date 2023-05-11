import 'package:flutter/material.dart';
import 'dart:async'; //Undefined class Timer error /수동으로 패키지 불러옴

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500; //1500을 복사할때 실수 방지
  int taotalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  int totalPomodoros = 0;
  late Timer timer;

  void onTick(Timer timer) {
    if (taotalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        taotalSeconds = twentyFiveMinutes;
      }); //25분이 다 되면 pomodoros 1씩 증가, 다시 25분 초기화
      timer.cancel(); //타이머가 0이 되면 타이머 취소
    } else {
      setState(() {
        taotalSeconds = taotalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
      //periodic 에서 첫번째는 시간, 두번째는 void 형태의 Timer를 인수로 받는 함수
      //late 키워드는 지연초기화, 나중에 사용할때 초기화됨
      //late timer는 onStartPressed()함수가 호출될 떄 초기화, Timer객체 생성
      //Timer 객체는 주기적으로 inTick 함수 실행, onTick함수에서 상태업데이트
      // late Timer timer는 작동중에 계속 실행, onTick 함수에서 상태 업데이트
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    // return '$seconds';
    return duration.toString().split(".").first.substring(2, 7);
    //"." 뒤로 split 해서 00:25:00 , 0000 문자열 두개
    //first 로 첫번째꺼만 00:25:00
    //substring(2,7)로 25:00
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(taotalSeconds), //25:00
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: IconButton(
                iconSize: 120,
                color: Theme.of(context).cardColor,
                onPressed: isRunning ? onPausePressed : onStartPressed, //(){}
                icon: Icon(isRunning
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outlined),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      // borderRadius: BorderRadius.circular(50), 에뮬레이터 따라 ui보고 적용할것
                      // borderRadius: const BorderRadius.only(
                      //     topLeft: Radius.circular(50),
                      //     topRight: Radius.circular(50)), //only 로 각각 주기
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
