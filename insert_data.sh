#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # TEAMS TABLE

    # insert winners
    FIND_WINNER=$($PSQL "SELECT name FROM teams WHERE name='$WINNER' ")
    if [[ -z $FIND_WINNER ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      #then
      #  echo Inserted $WINNER, winner, into teams
      #fi 
    fi
    
    # insert opponents
    FIND_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT' ")
    if [[ -z $FIND_OPPONENT ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      #then
      #  echo Inserted $OPPONENT, opponent, into teams
      #fi
    fi
  
    # GOALS TABLE
    # get winner and opponent ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_GOALS_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS') ")
  fi
done