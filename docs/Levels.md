> Note : You don't have to follow this, but it probably would be cleaner for others if you did

# Creating a new level
Levels are stored in the `features/levels` folder. They are currently numbered starting from 1, eg. `1.tscn` , `2.tscn` and so on.

I have created a node class named `Level`. To create a new level, you can create a new scene and set the base node as a `Level` node. It already has a script that contains various common systems (day/night cycle, stage ending, etc). You need to add a `Base` scene (this is the actual ingame base/ratticus's air balloon) as well as the player. You can drag and drop from the file system on the bottom left. After doing that, click on the `Level` node and open it in the inspector. On the right side, you should see inputs for `Base` and `Player`. Click on these inputs and select the corresponding nodes that you just placed.