# Magic

Do funny magic things that really shouldn't be possible

## TODOs
- Menu for switching magic between inventory and usable slots (slots [1, 2])
- Some indications that the player has recieved a spell from a grimoire
- MAYBE adding spells into heidi's shop

These `TODO`s are listed within `res://features/magic.gd` as well. If you've completed any of them, please update the comments accordingly.

## Setting up magic
Setting up magic is a little bit convoluted since the possibilities are endless, so this will be very high level and will explain nearly nothing.
1. Add in your spell into the spell registry in `res://features/magic.gd`
```
"Some Spell": {
		"icon": "res://assets/custom/SomeSpellIcon.png",
		"cooldown": 0.0, # seconds
		"unlocked": false, # false unless you want a default spell, in which case also set "slot" to 1 or 2
		"slot": 0, # default to 0 
		"function": SomeSpell, # callable
		"mana": 5 # how much mana is consumed when used
	}
```
2. Add in your function, also in `res://features/magic.gd`<br>
Here is a good base you can use which handles cooldowns and mana:
```
func SomeSpell():
    var spellName: String = "Some Spell"
    if not spells[spellName].unlocked: return
    if not is_instance_valid(spells[spellName].get("cooldownTimer")):
        var timer = Timer.new()
        timer.wait_time = spells[spellName]["cooldown"]
        timer.one_shot = true
        add_child(timer)
        spells[spellName]["cooldownTimer"] = timer
    if spells[spellName]["cooldownTimer"].is_stopped():
        if mana < spells[spellName].mana: return
        mana -= spells[spellName].mana * (1.0 - experience)
        mana_update.emit()
        spells[spellName]["cooldownTimer"].start()

        # Add in the rest of your spell here
```
3. Add a `Grimoire` into your scene (or any other scene) from the file explorer `res://features/interactables/grimoire.tscn` so the player can collect the spell
4. Assign the `Spell` field the name of the spell (if your spell is keyed as "Some Spell", you enter in "Some Spell")

## What can you do with magic?
Anything that fits into your function. Make sure to balance it with the mana cost tho otherwise it ruins it for everyone else.

## How do I reference the player?
`Global.player`

## How do I reference the level?
`Global.current_stage_node`

## Can I have other mechanics consume mana?
yes
```
Magic.mana -= CONSUMED_AMOUNT
mana_update.emit()
```