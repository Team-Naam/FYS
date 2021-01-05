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


  //code credit Ruben

  //opvragen van alle unlocked achievements
  //Hij selecteert de naam en beschrijving van de achievement in de Achievement Table en daarnaast ook de datum uit de Achievement_has_User Table.
  //Hierna gaat hij 2 innerjoins doen om zo de tabellen te kunnen combineren en te kunnen lezen.
  //Bij de eerste INNER JOIN gebruik ik de idAchievement van de tabellen Achievement en Achievement_has_User.
  //Bij de tweede INNER JOIN gebruik ik de idUser van de tabellen User en Achievement_has_User.
  //Als laatste stuk plaats ik een WHERE waarbij hij controleert of de behaalde achievements bij die user hoort.
  //De volgende 3 Table functies zijn bijna hetzelfde.
  //Alleen bij de 2e Functie Order ik het op het achievementID en bij de 3e functie op de datum.
  //Alle functies werken en zijn getest van te voren in MYSQL workbench.

  Table getUnlocked() {
    String getUnlocked = "SELECT Achievement.achievementName, Achievement.achievementDescription, Achievement_has_User.dateAchieved FROM ((Achievement_has_User INNER JOIN Achievement ON Achievement.idAchievement =  Achievement_has_User.Achievement_idAchievement) INNER JOIN User ON Achievement_has_User.User_idUser = User.idUser) WHERE User.idUser =" + userID + ";";
    return myConnection.runQuery(getUnlocked);
  }

  //opvragen van alle unlocked achievements op ID order
  Table getUnlockedOrderedByID() {
    String getUnlockedOrderedByID = "SELECT Achievement.achievementName, Achievement.achievementDescription, Achievement_has_User.dateAchieved FROM ((Achievement_has_User INNER JOIN Achievement ON Achievement.idAchievement =  Achievement_has_User.Achievement_idAchievement) INNER JOIN User ON Achievement_has_User.User_idUser = User.idUser) WHERE User.idUser =" + userID + "ORDER BY Achievement_idAchievement ASC;";
    return myConnection.runQuery(getUnlockedOrderedByID);
  }

  //opvragen alle unlocked achievement op Date order
  Table getUnlockedOrderedByDate() {
    String getUnlockedOrderedByDate = "SELECT Achievement.achievementName, Achievement.achievementDescription, Achievement_has_User.dateAchieved FROM ((Achievement_has_User INNER JOIN Achievement ON Achievement.idAchievement =  Achievement_has_User.Achievement_idAchievement) INNER JOIN User ON Achievement_has_User.User_idUser = User.idUser) WHERE User.idUser =" + userID + "ORDER BY Achievement_has_User.dateAchieved DESC;";
    return myConnection.runQuery(getUnlockedOrderedByDate);
  }

  void updateAchievements(int kills, int money, int time) {
    // de dag, maand en jaar opslaan in die in een string opslaan.
    int d = day();
    int m = month();
    int y = year();
    String date = y+"-"+m+"-"+d;
    //met deze int kan je makkelijk de String aanpassen zonder in de String te zitten te werken, dus erbuiten.
    int achievementID;

    //De volgende 100 regels checkt of er een achievement behaald kan worden door een van de stats te bekijken. Als dit groen licht geeft gaat het het proberen in te voegen in de database. 
    //Hierbij maakt hij een tijdelijke table (dual) aan.
    //De logica hierachter is dat het de SELECT statements in een rij van data met de vereiste waardes genereert, maar alleen wanneer dit mogelijk is en de waardes niet al gevonden kunnen worden.
    //Wanneer dit kan worden de waardes in de echte database toegevoegd.
    //Deze String is getest en goedgekeurd in MYSQL workbench

    if (kills >= 1 && kills < 10) { //achievement 22 "First Blood"
      achievementID = 22;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (kills >= 10 && kills < 100) { //achievement 23 "Killing Spree"
      achievementID = 23;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (kills >= 100 && kills < 200) { //achievement 24 "Killing Frenzy"
      achievementID = 24;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (kills >= 200 && kills < 300) { //achievement 25 "Killtastic"
      achievementID = 25;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (kills >= 300) { //achievement 26 "Cleaning the Dungeon"
      achievementID = 26;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (time >= 10 && time < 20) { //achievement 28 "Just getting started"
      achievementID = 28;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }
    if (time >= 20 && time < 30) { //achievement 29 "Still going"
      achievementID = 29;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (time >= 30 && time < 60) { //achievement 30 "Maybe time for a break"
      achievementID = 30;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (time >= 60 && time < 120) { //achievement 31 "Time waster"
      achievementID = 31;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (time >= 120 && time < 300) { //achievement 32 "Dedicated"
      achievementID = 32;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (time >= 300) { //achievement 33 "Get a life"
      achievementID = 33;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (money >= 1 && money < 10) { //achievement 35  "Ooh shiny"
      achievementID = 35;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }
    if (money >= 10 && money < 20) { //achievement 36 "Pocket money"
      achievementID = 36;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (money >= 20 && money < 50) { //achievement 37 "Cash on hands"
      achievementID = 37;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (money >= 50 && money < 100) { //achievement 38 "Decent savings"
      achievementID = 38;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }

    if (money >= 100) { //achievement 39 "I'm rich!"
      achievementID = 39;
      String addAchievement = "INSERT INTO Achievement_has_User(Achievement_idAchievement, User_idUser, dateAchieved) SELECT " + achievementID +", " + userID + ", " + date + " FROM dual WHERE NOT EXISTS (SELECT * FROM Achievement_has_User WHERE Achievement_idAchievement = " + achievementID +" AND User_idUser = " + userID + ");";
      myConnection.updateQuery(addAchievement);
    }
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
