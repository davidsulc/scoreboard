# Scoreboard

## Start the web server

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

## Setup a game

Navigate to [`localhost:4000/setup`](http://localhost:4000/setup) to configure the team names. You may also setup the current score, if you're starting to track it mid-game.

Select "invert scoreboard display" in case the scoreboard display visible by the crowd (displayed at [`localhost:4000`](http://localhost:4000)) is facing away from you.

Select "reflect team switches on scoreboard" so the score display will change sides at the same time as the team.

## Display the scoreboard for the crowd

Open [`localhost:4000`](http://localhost:4000) and display it on a large screen for the crowd to follow the game's score.

## Keep score

Open [`localhost:4000/scorekeeper`](http://localhost:4000/scorekeeper) to score the game. Once the teams have chosed their sides, make sure the team sides on the scoreboard match your view of the court: you can switch the teams' sides by clicking on the green button with arrows on it.

As the game progresses, click on `+` to award a point to a team or `-` to subtract a point (in case you made a mistake, or the referee goes back on their decision).

The scoreboard may also be controlled via the keyboard:

* `a`: increase score of the team on the left
* `A`: decrease score of the team on the left
* `l`: increase score of the team on the right
* `L`: decrease score of the team on the right
* `u`: switch team sides
