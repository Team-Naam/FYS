class ServerHandler {
  MySQLConnection myConnection;

  ServerHandler() {
    myConnection = new MySQLConnection("verheur6", "od93cCRbyqVu5R1M", "jdbc:mysql://oege.ie.hva.nl/zverheur6");

    setID(USERNAME, PASSWORD);
  }

  /* Code credit Winand Metz
   Set de ID van de speler voor gebruik in online functionaliteit
   ID 0 is gast speler zonder account */
  void setID(String userName_, String passWord_) {
    String userName = userName_;
    String passWord = passWord_;

    userID = userId(userName, passWord);

    if (userID == 0) {
      playAsGuest = true;
    } else {
      playAsGuest = false;
    }
  }

  /* Tijdelijke user account creation method
   Neemt een username en password in en voegt dit toe aan de database 
   PlayerID wordt door de database gehandlet
   Er zit nog geen duplication protection voor accounts met zelfde naam in */
  void temporaryUserCreation(String userName, String userPassword) {
    String addUser = "INSERT INTO User(userName, userPassword) VALUES("+ userName +", "+ userPassword +"); INSERT INTO Settings(idUser) VALUES(LAST_INSERT_ID()); INSERT INTO Player_Statistics(idUser) VALUES(LAST_INSERT_ID());";
    myConnection.updateQuery(addUser);
  }

  /* Tijdelijke user account deletion method 
   Zet eerst de userID op 0 voor guest account
   Neemt de username en password in en delete alle gerelateerde entries uit de database */
  void temporaryUserDeletion(String userName, String userPassword) {
    setID("'&'", "'$'");

    String deleteUser = "DELETE FROM User WHERE userName = "+ userName +" AND userPassword = "+ userPassword +"; ";
    myConnection.updateQuery(deleteUser);
  }

  //Geeft de userID bij een succesvolle login, anders wordt automatisch een guest account gereturned
  int userId(String userName, String userPassword) {
    Table idTable = getUserId(userName, userPassword);

    if (idTable.getRowCount() > 0) {
      return idTable.getInt(0, 0);
    } else {
      return 0;
    }
  }

  //Haalt de userID uit de database met username en password
  Table getUserId(String userName, String userPassword) {
    String getUserId = "SELECT * FROM User WHERE userName = " + userName + " AND userPassword = "+ userPassword +"; ";

    return myConnection.runQuery(getUserId);
  }

  //code credit Jordy
  void updateHighscores(int score) {
    //temp userId word de userId van de ingelogde user
    //int userId = 10;
    //de query
    String addScore = "INSERT INTO `Highscore`(`idUser`, `score`) VALUES ("+ userID + "," + score + ")";
    myConnection.updateQuery(addScore);
  }

  Table getTopHighscores(int highscoreTableLimit) {
    //de query
    String selectScore = "SELECT userName, score FROM Highscore h INNER JOIN User u ON h.idUser = u.idUser ORDER BY `score` DESC LIMIT " + highscoreTableLimit;

    return myConnection.runQuery(selectScore);
  }

  Table getTopPlayers(int highscoreTableLimit) {
    //de query
    String selectScore = "SELECT userName, MAX(score) FROM Highscore h INNER JOIN User u ON h.idUser = u.idUser GROUP BY userName  ORDER BY MAX(score) DESC LIMIT " + highscoreTableLimit;

    return myConnection.runQuery(selectScore);
  }

  Table getTopHighscoresUser(int highscoreTableLimit) {
    //temp userId word de userId van de ingelogde user
    //int userId = 10;
    //de query
    String selectScore = "SELECT userName, score FROM Highscore h INNER JOIN User u ON h.idUser = u.idUser WHERE h.idUser = " + userID + " ORDER BY score DESC LIMIT " + highscoreTableLimit;

    return myConnection.runQuery(selectScore);
  }

  /* Code credit Winand Metz
   Updates de volume waardes in de database */
  void updateSoundVol() {
    String updateVolumes = "UPDATE Settings s INNER JOIN User u ON s.idUser = u.idUser SET main_volume = " + soundAssets.MAIN_VOLUME + ", ambient_volume = " + soundAssets.UNNORMALISED_AMBIENT_VOLUME + ", music_volume = " + soundAssets.UNNORMALISED_MUSIC_VOLUME + ", entity_volume = " + soundAssets.UNNORMALISED_ENTITY_VOLUME + ", fx_volume = " + soundAssets.UNNORMALISED_FX_VOLUME + " WHERE s.idUser = " + userID + "; ";
    myConnection.updateQuery(updateVolumes);
  }

  //Neemt de correcte volume waardes uit de volumes table, tenzij de speler als gast speelt, dan worden de standaard volumes doorgegeven
  void getSoundVol() {
    Table volumes = getVolumes();

    if (playAsGuest) {
      soundAssets.MAIN_VOLUME = 0.75;
      soundAssets.UNNORMALISED_AMBIENT_VOLUME = 0.75;
      soundAssets.UNNORMALISED_ENTITY_VOLUME = 0.75;
      soundAssets.UNNORMALISED_FX_VOLUME = 0.75;
      soundAssets.UNNORMALISED_MUSIC_VOLUME = 0.75;
    } else {
      soundAssets.MAIN_VOLUME = volumes.getFloat(0, "main_volume");
      soundAssets.UNNORMALISED_AMBIENT_VOLUME = volumes.getFloat(0, "ambient_volume");
      soundAssets.UNNORMALISED_ENTITY_VOLUME = volumes.getFloat(0, "entity_volume");
      soundAssets.UNNORMALISED_FX_VOLUME = volumes.getFloat(0, "fx_volume");
      soundAssets.UNNORMALISED_MUSIC_VOLUME = volumes.getFloat(0, "music_volume");
    }
  }

  //Laad de volume waardes in 
  Table getVolumes() {
    String selectVolumes = "SELECT * FROM Settings s INNER JOIN User u ON s.idUser = u.idUser WHERE s.idUser = " + userID + "; ";

    return myConnection.runQuery(selectVolumes);
  }
}
