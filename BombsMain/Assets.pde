//Page code credit Winand Metz, Alex Tarnòki

//Code credit Winand Metz
//Inladen en tijdelijk opslaan textures
class TextureAssets {

  //PImage array slaat spritesheet op als "serie" van losse sprites
  final PImage[][] sprites;
  final PImage[][] wallSprites;
  final PImage[][] itemsBombsUI;
  final PImage[][] menusUserInterface;
  final PImage[][] entities;
  final PImage[][] vasesAndBackpacks;
  final PImage[][] corpses;
  final PImage[][] bWallSprites;
  //final PImage[][] rockSprites;
  final PImage[][] backgroundSprites;
  final PImage[][] backgroundOverlays;
  final PImage[][] explosion;
  final PImage logo;
  final PImage main_menu;
  int bombUISize = 32;
  int entitySize = 64;
  int vasesAndBackpacksSize = 64;
  int explosionSize = 256;

  //Laad alle images in vanaf het begin
  TextureAssets(int tileSize) {
    logo = loadImage("data/text/logo_highres.png");
    main_menu = loadImage("data/text/ui/main menu.png");
    sprites = loadSprites("data/text/textures.png", tileSize);
    wallSprites = loadSprites("data/text/walls/walls_spritesheet.png", tileSize);
    itemsBombsUI = loadSprites("data/text/items/itemsBombsUI.png", bombUISize);
    menusUserInterface = loadSprites("data/text/ui/menu_ui.png", tileSize);
    entities = loadSprites("data/text/entities/poltergeist_test_64.png", entitySize);
    bWallSprites = loadSprites("data/text/walls/broken_walls_spritesheet.png", tileSize);
    vasesAndBackpacks = loadSprites("data/text/objects/backpacksAndVases.png", vasesAndBackpacksSize);
    backgroundSprites = loadSprites("data/text/floors/floors.png", tileSize);
    backgroundOverlays = loadSprites("data/text/floors/overlays.png", tileSize);
    explosion = loadSprites("data/text/effects/explosion.png", explosionSize);
    corpses = loadSprites("data/text/objects/corpse.png", tileSize);
  }

  PImage getLogo() {
    return logo;
  }

  PImage getMenuBackground() {
    return main_menu;
  }

  //Meeste methods hebben een row en column argument voor het bepalen van welke sprite moet worden gebruikt vanuit de array
  PImage getBackground(int row, int column) {
    return backgroundSprites[row][column];
  }

  PImage getBackgroundOverlay(int row, int column) {
    return backgroundOverlays[row][column];
  }

  PImage getCorpse(int row, int column) {
    return corpses[row][column];
  }

  PImage getObject(int row, int column) {
    return vasesAndBackpacks[row][column];
  }

  PImage getWall(int row, int column) {
    return wallSprites[row][column];
  }

  PImage getBrokenWall(int row, int column) {
    return bWallSprites[row][column];
  }

  PImage getEntity(int row, int column) {
    return entities[row][column];
  }

  PImage getRock() {
    return sprites[1][0];
  }

  //Lives/armor is (0, 0) tot en met (3, 0), highscore is (0, 1) tot (0, 3)
  //Detonation device off is (4, 0) en on is (5, 0)
  //Hud bomb icons zijn C4(6, 0), dynamite(7, 0) en landmine(7, 1)
  PImage getUserHud(int row, int column) {
    return menusUserInterface[row][column];
  }

  //Landmine (0, 0), dynamite (1, 0), c4 (2, 0)
  PImage getBombItem(int row, int column) {
    return itemsBombsUI[row][column];
  }

  //Z (0), x (2), s (4), a (6), on colum 7 (row, voor non-pressed, + 1 for pressed)
  //Esc on colum 6 (row 0, + 1 for pressed)
  PImage getKeyCap(int row, int column) {
    return itemsBombsUI[row][column];
  }
}

//Class voor het tekenen van een spritesheet animatie
class SpriteSheetAnim {
  PImage[][] images;

  float x, y, index, speed;
  int fps, column, frames;
  int minusIndex = 1;

  boolean playing, playOnce, center;

  /* Neemt een 2d pimage array in voor de frames, welke column de sprite animation te vinden is,
   het aantal frames dat de animtion bevat en de afspeelsnelheid */
  SpriteSheetAnim(PImage[][] images_, int column_, int frames_, int fps) {
    this.images = images_;
    this.column = column_;
    this.frames = frames_;

    playing = true;
    playOnce = false;
    center = false;

    index = 0;
    setFPS(fps);
  }

  //Method voor bepalen afspeelsnelheid, kan dus altijd verandert worden, mid-animatie etc
  void setFPS(int fps) {
    this.fps = fps;
  }

  //Bepaald de absolute snelheid van de animatie (niet gebruiken buiten de class)
  private void setSpeed(int fps) {
    speed = fps / (float)frameRate;
  }

  //Veranderd de draw image functie naar center als de animtie vanuit midden moet afspelen van het object
  void setCenter() {
    center = true;
  }

  //Zorgt ervoor dat animatie één keer afspeelt
  void playOnce() {
    index = 0;
    playOnce = true;
    playing = true;
  }

  //Draait de animatie zolang het object bestaat
  void loop() {
    playing = true;
    playOnce = false;
  }

  //Stopt het afspelen
  void stop() {
    playing = false;
    playOnce = false;
  }

  //Start het afspelen 
  boolean isPlaying() {
    return playing;
  }

  void draw() {
    int imageIndex = int(index);

    if (!center) {
      image(images[imageIndex][column], x, y);
    }
    if (center) {
      imageMode(CENTER);
      image(images[imageIndex][column], x, y);
      imageMode(CORNER);
    }
  }

  //Eerst run de update, deze neemt de positie in en bepaald welke image getekend moet worden
  void update(float x_, float y_) {
    this.x = x_;
    this.y = y_;
    

    setSpeed(fps);

    if (playing) {
      index += speed;

      if (index >= frames) {
        if (playOnce) {
          playing = false;
          index = frames - minusIndex;
        } else {
          index -= frames;
        }
      }
    }
  }
}

//Code credit Alex Tarnòki
class SoundAssets {

  //--ITEM SOUND EFFECTS-------------------------------------------------------------------------
  SoundFile item_coin, item_heart, item_cloak, item_shield, item_sparkler, item_bluepotion, item_boots;
  SoundFile item_expired, item_shield_broken;
  //--ENEMY SOUNDS EFFECTS-----------------------------------------------------------------------
  SoundFile enemy_hit, enemy_dies, enemy_footsteps;
  //--PLAYER SOUND EFFECTS-----------------------------------------------------------------------
  SoundFile player_hit, player_footsteps;
  //--BOMB SOUND EFFECTS-------------------------------------------------------------------------
  SoundFile bomb_placed, bomb_breaks_object;
  SoundFile bomb_c4_activated, bomb_c4_exploded;
  SoundFile bomb_dynamite_sizzles, bomb_dynamite_exploded;
  SoundFile bomb_landmine_triggered, bomb_landmine_exploded;
  //--MENU SOUND EFFECTS-------------------------------------------------------------------------
  SoundFile menu_hover, menu_select;
  //--BOSS SOUND EFFECTS-------------------------------------------------------------------------
  SoundFile mw_dies, mw_hit;
  SoundFile sq_dies, sq_hit;

  //All credits go to: https://freesound.org/people/Osiruswaltz 
  //Licensed under: CreativeCommons https://creativecommons.org/licenses/by/4.0/
  SoundFile ambient_track;

  //All credits go to: http://www.freesfx.co.uk 
  //Licensed under: https://www.freesfx.co.uk/Page/4/End-User-License-Agreement
  SoundFile main_menu;

  SoundFile game_track1;
  SoundFile game_track2;
  SoundFile game_track3;

  float FX_VOLUME, MUSIC_VOLUME, MAIN_VOLUME, ENTITY_VOLUME, AMBIENT_VOLUME;
  float UNNORMALISED_FX_VOLUME, UNNORMALISED_MUSIC_VOLUME, UNNORMALISED_ENTITY_VOLUME, UNNORMALISED_AMBIENT_VOLUME;

  //Laad all sounds van te voren in, neemt als argument de setup in van processing
  SoundAssets(PApplet setup) {

    //--ITEM SOUND EFFECTS-------------------------------------------------------------------------
    item_coin = new SoundFile(setup, "data/sound/item/coin.mp3");
    item_heart = new SoundFile(setup, "data/sound/item/heart.mp3");
    item_cloak = new SoundFile(setup, "data/sound/item/cloak.mp3");
    item_shield = new SoundFile(setup, "data/sound/item/shield.mp3");
    item_sparkler = new SoundFile(setup, "data/sound/item/sparkler.mp3");
    item_bluepotion = new SoundFile(setup, "data/sound/item/bluepotion.mp3");
    item_boots = new SoundFile(setup, "data/sound/item/boots.mp3");

    item_expired = new SoundFile(setup, "data/sound/item/itemexpired.mp3");
    item_shield_broken = new SoundFile(setup, "data/sound/item/shieldbroken.mp3");
    //--ENEMY SOUNDS EFFECTS-----------------------------------------------------------------------
    enemy_hit = new SoundFile(setup, "data/sound/enemy/hit.mp3");
    enemy_dies = new SoundFile(setup, "data/sound/enemy/dies.mp3");
    //--PLAYER SOUND EFFECTS-----------------------------------------------------------------------
    player_hit = new SoundFile(setup, "data/sound/player/hit.mp3");
    player_footsteps = new SoundFile(setup, "data/sound/player/footsteps.mp3");
    //--BOMB SOUND EFFECTS-------------------------------------------------------------------------
    bomb_placed = new SoundFile(setup, "data/sound/bomb/placed.mp3");
    bomb_breaks_object = new SoundFile(setup, "data/sound/bomb/breaksobject.mp3");

    bomb_c4_activated = new SoundFile(setup, "data/sound/bomb/c4/activated.mp3");
    bomb_c4_exploded = new SoundFile(setup, "data/sound/bomb/c4/exploded.mp3");

    bomb_dynamite_sizzles = new SoundFile(setup, "data/sound/bomb/dynamite/sizzles.mp3");
    bomb_dynamite_exploded = new SoundFile(setup, "data/sound/bomb/dynamite/exploded.mp3");

    bomb_landmine_triggered = new SoundFile(setup, "data/sound/bomb/landmine/triggered.mp3");
    bomb_landmine_exploded = new SoundFile(setup, "data/sound/bomb/landmine/exploded.mp3");
    //--MENU SOUND EFFECTS-------------------------------------------------------------------------
    menu_hover = new SoundFile(setup, "data/sound/menu/hover.mp3");
    menu_select = new SoundFile(setup, "data/sound/menu/select.mp3");
    //--BOSS SOUND EFFECTS-------------------------------------------------------------------------
    mw_dies = new SoundFile(setup, "data/sound/enemy/dies.mp3");
    mw_hit = new SoundFile(setup, "data/sound/enemy/hit.mp3");

    sq_dies = new SoundFile(setup, "data/sound/enemy/dies.mp3");
    sq_hit = new SoundFile(setup, "data/sound/enemy/hit.mp3");
    //---------------------------------------------------------------------------------------------

    main_menu = new SoundFile(setup, "data/sound/music/main menu.mp3");

    ambient_track = new SoundFile(setup, "data/sound/music/ambient track.wav");

    game_track1 = new SoundFile(setup, "data/sound/music/game track 1.mp3");
    game_track2 = new SoundFile(setup, "data/sound/music/game track 2.mp3");
    game_track3 = new SoundFile(setup, "data/sound/music/game track 3.mp3");
  }

  //Updates de volume amplitudes via de settingsMenu class en serverhandler class, en normaliseerd de waardes naar de main volume
  void update() {
    MAIN_VOLUME = settingsMenu.mainVolumeComponent.updateVolume();
    UNNORMALISED_FX_VOLUME = settingsMenu.fxVolumeComponent.updateVolume();
    UNNORMALISED_MUSIC_VOLUME = settingsMenu.musicVolumeComponent.updateVolume();
    UNNORMALISED_ENTITY_VOLUME = settingsMenu.entityVolumeComponent.updateVolume();
    UNNORMALISED_AMBIENT_VOLUME = settingsMenu.ambientVolumeComponent.updateVolume();

    serverHandler.updateSoundVol();

    FX_VOLUME = UNNORMALISED_FX_VOLUME * MAIN_VOLUME;
    MUSIC_VOLUME = UNNORMALISED_MUSIC_VOLUME * MAIN_VOLUME;
    ENTITY_VOLUME = UNNORMALISED_ENTITY_VOLUME * MAIN_VOLUME;
    AMBIENT_VOLUME = UNNORMALISED_AMBIENT_VOLUME * MAIN_VOLUME;
  }

  //ITEM SOUND EFFECTS--------------------------------
  void getCoinPickUp() 
  {
    item_coin.play(SOUND_RATE, FX_VOLUME);
  }
  void getHeartPickUp()
  {
    item_heart.play(SOUND_RATE, FX_VOLUME);
  }
  void getCloakPickUp()
  {
    item_cloak.play(SOUND_RATE, FX_VOLUME);
  }
  void getShieldPickUp() 
  {
    item_shield.play(SOUND_RATE, FX_VOLUME);
  }
  void getSparklerPickUp() 
  {
    item_sparkler.play(SOUND_RATE, FX_VOLUME);
  }
  void getBluePotionPickUp() 
  {
    item_bluepotion.play(SOUND_RATE, FX_VOLUME);
  }
  void getBootsPickUp() 
  {
    item_boots.play(SOUND_RATE, FX_VOLUME);
  }
  void getItemExpired() 
  {
    item_expired.play(SOUND_RATE, FX_VOLUME);
  }
  void getShieldBroken()
  {
    item_shield_broken.play(SOUND_RATE, FX_VOLUME);
  }

  //ENEMY SOUNDS EFFECTS----------------------------
  void getEnemyHit() 
  {
    enemy_hit.play(SOUND_RATE, ENTITY_VOLUME);
  }
  void getEnemyDies() 
  {
    enemy_dies.play(SOUND_RATE, ENTITY_VOLUME);
  }
  void getEnemyFootsteps() 
  {
    enemy_footsteps.play(SOUND_RATE, ENTITY_VOLUME);
  }

  //PLAYER SOUND EFFECTS----------------------------
  void getPlayerHit() 
  {
    player_hit.play(SOUND_RATE, ENTITY_VOLUME);
  }
  void getPlayerFootsteps() 
  {
    player_footsteps.play(SOUND_RATE, ENTITY_VOLUME - 0.5);
  }

  //BOMB SOUND EFFECTS------------------------------
  void getBombPlaced() 
  {
    bomb_placed.play(SOUND_RATE, FX_VOLUME);
  }
  void getBombBreaksObject() 
  {
    bomb_breaks_object.play(SOUND_RATE, FX_VOLUME);
  }
  void getC4Activated() 
  {
    bomb_c4_activated.play(SOUND_RATE, FX_VOLUME);
  }
  void getC4Exploded() 
  {
    bomb_c4_exploded.play(SOUND_RATE, FX_VOLUME);
  }
  void getDynamiteSizzles() 
  {
    bomb_dynamite_sizzles.play(SOUND_RATE, FX_VOLUME);
  }
  void getDynamiteExploded() 
  {
    bomb_dynamite_exploded.play(SOUND_RATE, FX_VOLUME);
  }
  void getLandmineTriggered() 
  {
    bomb_landmine_triggered.play(SOUND_RATE, FX_VOLUME);
  }
  void getLandmineExploded() 
  {
    bomb_landmine_exploded.play(SOUND_RATE, FX_VOLUME);
  }

  //MENU SOUND EFFECTS------------------------------
  void getMenuHover() 
  {
    menu_hover.play(SOUND_RATE, FX_VOLUME);
  }
  void getMenuSelect() 
  {
    menu_select.play(SOUND_RATE, FX_VOLUME);
  }

  //BOSS SOUND EFFECTS------------------------------
  void getBossMWDies()
  {
    mw_dies.play(SOUND_RATE, ENTITY_VOLUME);
  }
  void getBossMWHit()
  {
    mw_hit.play(SOUND_RATE, ENTITY_VOLUME);
  }

  void getBossSQDies()
  {
    sq_dies.play(SOUND_RATE, ENTITY_VOLUME);
  }
  void getBossSQHit()
  {
    sq_hit.play(SOUND_RATE, ENTITY_VOLUME);
  }
  //-----------------------------------------------


  //Code credit Winand Metz
  void getMainMenuMusic() {
    main_menu.play(1, MUSIC_VOLUME);
  }

  void stopMainMenuMusic() {
    main_menu.stop();
  }

  void getAmbientTrack() {
    ambient_track.play(SOUND_RATE, AMBIENT_VOLUME);
  }

  void stopGameMusicAmbient() {
    ambient_track.stop();

    if (game_track1.isPlaying()) {
      game_track1.stop();
    }
    if (game_track2.isPlaying()) {
      game_track2.stop();
    }
    if (game_track3.isPlaying()) {
      game_track3.stop();
    }
  }

  void getGameTrack() {
    int rand = (int)random(2);

    if (rand == 0) {
      game_track1.play(SOUND_RATE, MUSIC_VOLUME);
    }
    if (rand == 1) {
      game_track2.play(SOUND_RATE, MUSIC_VOLUME);
    }
    if (rand == 2) {
      game_track3.play(SOUND_RATE, MUSIC_VOLUME);
    }
  }
}
