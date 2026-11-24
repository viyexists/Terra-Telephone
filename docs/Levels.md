> Note : You don't have to follow this, but it probably would be cleaner for others if you did
> Please update this if you change any functionality

# Creating a new level
Levels are stored in the `features/levels` folder. They are currently numbered starting from 1, eg. `1.tscn` , `2.tscn` and so on. Feel free to name your files whatever you want.

I have created a node class named `Level`. To create a new level, you can create a new scene and set the base node as a `Level` node. It already has a script that contains various common systems (day/night cycle, stage ending, etc). You need to add a `Base` scene (this is the actual ingame base/ratticus's air balloon) as well as the player. You can drag and drop from the file system on the bottom left. After doing that, click on the `Level` node and open it in the inspector. On the right side, you should see inputs for `Base` and `Player`. Click on these inputs and select the corresponding nodes that you just placed.

Remember to add your new level to the Global script file. It should be located at `res://features/global.gd`
You need to append your level to the `levels` variable, in the format `{"name": "NAME", "path": "res://features/levels/LEVEL.tscn", "unlocked": false}` (or true if you want it to be unlocked for some reason)

`"NAME"` - whatever you want your level to be called. This is shown to the player in level selection so remember to captilise or have the correct formatting. 

`"res://features/levels/LEVEL.tscn"` - the internal file path to your level scene. Located in `res://features/levels/`.

`unlocked?` - specifies wheter a player has unlocked this level. default should be `false` (unless youre making a tutorial) 

The order in which the levels appear in this array determines their order in the level selection and future gameplay. The tutorial should alwyas be at the top, since it is the first stage a player should play.


To playtest your levels faster, go the the LevelSelect scene and tick the `Bypass Level Lock` property. Make sure to reset it when exporting for production.

^ Lemion: HII! If you don't do this i will burn down your github release and add in fixed binaries. Remember, I am always watching!