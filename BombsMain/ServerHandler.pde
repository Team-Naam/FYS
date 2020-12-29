class ServerHandler {
  MySQLConnection myConnection;

  ServerHandler() {
    myConnection = new MySQLConnection("verheur6", "od93cCRbyqVu5R1M", "jdbc:mysql://oege.ie.hva.nl/zverheur6");

    setID();
  }

  void setID() {
    userID = userId(USERNAME, PASSWORD);

    if (userID == 0) {
      playAsGuest = true;
    } else {
      playAsGuest = false;
    }
  }

  void temporaryUserCreation(String userName, String userPassword) {
    String addUser = "INSERT INTO User(userName, userPassword) VALUES("+ userName +", "+ userPassword +"); INSERT INTO Settings(idUser) VALUES(LAST_INSERT_ID()); INSERT INTO Player_Statistics(idUser) VALUES(LAST_INSERT_ID());";
    myConnection.updateQuery(addUser);
  }

  int userId(String userName, String userPassword) {
    Table idTable = getUserId(userName, userPassword);

    if (idTable.getRowCount() > 0) {
      return idTable.getInt(0, 0);
    } else {
      return 0;
    }
  }

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

  void updateSoundVol() {
    String updateVolumes = "UPDATE Settings s INNER JOIN User u ON s.idUser = u.idUser SET main_volume = " + soundAssets.MAIN_VOLUME + ", ambient_volume = " + soundAssets.UNNORMALISED_AMBIENT_VOLUME + ", music_volume = " + soundAssets.UNNORMALISED_MUSIC_VOLUME + ", entity_volume = " + soundAssets.UNNORMALISED_ENTITY_VOLUME + ", fx_volume = " + soundAssets.UNNORMALISED_FX_VOLUME + " WHERE s.idUser = " + userID + "; ";
    myConnection.updateQuery(updateVolumes);
  }

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

  Table getVolumes() {
    String selectVolumes = "SELECT * FROM Settings s INNER JOIN User u ON s.idUser = u.idUser WHERE s.idUser = " + userID + "; ";

    return myConnection.runQuery(selectVolumes);
  }
}
