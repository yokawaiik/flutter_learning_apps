import 'dart:math';

import 'package:black_jack/widgets/cards_grid_view.dart';
import 'package:black_jack/widgets/style_button.dart';
import 'package:flutter/material.dart';

class BlackJackScreen extends StatefulWidget {
  const BlackJackScreen({Key? key}) : super(key: key);

  @override
  _BlackJackScreenState createState() => _BlackJackScreenState();
}

class _BlackJackScreenState extends State<BlackJackScreen> {
  List<Image> playersCards = [];

  List<Image> dealersCards = [];

  final Map<String, int> deckOfCards = {
    "cards/2.1.png": 2,
    "cards/2.2.png": 2,
    "cards/2.3.png": 2,
    "cards/2.4.png": 2,
    "cards/3.1.png": 3,
    "cards/3.2.png": 3,
    "cards/3.3.png": 3,
    "cards/3.4.png": 3,
    "cards/4.1.png": 4,
    "cards/4.2.png": 4,
    "cards/4.3.png": 4,
    "cards/4.4.png": 4,
    "cards/5.1.png": 5,
    "cards/5.2.png": 5,
    "cards/5.3.png": 5,
    "cards/5.4.png": 5,
    "cards/6.1.png": 6,
    "cards/6.2.png": 6,
    "cards/6.3.png": 6,
    "cards/6.4.png": 6,
    "cards/7.1.png": 7,
    "cards/7.2.png": 7,
    "cards/7.3.png": 7,
    "cards/7.4.png": 7,
    "cards/8.1.png": 8,
    "cards/8.2.png": 8,
    "cards/8.3.png": 8,
    "cards/8.4.png": 8,
    "cards/9.1.png": 9,
    "cards/9.2.png": 9,
    "cards/9.3.png": 9,
    "cards/9.4.png": 9,
    "cards/10.1.png": 10,
    "cards/10.2.png": 10,
    "cards/10.3.png": 10,
    "cards/10.4.png": 10,
    "cards/J1.png": 10,
    "cards/J2.png": 10,
    "cards/J3.png": 10,
    "cards/J4.png": 10,
    "cards/Q1.png": 10,
    "cards/Q2.png": 10,
    "cards/Q3.png": 10,
    "cards/Q4.png": 10,
    "cards/K1.png": 10,
    "cards/K2.png": 10,
    "cards/K3.png": 10,
    "cards/K4.png": 10,
    "cards/A1.png": 11,
    "cards/A2.png": 11,
    "cards/A3.png": 11,
    "cards/A4.png": 11,
  };

  bool isGameStarted = false;

  Map<String, int> playingCards = {};

  String? playersFirstCard;
  String? playersSecondCard;

  String? dealersFirstCard;
  String? dealersSecondCard;

  int playersScore = 0;
  int dealersScore = 0;

  // add all cards after start
  @override
  void initState() {
    super.initState();

    playingCards.addAll(deckOfCards);
  }

  void changeCards() {
    setState(() {
      isGameStarted = true;
    });

    // reset game
    playingCards = {};
    playingCards.addAll(deckOfCards);
    playersCards = [];
    dealersCards = [];

    Random random = Random();

    // from 1 to playingCards.length inclusive
    String cardOneKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));

    // checks all cards and remove cardOneKey from playing cards
    playingCards.removeWhere((key, value) => key == cardOneKey);

    String cardTwoKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));

    String cardThreeKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    String cardFourKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));

    dealersFirstCard = cardOneKey;
    dealersSecondCard = cardTwoKey;

    playersFirstCard = cardThreeKey;
    playersSecondCard = cardFourKey;

    dealersCards.add(Image.asset(dealersFirstCard!));
    dealersCards.add(Image.asset(dealersSecondCard!));

    dealersScore =
        deckOfCards[dealersFirstCard]! + deckOfCards[dealersSecondCard]!;

    playersCards.add(Image.asset(playersFirstCard!));
    playersCards.add(Image.asset(playersSecondCard!));

    playersScore =
        deckOfCards[playersFirstCard]! + deckOfCards[playersFirstCard]!;

    if (dealersScore <= 14) {
      String dealersThirdCard =
          playingCards.keys.elementAt(random.nextInt(playingCards.length));
      playingCards.removeWhere((key, value) => key == dealersThirdCard);

      dealersCards.add(Image.asset(dealersThirdCard));
      dealersScore = dealersScore + deckOfCards[dealersThirdCard]!;
    }
  }

  // add Card
  void addCard() {
    Random random = Random();

    if (playingCards.isNotEmpty) {
      String cardKey =
          playingCards.keys.elementAt(random.nextInt(playingCards.length));

      setState(() {
        playersCards.add(Image.asset(cardKey));
      });

      playersScore = playersScore + deckOfCards[cardKey]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isGameStarted
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Dillers Card
                    Column(
                      children: [
                        Text(
                          "Dealer's score $dealersScore",
                          style: TextStyle(
                              color: dealersScore <= 21
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CardsGridView(cards: dealersCards),
                      ],
                    ),
                    // Players Cards
                    Column(
                      children: [
                        Text("Player's score $playersScore",
                            style: TextStyle(
                                color: playersScore <= 21
                                    ? Colors.green
                                    : Colors.red)),
                        const SizedBox(height: 20),
                        CardsGridView(cards: playersCards),
                      ],
                    ),
                    // 2 buttons
                    IntrinsicWidth(
                      child: Column(
                        // equal width for buttons
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          StyleButton(label: 'Another Card', onPressed: addCard),
                          StyleButton(label: 'Next Round', onPressed: changeCards),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child:
                StyleButton(label: 'Start game', onPressed: changeCards),
            ),
    );
  }
}


