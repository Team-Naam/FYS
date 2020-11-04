//Code credit Winand Metz

//Alles game gerelateerd
class Game {
  ObjectHandler objectHandler;
  MapHandler mapHandler;
  Sprites sprites;

  final int width, height;

  //Inladen van alle assets voor de game en level creation dmv inladen van een png map, op basis van pixels plaatsing van objecten
  //TileSize is grote van de blokken in het plaatsingsgrid (tegelgrote)
  Game(int tileSize, int width, int height) {
    this.width =  width;
    this.height = height;
    sprites = new Sprites("data/text/textures.png", tileSize);
    objectHandler = new ObjectHandler(this.sprites);
    mapHandler = new MapHandler(tileSize);
    objectHandler.addPlayer();
  }

  //Oproepen van objecten in de game zodat ze worden getekend
  void update() {
    mapHandler.update();
    objectHandler.update();
  }

  void draw() {
    background(128);
    objectHandler.draw();
  }
}

class HighScore{
 int score, timeScore;
 int timer, time;
  
  HighScore(){
   score = 0;
   timeScore = TIME_SCORE;
   timer = FRAMERATE * TIME_SCORE_TIMER;
   time = 0;
 }
 
 //iedere sec komt er score bij
 void update(){
   time += 1;
   if (time == timer) {
     score += timeScore;
     time = 0;
   }
 }
 //als je buiten deze class score wilt toevoegen
 void addScore(int amount){
   score += amount;
 }
}
