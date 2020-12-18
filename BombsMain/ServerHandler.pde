class ServerHandler {
  MySQLConnection myConnection;

  ServerHandler() {
    myConnection = new MySQLConnection("verheur6", "od93cCRbyqVu5R1M", "jdbc:mysql://oege.ie.hva.nl/zverheur6");
  }

  //code credit Jordy
  void updateHighscores(int score) {
    //temp userId word de userId van de ingelogde user
    int userId = 10;
    //de query
    String addScore = "INSERT INTO `Highscore`(`idUser`, `score`) VALUES ("+ userId + "," + score + ")";
    //myConnection.updateQuery(addScore);
  }

  Table getHighscores(int highscoreTableLimit) {
    //de query
    String selectScore = "SELECT userName, score FROM Highscore h INNER JOIN User u ON h.idUser = u.idUser ORDER BY `score` DESC LIMIT " + highscoreTableLimit;

    return myConnection.runQuery(selectScore);
  }

  void getSoundVol() {
    soundAssets.MAIN_VOLUME = 0.75;
    soundAssets.UNNORMALISED_AMBIENT_VOLUME = 0.75;
    soundAssets.UNNORMALISED_ENTITY_VOLUME = 0.75;
    soundAssets.UNNORMALISED_FX_VOLUME = 0.75;
    soundAssets.UNNORMALISED_MUSIC_VOLUME = 0.75;
  }
}
