#  Lemion's notes for Telephone

hi folks it's lemion

## What's about that Z level on the mountains?
Long ago, in a land far, far away there was a script, a script whose name was `obstacle.gd` who resided in `res://features/environment/` (still alive btw).

`obstacle.gd` handled Z levels on mountains and enemies and other stuff, but godot already has a built-in option for this `Y Sort Enabled` within the inspector of a `Node2D`.
I deprecated `obstacle.gd` and switched all old scenes to use Y sort, but it isn't perfect either, especially on static backgroudn components. 

For fixes on the mountain I suggest just turning off Y sort on the `Border` node and setting its Z level really high (like 200)
However, the enemies would still be broken. If you can, you should rewrite obstacle.gd to properly handle enemies and trees, since those depend on the player's Y location currently and can do some funny stuff (if an enemy is behind a tree and the player walks in front of that tree, the enemy now appears to be on the tree).

## Player UI, where is it?
Player UI is in its own scene `res://features/player/ui.tscn`, and is hidden on the player `res://features/player/player.tscn`. It took up quite a bit of screen when editing the level, so I hid it and added `$UI.visible = true` in `_ready()`