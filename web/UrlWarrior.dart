import "dart:html";
import "dart:math";
import "dart:async";

class UrlWarrior {

  const int _MAX_SIZE = 50;
  List<int> _sequence = [];
  int _score = 0;
  Random _random = new Random();
  bool _running = false;
  
  start(){
    _sequence = [];  
    _score = 0;
    _running = true;
  }
  
  generate(){
    var letter = _random.nextInt(26)+KeyCode.A;
    _sequence.add(letter);
    if(_sequence.length > _MAX_SIZE){
      _running = false;
    }
  }
  
  reduce(int keyCode){
    var sizeBefore = _sequence.length;
    _sequence.removeWhere((e) => keyCode == e);
    var sizeAfter = _sequence.length;
    var diff = sizeBefore-sizeAfter;
    if(diff == 0){// Bad touch !
      _score-=2;
    } else {
      _score+=(sizeBefore-sizeAfter);
    }
  }
  
  String get sequence => new String.fromCharCodes(_sequence).toLowerCase();
  
  int get score => _score;
  
  bool get running => _running;
  
}

UrlWarrior _game = new UrlWarrior();
Timer _gameTimer;

main() {
  window.location.hash = "The Game is in the url. Press space to start !";
  window.onKeyDown.listen(_onKeyDown);
}

_start(){
  _game.start();
  if(_gameTimer != null){
    _gameTimer.cancel();
  }
  _gameTimer = new Timer.periodic(new Duration(seconds: 1), (_) => _gameLoop());
}

_gameLoop(){
  if(_game.running){
    _game.generate();
    _refreshDisplay();
  } else {
    _displayEndScore();
  }
}

_refreshDisplay(){
  window.location.hash = "Score=${_game.score}#${_game.sequence}";  
}

_displayEndScore(){
  window.location.hash = "Score=${_game.score}";  
}

_onKeyDown(KeyboardEvent keyboardEvent){
  int keyCode = keyboardEvent.keyCode;
  if(KeyCode.A<=keyCode && keyCode<=KeyCode.Z){
    _game.reduce(keyCode);
    _refreshDisplay();
  } else if(!_game.running && keyCode == KeyCode.SPACE){
    _start();
  }
}