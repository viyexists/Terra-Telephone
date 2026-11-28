# Subareas
Subareas are areas, that are sub, of an area (level).

## TODOs
- `EntryArea` `exit_to_root` to exit all the way to the level from within a subarea

These `TODO`s are listed within `res://features/levels/entryArea.gd` as well. If you've completed any of them, please update the comments accordingly.

## Setting up a subarea

### First: Do I need a subarea?
Probably not. You would probably do fine with teleporting the player to a different part of the map. But subareas exist if you ever want to use them and it does keep enemies isolated to the subarea. Enemies can walk right through walls (they literally spawn outside walls) so if this is an issue for you, you can use a subarea.

## Actually setting up a subarea (if you really needed one)
Subareas require three things to work properly:
- The subarea's `.tscn` scene (with a player)
- One EntryArea `isExit = false` anywhere (in a level or another subarea)
- One EntryArea `isExit = true` within the subarea (to be able to exit the subarea)

Subareas work Last In First Out, so all subareas **must** have an exit, otherwise the player will never be able to leave. (You CAN use subareas if you would like to trap the player in a room full of enemies, as long as the player can die/know they're stuck)
You can add in another function `exit_to_root` into `global.gd` to add in the functionality to exit to the first return position pushed to the return position array,
but that is your job. Because I have ran out of time to add it.
If you do add one, remember to free the rest of the array as well, otherwise it will screw with subareas in a different level.

&nbsp;1. Add a `.tscn` with a root node type `Subarea` to `res://features/levels/subareas/`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subareas are not strict on names, <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;but it is encouraged to prefix your subarea with your level <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(0 - indexed, what's visible in the code, not in the level selector).<br>
&nbsp;2. Add an `EntryArea` from the file explorer `res://features/levels/subareas/EntryArea.tscn` to the level/subarea<br>
&nbsp;3. As a child of the EntryArea, add in a `CollisionShape2D` or a `CollisionPolygon2D` and set up its `Shape`<br>
&nbsp;4. Add in a `Player`, and move it to where the player will spawn <br>
&nbsp;5. Assign the `Player` as the `Player` in the inspector of the root node of the `Subarea`<br>
&nbsp;6. Drag in the `Subarea` `.tscn` from step 1 into "`Area`" on the `EntryArea`<br>
&nbsp;7. Add in an area name, it will be displayed as "`[E] Enter <NAME>`"<br>
&nbsp;8. Within the subarea you made in step 1, add an `EntryArea`<br>
&nbsp;9. As a child of the EntryArea, add in a `CollisionShape2D` or a `CollisionPolygon2D` and set up its `Shape`<br>
&nbsp;10. Tick "`IsExit`" on the `EntryArea`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Because of how subareas work, this will automatically return the player to where they came from.<br>

## `Subarea`s
`Subarea`s are just glorified `Node2D`s. All they do is have that checkbox with `supports_radiation` and `Global.current_stage_node` setup.

`Subarea`s are different from `Level`s in that it does not set `seeds_this_stage` or reset `seeds_collected` to 0.

`Subarea`s need a `Player` node inside and assigned, since it's a completely new scene. Otherwise, it acts mostly like a normal level. Collecting seeds and coins within a subarea adds to the `Global` counter like the level, and seed count works properly within them.

## `EntryArea`s
`EntryArea`s are what's used to enter into a subarea or exit out of a subarea. Zones that the player entered are pushed to the `Global.return_position` array. Entrances will push a return position to the array, and exits will load the last return position from the array. Subarea scenes are not freed until the level is finished for persistence, and if the player enters the subarea again, the last state they left the subarea in is what they spawn into.

A return position includes the scene it came from, the player's position, its subareas, and if it's inside (used to free when exiting subareas).