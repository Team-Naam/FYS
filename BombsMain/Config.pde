//Code credit Winand Metz

//Game
final float MAP_SCROLL_SPEED = 1;
final float MAP_OFFSET = 0;
final int LEVEL_AMOUNT = 3;
final int FPS = 6;

//!NIET VERANDEREN!
final int TILE_SIZE = 128;
final int OBJECT_Y_OFFSET = 100;

//Graphics
final int FRAMERATE = 60;
final int FLOOR_SHADOW_STRENGTH = 230; //Normaliter ligt de waarde van deze en ENVIROMENT_SHADOW_STRENGHT dicht bij elkaar
final int ENVIROMENT_SHADOW_STRENGHT = 230;
final int RAY_DISTANCE = 500;

//Main Menu
final color MENU_BACKGROUND_COLOUR = #12173B;
final color BOX_BASIC_OUTER_COLOUR = #C51FBD;
final color BOX_BASIC_INNER_COLOUR = #271FC5;
final color BOX_HIGHLIGHTED_OUTER_COLOUR = #E4BB17;
final color BOX_HIGHLIGHTED_INNER_COLOUR = #ED270F;
final color BOX_TEXT_COLOUR = #FFFFFF;
final int MENUBOX_AMOUNT = 2;
final int MENU_MOVE_COOLDOWN = 10;

//HighScores
final int TIME_SCORE = 10;
final int TIME_SCORE_TIMER = 1;  //in sec

//Coin
final int COIN_SCORE = 100;

//Player
final int PLAYER_X_SPAWN = 256;
final int PLAYER_Y_SPAWN = 476;
final int PLAYER_HEALTH = 12;
final int PLAYER_SPEED = 4;
final int PLAYER_SHIELD = 0;
//!NIET VERANDEREN!
final int PLAYER_SIZE = TILE_SIZE / 2;

//Bombs
final int EXPLOSION_TIMER = 1200;
final int BOMB_START_OPACITY = 255;
final int EXPLOSION_START_OPACITY = 255;
final int EXPLOSION_START_RADIUS = 0;
final int BOMB_DAMAGE = 3;
final int BOMB_SIZE = 32;
final int BOMB_COOLDOWN_TIME = 60;

//Entities
final int PLAYER_DETECTION_DISTANCE = 400;
final int ENTITY_SIZE_DIVIDER = 2;
final float GHOST_SPAWN_CHANCE = 30;
final float POLTERGEIST_SPAWN_CHANCE = 7;
final float SPIDER_SPAWN_CHANCE = 50;
final float EXPLOSIVE_SPIDER_SPAWN_CHANCE = 10;
final float MUMMY_SPAWN_CHANCE = 40;
final float STONED_MUMMY_SPAWN_CHANCE = 13;

//Ghost
final int GHOST_HEALTH = 3;
final int GHOST_ATTACK = 3;
final int GHOST_ROAMING = 3000;
final int GHOST_MOVEMENT_SPEED = 2;

//Poltergeist
final int POLTERGEIST_HEALTH = 4;
final int POLTERGEIST_ATTACK = 3;
final int POLTERGEIST_ROAMING = 3000;
final int POLTERGEIST_MOVEMENT_SPEED = 2;

//Mummy
final int MUMMY_HEALTH = 8;
final int MUMMY_ATTACK = 4;
final int MUMMY_ROAMING = 2000;
final int MUMMY_MOVEMENT_SPEED = 1;

//SMummy
final int SMUMMY_HEALTH = 8;
final int SMUMMY_ATTACK = 4;
final int SMUMMY_ROAMING = 2000;
final int SMUMMY_MOVEMENT_SPEED = 1;
final int SMUMMY_SHIELD = 2;

//Spider
final int SPIDER_HEALTH = 1;
final int SPIDER_ATTACK = 1;
final int SPIDER_ROAMING = 1000;
final int SPIDER_MOVEMENT_SPEED = 3;

//ExplosiveSpider
final int EXPLOSIVE_SPIDER_HEALTH = 1;
final int EXPLOSIVE_SPIDER_ATTACK = 1;
final int EXPLOSIVE_SPIDER_ROAMING = 1000;
final int EXPLOSIVE_SPIDER_MOVEMENT_SPEED = 3;

//Items
final float BOOTS_DROP_CHANCE = 5;
final float SPARKLER_DROP_CHANCE = 4;
final float BLUE_POTION_DROP_CHANCE = 2;
final float SHIELD_DROP_CHANCE = 10;
final float CLOAK_DROP_CHANCE = 3;
final float HEART_DROP_CHANCE = 13;
final float COIN_DROP_CHANCE = 60;

//Power ups
final int SPEED_BONUS_TIME = 4000;
final int UNDEFEATBALE_BONUS_TIME = 2000;
final int CLOACK_BONUS_TIME = 3000;
final int BOMB_BONUS_TIME = 2000;
final int SHIELD_BONUS = 2;
final int SPEED_BONUS = 2;
