Delete the /data/ folder if it exists, extract the database primer zip into the current directory (not into a subdirectory).

Repeat step 1 when ever you want to reset everything or update to a new database primer version (with the server stopped ofcourse).

Double click on Run tgstation mariadb server.bat and press any key to start the database server.

In the game code, open config/dbconfig.txt, uncomment SQL_ENABLED and leave everything else the same keeping the default credentions.

You may now start the game server. You can confirm the database is connected by the player polls button on the lobby. If it is not working come to #coderbus for help but first try pressing the re-establish db connection button (in server or special verbs tab) to get a definitive error message.

You can shutdown the database server by pressing control + c in the server's black command window.

the root account has no password and the username:password@localhost account has feedback database permissions.

This is not a secure setup, do not use in production. 