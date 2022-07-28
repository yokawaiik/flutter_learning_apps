import 'dart:math';

import 'package:flutter/material.dart';

// Класс, наследующий виджет с состоянием
// То есть виджет имеет состояние
class DiceScreen extends StatefulWidget {
  const DiceScreen({Key? key}) : super(key: key);

  // состояние виджета
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

// класс, описывающий состояние виджета
class _DiceScreenState extends State<DiceScreen> {
  // Для проверки начала игры
  bool isGameStarted = false;
  // Число игральных костей
  final int diceCount = 2;
  // Для хранения изображений игральных костей
  List<Image> dices = [];

  // Пути на изображения игральных костей
  final Map<int, String> sideOfDice = {
    0: 'dice/dice1.png',
    1: 'dice/dice2.png',
    2: 'dice/dice3.png',
    3: 'dice/dice4.png',
    4: 'dice/dice5.png',
    5: 'dice/dice6.png',
  };

  // Метод бросание кости
  void throwDice() {
    // Максимальное число на очков на кости
    const maxNumber = 6;
    // Минимальное число на очков на кости
    const minNumber = 0;
    // Класс random, для будущей генерации
    Random random = Random();
    // очистка выпавших значений
    dices.clear();
    // обновить экран и изменить переменную
    setState(() {
      isGameStarted = true;
    });
    // Генерация чисел и заполнение массива выпавшими изображениями
    setState(() {
      for (int i = 0; i < diceCount; i++) {
        var generatedNumber = random.nextInt(maxNumber) + minNumber;
        dices.add(Image.asset(sideOfDice[generatedNumber]!, scale: 0.8));
      }
    });
  }

  // метод, срабатывающий при открытии виджета
  // и каждый раз после изменения состояния setState
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[300],
      body: SafeArea(

        child: 
        // Если игра началась, то показать игральные кости
        isGameStarted
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      itemCount: dices.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: diceCount),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: dices[index],
                        );
                      },
                    ),
                  )
                ],
              ),
              IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Кнопка броска
                    MaterialButton(
                      color: Colors.red[100],
                      child: Text('Roll'),
                      // ссылка на функцию броска, которая сработает при нажатии
                      onPressed: throwDice,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        // если игра не началась, то есть экран стартовый, то показать кнопку игры
        // при нажатии на кнопку изменится экран и срботает функция броска
            : Center(
          child: MaterialButton(
            child: Text('play'),
            color: Colors.purple,
            onPressed: throwDice,
          ),
        ),
      ),
    );
  }
}
