This is a github reposititory for a tank cruiser game I made in the summer of 2023. I was recently getting into game development at the time and had finished building a previous game: Circle Adventures from a tutorial.

For this game I wanted to set up a maintainable and modular system to allow me as the developer to add and develop more weapons and addons with ease. 

I wanted a module based system that could be expanded upon indefinetely which could be used interchangably with enemies and the player.

As this was my first attempt at such a system it didn't go exactly according to plan. I had succeeded in building an interchangable system, however I made my code rather unorganized and not sticking to conventions and rulings that I have established, leading to increasingly higher times it took to add the next new weapon or addon to the player's arsenal.

For future reference, I have learned to seperate my code even further. A major pitfall that I fell into was although I seperated my code into different functions they were all on the same script file. This ended up confusing me more than I needed to when trying to debug the code. An additional factor were the added dependencies to each child node of a weapon that I had made. Each child node has some unique dependency that was completely seperate from the tree that had its own unique factor. This could've been avoided entirely had my code been more robust and more throughly planned out beforehand but it resulted in my code being very stiff and unable to change due to all the potential errors most of those nodes would've caused had something been shifted out of place.



https://github.com/user-attachments/assets/6ec49ffc-b089-4cd0-a041-a6ae6a677e60

This is a demo playthrough of the game, showcasing the different weapons that the player has at their disposal as well as the different types of enemies and the level layouts.


**HOW TO PLAY**
___

Download and extract from the corresponding .zip files.

Currently available are the versions for MacOS and Windows.
