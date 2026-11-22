# Creating a new enemy
1. Create a new scene
2. Select Other Node, and search for `Enemy`. Use the Enemy node.
3. In the inspector (right side), change the enemy type to the name of your enemy (default: blargh)
4. Set the speed of the enemy, for reference the player is at default 5.5 speed
5. Knockback resistance is how fast the enemy recovers
6. The new enemy needs a collision shape, so add a new one and find one that best fits (usually a capsule shape)

## Adding a sprite
1. Add a new `Node2D` and name it `Sprite`
2. Add a `Sprite2D` node to `Sprite` and set the txture to the enemy texture.
3. You may need to scale the Sprite2D to make sure it fits with everything else. 
4. **DO NOT TRANSFORM THE `Sprite` NODE, ONLY THE `Sprite2D` NODE**

## Adding attacks
1. Add an `EnemyAttack` node to the root enemy node
2. Attach an empty script extending from `EnemyAttack`.
3. The most important thing to add is a `attack()` function to the script. This is what is called when the enemy decides to use this attack.
4. In the inspector, you can set the damage, cooldown and knockback, or you can set it through code. 
5. NOTE : ATTACK PARAMETERS SET THROUGH CODE OVERRIDE THE PARAMETERS FROM THE INSPECTOR

# For examples,
Check the *blargh.tscn* enemy for melee attacks
and *poobert.tscn* enemy for range attacks (projectile spawning, projectile movement, attack() function override)