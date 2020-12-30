//Code credit Winand Metz

//Inladen en tijdelijk opslaan textures
class TextureAssets {

  //Array voor x en y positie in grid
  final PImage[][] sprites;
  final PImage[][] wallSprites;
  final PImage[][] itemsBombsUI;
  final PImage[][] menusUserInterface;
  final PImage[][] entities;
  final PImage[][] vasesAndBackpacks;
  //final PImage[][] corpses;
  final PImage[][] bWallSprites;
  //final PImage[][] rockSprites;
  final PImage[][] backgroundSprites;
  final PImage[][] backgroundOverlays;
  final PImage[][] explosion;
  final PImage logo;
  final PImage main_menu;


  //Class neemt filepaths in en de groote van de gridtegels
  TextureAssets(int tileSize) {
    logo = loadImage("data/text/logo_highres.png");
    main_menu = loadImage("data/text/ui/main menu.png");
    sprites = loadSprites("data/text/textures.png", tileSize);
    wallSprites = loadSprites("data/text/walls/walls_spritesheet.png", tileSize);
    itemsBombsUI = loadSprites("data/text/items/itemsBombsUI.png", 32);
    menusUserInterface = loadSprites("data/text/ui/menu_ui.png", tileSize);
    entities = loadSprites("data/text/entities/poltergeist_test_64.png", 64);
    bWallSprites = loadSprites("data/text/walls/broken_walls_spritesheet.png", tileSize);
    vasesAndBackpacks = loadSprites("data/text/objects/vases1.png", 64);
    backgroundSprites = loadSprites("data/text/floors/floors.png", tileSize);
    backgroundOverlays = loadSprites("data/text/floors/overlays.png", tileSize);
    explosion = loadSprites("data/text/effects/explosion.png", 256);
    //corpses = loadSprites("data/text/objects/", tileSize);
  }

  PImage getLogo() {
    return logo;
  }

  PImage getMenuBackground() {
    return main_menu;
  }

  PImage getBackground(int row, int column) {
    return backgroundSprites[row][column];
  }

  PImage getBackgroundOverlay(int row, int column) {
    return backgroundOverlays[row][column];
  }

  //PImage getCorpse(int row, int column) {
  //  return corpses[row][column];
  //}

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

class SpriteSheetAnim {

  PImage[][] images;

  float x, y, index, speed;
  int fps, column, frames;

  boolean playing, playOnce, center;

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

  void setFPS(int fps) {
    this.fps = fps;
  }

  void setSpeed(int fps) {
    speed = fps / (float)frameRate;
  }

  void setCenter() {
    center = true;
  }

  void playOnce() {
    index = 0;
    playOnce = true;
    playing = true;
  }

  void loop() {
    playing = true;
    playOnce = false;
  }

  void stop() {
    playing = false;
    playOnce = false;
  }

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

  void update(float x_, float y_) {
    this.x = x_;
    this.y = y_;

    setSpeed(fps);

    if (playing) {
      index += speed;

      if (index >= frames) {
        if (playOnce) {
          playing = false;
          index = frames - 1;
        } else {
          index -= frames;
        }
      }
    }
  }
}

class SoundAssets {
  //--ITEM SOUND EFFECTS-------------------------------------------------------------------------
  SoundFile item_coin, item_heart, item_cloak, item_shield, item_sparkler, item_bluepotion, item_boots;
  SoundFile item_bluepotion_expired, item_boots_expired, item_cloak_expired, item_sparkler_expired, item_shield_broken;
  //--ENEMY SOUNDS EFFECTS-----------------------------------------------------------------------
  SoundFile enemy_hit, enemy_dies, enemy_footsteps, enemy_noise;
  //--PLAYER SOUND EFFECTS-----------------------------------------------------------------------
  SoundFile player_hit, player_dies, player_footsteps;
  //--BOMB SOUND EFFECTS-------------------------------------------------------------------------
  SoundFile bomb_placed, bomb_breaks_object;
  SoundFile bomb_c4_activated, bomb_c4_exploded;
  SoundFile bomb_dynamite_sizzles, bomb_dynamite_exploded;
  SoundFile bomb_landmine_ready, bomb_landmine_triggered, bomb_landmine_exploded;
  //--MENU SOUND EFFECTS-------------------------------------------------------------------------
  SoundFile menu_hover, menu_select, menu_goback;
  //--BOSS SOUND EFFECTS-------------------------------------------------------------------------
  SoundFile mw_dies, mw_footsteps, mw_hit, mw_noise;
  SoundFile sq_dies, sq_footsteps, sq_hit, sq_noise;
  //---------------------------------------------------------------------------------------------
  Reverb roomRev;
  LowPass lowPass;

  final float room = 0.1;
  final float damp = 0;
  final float wet = 1;

  float rate, FX_VOLUME, MUSIC_VOLUME, MAIN_VOLUME, ENTITY_VOLUME, AMBIENT_VOLUME;
  float UNNORMALISED_FX_VOLUME, UNNORMALISED_MUSIC_VOLUME, UNNORMALISED_ENTITY_VOLUME, UNNORMALISED_AMBIENT_VOLUME;

  SoundAssets(PApplet setup) {

    //--ITEM SOUND EFFECTS-------------------------------------------------------------------------
    item_coin = new SoundFile(setup, "data/sound/item/coin.mp3");
    item_heart = new SoundFile(setup, "data/sound/item/heart.mp3");
    item_cloak = new SoundFile(setup, "data/sound/item/cloak.mp3");
    item_shield = new SoundFile(setup, "data/sound/item/shield.mp3");
    item_sparkler = new SoundFile(setup, "data/sound/item/sparkler.mp3");
    item_bluepotion = new SoundFile(setup, "data/sound/item/bluepotion.mp3");
    item_boots = new SoundFile(setup, "data/sound/item/boots.mp3");

    item_bluepotion_expired = new SoundFile(setup, "");
    item_boots_expired = new SoundFile(setup, "");
    item_cloak_expired = new SoundFile(setup, "");
    item_sparkler_expired = new SoundFile(setup, "");
    item_shield_broken = new SoundFile(setup, "");
    //--ENEMY SOUNDS EFFECTS-----------------------------------------------------------------------
    enemy_hit = new SoundFile(setup, "data/sound/enemy/hit.mp3");
    enemy_dies = new SoundFile(setup, "data/sound/enemy/dies.mp3");
    enemy_footsteps = new SoundFile(setup, "");
    enemy_noise = new SoundFile(setup, "");
    //--PLAYER SOUND EFFECTS-----------------------------------------------------------------------
    player_hit = new SoundFile(setup, "data/sound/player/hit.mp3");
    player_dies = new SoundFile(setup, "data/sound/player/dies.mp3");
    player_footsteps = new SoundFile(setup, "data/sound/player/footsteps.mp3");
    //--BOMB SOUND EFFECTS-------------------------------------------------------------------------
    bomb_placed = new SoundFile(setup, "data/sound/bomb/placed.mp3");
    bomb_breaks_object = new SoundFile(setup, "data/sound/bomb/breaksobject.mp3");

    bomb_c4_activated = new SoundFile(setup, "data/sound/bomb");
    bomb_c4_exploded = new SoundFile(setup, "data/sound/bomb/c4/exploded.mp3");

    bomb_dynamite_sizzles = new SoundFile(setup, "data/sound/bomb/dynamite");
    bomb_dynamite_exploded = new SoundFile(setup, "data/sound/bomb/dynamite/exploded.mp3");

    bomb_landmine_ready = new SoundFile(setup, "data/sound/bomb");
    bomb_landmine_triggered = new SoundFile(setup, "data/sound/bomb");
    bomb_landmine_exploded = new SoundFile(setup, "data/sound/bomb/landmine/exploded");
    //--MENU SOUND EFFECTS-------------------------------------------------------------------------
    menu_hover = new SoundFile(setup, "data/sound/menu/hover.mp3");
    menu_select = new SoundFile(setup, "data/sound/menu/select.mp3");
    menu_goback = new SoundFile(setup, "");
    //--BOSS SOUND EFFECTS-------------------------------------------------------------------------
    mw_dies = new SoundFile(setup, "");
    mw_footsteps = new SoundFile(setup, "");
    mw_hit = new SoundFile(setup, "");
    mw_noise = new SoundFile(setup, "");

    sq_dies = new SoundFile(setup, "");
    sq_footsteps = new SoundFile(setup, "");
    sq_hit = new SoundFile(setup, "");
    sq_noise = new SoundFile(setup, "");
    //---------------------------------------------------------------------------------------------

    roomRev = new Reverb(setup);
    lowPass = new LowPass(setup);

    roomRev.set(room, damp, wet);
    lowPass.freq(500);

    rate = 1;
  }

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
    item_coin.play(1, FX_VOLUME);
  }
  void getHeartPickUp()
  {
    item_heart.play(1, FX_VOLUME);
  }
  void getCloakPickUp()
  {
    item_cloak.play(1, FX_VOLUME);
  }
  void getShieldPickUp() 
  {
    item_shield.play(1, FX_VOLUME);
  }
  void getSparklerPickUp() 
  {
    item_sparkler.play(1, FX_VOLUME);
  }
  void getBluePotionPickUp() 
  {
    item_bluepotion.play(1, FX_VOLUME);
  }
  void getBootsPickUp() 
  {
    item_boots.play(1, FX_VOLUME);
  }
  void getCloakExpired() 
  {
    item_cloak_expired.play(1, FX_VOLUME);
  }
  void getSparklerExpired() 
  {
    item_sparkler_expired.play(1, FX_VOLUME);
  }
  void getBluePotionExpired() 
  {
    item_bluepotion_expired.play(1, FX_VOLUME);
  }
  void getBootsExpired() 
  {
    item_boots_expired.play(1, FX_VOLUME);
  }
  void getShieldBroken()
  {
    item_shield_broken.play(1, FX_VOLUME);
  }

  //ENEMY SOUNDS EFFECTS----------------------------
  void getEnemyHit() 
  {
    enemy_hit.play(1, FX_VOLUME);
  }
  void getEnemyDies() 
  {
    enemy_dies.play(1, FX_VOLUME);
  }
  void getEnemyFootsteps() 
  {
    enemy_footsteps.play(1, FX_VOLUME);
  }
  void getEnemyNoise() 
  {
    enemy_noise.play(1, FX_VOLUME);
  }

  //PLAYER SOUND EFFECTS----------------------------
  void getPlayerHit() 
  {
    player_hit.play(1, FX_VOLUME);
  }
  void getPlayerDies() 
  {
    player_dies.play(1, FX_VOLUME);
  }
  void getPlayerFootsteps() 
  {
    player_footsteps.play(1, FX_VOLUME - 0.5);
  }

  //BOMB SOUND EFFECTS------------------------------
  void getBombPlaced() 
  {
    bomb_placed.play(1, FX_VOLUME);
  }
  void getBombBreaksObject() 
  {
    bomb_breaks_object.play(1, FX_VOLUME);
  }
  void getC4Activated() 
  {
    bomb_c4_activated.play(1, FX_VOLUME);
  }
  void getC4Exploded() 
  {
    bomb_c4_exploded.play(1, FX_VOLUME);
  }
  void getDynamiteSizzles() 
  {
    bomb_dynamite_sizzles.play(1, FX_VOLUME);
  }
  void getDynamiteExploded() 
  {
    bomb_dynamite_exploded.play(1, FX_VOLUME);
  }
  void getLandmineReady() 
  {
    bomb_landmine_ready.play(1, FX_VOLUME);
  }
  void getLandmineTriggered() 
  {
    bomb_landmine_triggered.play(1, FX_VOLUME);
  }
  void getLandmineExploded() 
  {
    bomb_landmine_exploded.play(1, FX_VOLUME);
  }
  //MENU SOUND EFFECTS------------------------------
  void getMenuHover() 
  {
    menu_hover.play(1, FX_VOLUME);
  }
  void getMenuSelect() 
  {
    menu_select.play(1, FX_VOLUME);
  }
  void getMenuGoBack() 
  {
    menu_goback.play(1, FX_VOLUME);
  }
  //BOSS SOUND EFFECTS------------------------------
  void getBossMWDies()
  {
    mw_dies.play(1, FX_VOLUME);
  }
  void getBossMWFootsteps()
  {
    mw_footsteps.play(1, FX_VOLUME);
  }
  void getBossMWHit()
  {
    mw_hit.play(1, FX_VOLUME);
  }
  void getBossMWNoise()
  {
    mw_noise.play(1, FX_VOLUME);
  }

  void getBossSQDies()
  {
    sq_dies.play(1, FX_VOLUME);
  }
  void getBossSQFootsteps()
  {
    sq_footsteps.play(1, FX_VOLUME);
  }
  void getBossSQHit()
  {
    sq_hit.play(1, FX_VOLUME);
  }
  void getBossSQNoise()
  {
    sq_noise.play(1, FX_VOLUME);
  }
  //-----------------------------------------------
}
