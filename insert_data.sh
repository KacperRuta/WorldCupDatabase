#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

games_file="games.csv"

echo $($PSQL "TRUNCATE TABLE games, teams")

while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  if [ "$year" == "year" ]; then
      continue
  fi

  echo $($PSQL "INSERT INTO teams(name) VALUES('$winner') ON CONFLICT (name) DO NOTHING")
  echo $($PSQL "INSERT INTO teams(name) VALUES('$opponent') ON CONFLICT (name) DO NOTHING")
  echo $($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($year,'$round',(SELECT team_id FROM teams WHERE name = '$winner'),(SELECT team_id FROM teams WHERE name = '$opponent'),$winner_goals,$opponent_goals)")

done < "$games_file"
