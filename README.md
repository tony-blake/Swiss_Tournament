# Swiss_Tournament
Second Project of Udacity Full Stack ND

## Requriements
vagrant virtual machine with postgreSQL installed

The following files should be in this folder
```bash

----tournament.py        #file that contains the python functions which unit tests will run on
----tournament_test.py   #unit tests for tournament.py
----tournament.sql       #postgresql database

```

## To Run

Move up a level in the folder hierarchy (```cd ..```)  so that the following files and folder are present


```bash

--Swiss_Tournament             #folder containing tournament files
--Vagrantfile            #template that launches the Vagrant environment
--pg_config.sh           #shell script provisioner called by Vagrantfile that performs some configurations
```
 Then run the follwing commands

```bash

vagrant up    # boots up vagrant virtual box
vagrant ssh   # login to vagrant
cd /vagrant   # change to vagrant directory
cd Swiss_Tournament # change to project directory
psql # change to psql mode
DROP DATABASE IF EXISTS tournament;  # removes any exitsing database called "tournamnet
CREATE DATABASE tournament;
\c tournament # connects vagrant user to database
\q # change back to command line mode
```

Next run the following commands to begin swiss tournament

```bash
psql -U vagrant -d tournament -a -f tournament.sql
python tournament.py
python tournmanet_test.py
```

If the program excutes successfully the follwing lines will be outputted to screen

```bash
vagrant@vagrant-ubuntu-trusty-32:/vagrant/Swiss_Tournament$ python tournament.py
vagrant@vagrant-ubuntu-trusty-32:/vagrant/Swiss_Tournament$ python tournament_test.py
1. Old matches can be deleted.
2. Player records can be deleted.
3. After deleting, countPlayers() returns zero.
4. After registering a player, countPlayers() returns 1.
5. Players can be registered and deleted.
6. Newly registered players appear in the standings with no matches.
7. After a match, players have updated standings.
8. Byes are reported properly
10. Byes are assigned properly
11. After one match, players with one win are paired.
12. With odd number, last player should have bye.
13. Rematch avoided.
Success!  All tests pass!
```
