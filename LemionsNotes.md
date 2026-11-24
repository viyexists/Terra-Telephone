#  Lemion's notes for Telephone

hi folks it's lemion

`res://features/environment/obstacle.gd`:

Originally used to order Z index of elements, but I found that it was causing mountain to render funny (walking lower down y would shift the top mountain rendered) and godot already has this as `Y sort enabled` in the inspector of a node. Please use `Y sort enabled` instead of the script. It's still there if it's needed elsewhere.