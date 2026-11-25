# Unit Tests
For tests, I decided to use Godot Unit Tests (GUT) just because it had more stars on the asset store and john recommended it.

## Running tests
&nbsp;1. click the `GUT` button at the bottom<br>
&nbsp;2. click the `Run All` button at the top left of the menu<br>

The parameters you see in the log (`param[0]`, `param[1]`) are likely which level it tested. If there's an error, it came from that level.

## Adding tests
While I do not expect anyone to add their own tests, this needs to exist so..

> Note: Test files must be prefixed with `test_`<br>
> and test functions  must be prefixed with `test_` as well

&nbsp;1. Add a new test .gd file into the `res://tests/` folder(or you can use one of the existing files)<br>
&nbsp;2. Extend `GutTest` instead of whatever it defaulted to<br>
&nbsp;3. Add in a new test function, e.g. `test_all()`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Note that tests only have to be prefixed with `test_`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Any name can come after it, like `test_enemies()` is a valid test GUT will run.<br>
&nbsp;4. Add in said tests into the test function<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Godot will autocomplete for you a bunch of functions after you type `assert_`.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Those are what GUT uses to determine the result of a test.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You can look at existing tests for roughly how to do this step.<br>
&nbsp;5. **TEST YOUR TEST**<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remember that tests are only effective if the test works.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you make a half baked test and hand it off to the next person, they WILL get confused when it fails.

## Current tests
### `test_cpu.gd`
Basically useless. Just tests if 0.3 != 0.03. If this fails, assume all tests after to be invalid (your CPU is faulty).

### `test_levels_finishable.gd`
Will teleport the player to every seed in found in the level, then teleport the player to ratticus's balloon, then waits two physics frames, then checks if `ended_stage` is true in `base.gd`. Your seed node HAS to be named "`Seeds`", but does not need to be a direct child of the root node.

If this test fails on your level:
- Is your Seeds node named `Seeds`?
- Does your level even contain seeds? (`test_seeds` should catch this)
- Is there anything in your level blocking `base.gd` from marking the level as finished

If you have checked all 3 already or the level is actually finishable, ignore it and leave comments for the next person.

### `test_seeds.gd`
This will test if the seed count in each level is above 0. This test will wait five frames for all seeds to run `Global.seeds_this_stage += 1` in `_ready()`

If this test fails on your level:
- Did you remember to put in any seeds?
- Try increasing the frame count on this test
- Did you make a change in `seed.gd` or `global.gd` that broke `seeds_this_stage`

If you have checked all 3 already or there are actually seeds and the level is finishable, ignore it and leave comments for the next person.

### `test_pausing.gd`
This will test if pausing works or not by checking if the pause screen initially exists (it shouldn't), then pressing escape and waiting one frame, then checking if the pause screen exists (it should), then pressing escape and waiting one frame, then checking if the pause screen doesn't exist (it shouldn't).

This test does not test the "Continue" button, only the escape key press.

If this test fails:
- Did you remove `pause_screen.tscn`?
- Did you break user input in `pause_screen.gd` (`_unhandled_input()`)

If you checked both items already or the pause menu is functional, ignore it and leave comments for the next person.

*Ideally* none of these tests should fail. If any tests failed you have done something terribly, horribly, disgustingly wrong.