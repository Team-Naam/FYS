//Code credit Winand Metz

//Temp login
final String USERNAME = "'winand'";
final String PASSWORD = "'fys20'";

//Game
final float MAP_SCROLL_SPEED = 1; // was 1
final float MAP_OFFSET = 0;
final int LEVEL_AMOUNT = 3;
final int FPS = 6;

//!NIET VERANDEREN!
final int TILE_SIZE = 128;
final int OBJECT_Y_OFFSET = 100;
final int ESC_SELECT_TIMER = 200;

//Graphics
final int FRAMERATE = 60;
final color BACKGROUND_COLOR = color(41, 29, 43);
final int FLOOR_SHADOW_STRENGTH = 230; //Normaliter ligt de waarde van deze en ENVIROMENT_SHADOW_STRENGHT dicht bij elkaar
final int ENVIROMENT_SHADOW_STRENGHT = 230;
final int RAY_DISTANCE = 500;
final int TEXT_RENDER_SIZE = 48;

//Main Menu
final color MENU_BACKGROUND_COLOUR = #12173B;
final color BOX_BASIC_OUTER_COLOUR = #C51FBD;
final color BOX_BASIC_INNER_COLOUR = #271FC5;
final color BOX_HIGHLIGHTED_OUTER_COLOUR = #E4BB17;
final color BOX_HIGHLIGHTED_INNER_COLOUR = #ED270F;
final color BOX_TEXT_COLOUR = #FFFFFF;
final int MENUBOX_AMOUNT = 5;
final int MENU_MOVE_COOLDOWN = 10;

//HighScores
final int TIME_SCORE = 10;
final int TIME_SCORE_TIMER = 1;
final int HIGHSCORE_TABLE_LIMIT = 10;

//Coin
final int COIN_SCORE = 100;

//Player
final int PLAYER_X_SPAWN = 256;
final int PLAYER_Y_SPAWN = 476; //was 476
final int PLAYER_HEALTH = 12; // was 12
final int PLAYER_SPEED = 4;
final int PLAYER_SHIELD = 0;
//!NIET VERANDEREN!
final int PLAYER_SIZE = TILE_SIZE / 2;

//Bombs
final int EXPLOSION_TIMER = 2000;
final int DYNAMITE_EXPLOSION_RADIUS = 275;
final int CFOUR_EXPLOSION_RADIUS = 200;
final int LANDMINE_EXPLOSION_RADIUS = 300;
final int SPIDER_EXPLOSION_RADIUS = 150;
final int EXPLOSION_STOP_TIMER = 50;
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

//MiniSpider
final int MINI_SPIDER_HEALTH = 1;
final int MINI_SPIDER_ATTACK = 0;
final int MINI_SPIDER_ROAMING = 1000;
final int MINI_SPIDER_MOVEMENT_SPEED = 3;
final float MINI_SPIDER_SLOW = 0.25;

//SpiderQueen
final int SPIDERQUEEN_HEALTH = 12;
final int SPIDERQUEEN_ATTACK = 1;
final int SPIDERQUEEN_MOVEMENT = 2;
final int ABILITY_TIMER = 10000; 
final int BIRTH_TIMER = 5000;
final int RECHARGE_TIMER = 5000;
final int SPIDER_SPAWN_TIME = 10000;
final int WEB_ATTACK_DELAY = 1000;
final int WEBATTACK_RADIUS = 50;
final float BULLET_SPEED = 8;
final int BULLET_DAMAGE = 2;

//Wall Boss
final int WALL_BOSS_HP = 20;
final int WALL_BOSS_VEL = 2;
final float WALL_BOSS_INNIT_SPLIT_VEL = .1;
final float WALL_BOSS_INNIT_SPLIT_DIST = 100;

final int WALL_BOSS_X_REST = 1920 - TILE_SIZE - 400;
final int WALL_BOSS_Y_REST = 1080 /2 - TILE_SIZE /2;
final int WALL_BOSS_X_LIMIT = 1700;

final int WALL_BOSS_BOX_TOP = 200;
final int WALL_BOSS_BOX_BOTTOM = 200;
final int WALL_BOSS_BOX_LEFT = 1005;
final int WALL_BOSS_BOX_RIGHT = 265;

final int WALL_BOSS_INIT_WAIT = 600;

final int WALL_BOSS_RETURN_VEL = 6;

final int SLAM_DMG = 1;
final int SLAM_SPLIT = 2500;
final int SLAM_STUN_TIME = 3 *FRAMERATE;

final int NO_ESCAPE_DMG = 3;
final int NO_ESCAPE_STUN_TIME = 2 *FRAMERATE;
final int NO_ESCAPE_SPAWN_TIME = 2 *FRAMERATE;
final int NO_ESCAPE_BWALLS_AMOUNT = 7;
final float NO_ESCAPE_VEL_MODIFIER = 0.75;

final int ROLLOUT_DMG = 2;
final int ROLLOUT_CHARGE_TIME = 2 *FRAMERATE;
final int ROLLOUT_VEL_MODIFIER = 2;
final int ROLLOUT_STUN_TIME = 3 *FRAMERATE;

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
