import 'dart:io';

import 'dart:math';

class Uno {
  List<String> humanPlayers = [], compPlayers = [];
  List<String> mastList = ['П', 'Т', 'Б', 'Ч'];
  List<String> dostList = ['6', '7', '8', '9', '10', 'В', 'Д', 'К', 'Т'];
  int currentMovePlayer, basePlayer = 0;
  Map<String, List<String>> cards = {};
  String name;
  
  Uno(this.name, this.humanPlayers) {
    //this.gameName = name;
    //this.humanPlayers = players;

    cards['base'] = [];
    cards['heap'] = [];
    //humanPlayers.forEach((player) => cards[player] = []);
    //compPlayers.forEach((player) => cards[player] = []);
    mastList.forEach((mast) {
      dostList.forEach((dost) {
        cards['base'].add(dost + '-' + mast);
      });
    });
    print('Карты: $cards');
    print('[$name] Размешиваем колоду...');
    rand('base');
    print('[$name] Раздаем карты');
    razdacha(humanPlayers.length);
  }

  void rand(String owner) {
    List<String> tempBase = [];
    for (var i = 0; i < cards[owner].length; i++) {
      tempBase.add(cards[owner].elementAt(Random().nextInt(cards[owner].length)));
    }
    cards[owner].clear();
    cards[owner] = tempBase;
  }

  void razdacha(int num) {
    for (var i = 0; i < num; i++) {
      humanPlayers.forEach((player) {
        cards[player].add(cards['base'].first);
        cards['base'].removeAt(0);
      });
    }
  }

  List<String> initMove() {
    List<String> _move = [];
    cards['heap'].add(cards['base'].first);
    print(cards['heap']);
    _move.add(cards['base'].first);
    cards['base'].removeAt(0);
    String _dost = cards['heap'].first.split('-')[0];
    bool _sameDostCards = false;
    cards[humanPlayers[currentMovePlayer]].forEach((card){
      if (card.startsWith(_dost)) _sameDostCards = true;
      }
    );
    if (_sameDostCards) {
      _move.addAll(letPlayerEndMoveWithSameDostCards(_dost));
      print('Ход: $_move');
    }
    else {
      print('Ход: $_move');
      print('Переход хода игроку: ${setNextPlayer()}');
    }
    return _move;
  }

  List<String> letPlayerEndMoveWithSameDostCards(String dost) {
    List<String> _move = [];
    List<int> variants = [];
    print('Можно добавить карты к текущему ходу (укажите цифры через запятую):');
    int _index = 0;
    cards[humanPlayers[currentMovePlayer]].forEach((card) {
      if (card.startsWith(dost)) {
        print('Выбор: [$_index] $card');
        variants.add(_index);
      }
      _index++;
    });
    String input = stdin.readLineSync();
    //print(input);
    input.split(',').forEach((str){_move.add(cards[currentMovePlayer][int.parse(str)]);});

    return _move;

  }

  void setMoveTo(int index) {
    currentMovePlayer = index;
  }

  String setNextPlayer() {
    int numberOfPlayers = humanPlayers.length + compPlayers.length;
    if (currentMovePlayer == numberOfPlayers) {
      currentMovePlayer = 0;
    } else {
      currentMovePlayer++;
    }
    return humanPlayers[currentMovePlayer];
  }

  void razdachaToCurrentPlayer(int num) {
    for (var i = 0; i < num; i++) {
      cards[currentMovePlayer].add(cards['base'].first);
      cards['base'].removeAt(0);
    }
  }
  void makeRuleOperation(List<String> moveCards) {
    List<String> _card;
    _card = cards['heap'].last.split('-');
    String _dost = _card[0];
    switch (_dost) {
      case '6': {
        razdachaToCurrentPlayer(2);
      }
      break;
      case '7': {
        razdachaToCurrentPlayer(1);
      }
      break;
      case '8': {
        setNextPlayer();
      }
    }
  }
}