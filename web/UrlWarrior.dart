import "dart:html";
import "dart:math";
import "dart:async";


main() {
  var gameManager = new UrlWarriorGameManager(window.location);
  window.onKeyUp.listen(gameManager._onKeyUp);
}

class UrlWarriorGameManager {
  
  const String _WELCOME_MSG = "The Game is in the url. Press space to start ! Press 'H' for Help";
  final UrlWarriorGame _game;
  Timer _gameTimer;
  final Location location;
  //int _speed;
  
  UrlWarriorGameManager(this.location) : _game = new UrlWarriorGame() {
    _display(_WELCOME_MSG);
  }
  
  _onKeyUp(KeyboardEvent keyboardEvent){
    int keyCode = keyboardEvent.keyCode;
    if(_game.running && KeyCode.A<=keyCode && keyCode<=KeyCode.Z){
      _game.reduce(keyCode);
      _refreshDisplay();
    } else if(!_game.running && keyCode == KeyCode.SPACE){
      _start();
    } else if(!_game.running && keyCode == KeyCode.H){
      _help();
    }
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
  
  _help(){
    _display("Press on your keyboard the letter which appears in the token. 1 point when you success, -2 when letter is absent. When there are more than 50 letters, you lose");
  }
  
  _refreshDisplay(){
    _display("Score=${_game.score}#${_game.sequence}");  
  }

  _displayEndScore(){
    _display("Score=${_game.score}");  
  }  
  
  _display(String msg){
    location.hash = msg;
  }
  
}

class UrlWarriorGame {

  const int _MAX_SIZE = 50;
  List<int> _sequence = [];
  int _score = 0;
  Random _random = new Random();
  bool _running = false;
  
  UrlWarriorGame();
  
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