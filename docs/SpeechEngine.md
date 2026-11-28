# Setting up speech bubbles
## Lazy people method:
&nbsp;1. Go to `base.tscn`<br>
&nbsp;2. Select Control looking node "`SpeechEngine`"<br>
&nbsp;3. Right Click (The `SpeechEngine` node) > Copy<br>
&nbsp;4. Go to your scene<br>
&nbsp;6. Right Click (Scene Explorer) > Paste<br>

## "Proper" method:
There is no benefit to using the proper method this is just docs.

&nbsp;1. Add a new `SpeechEngine` node<br>
&nbsp;2. Add a new `AudioStreamPlayer2D` node<br>
&nbsp;3. optional: add a new bus in the Audio editor (at the bottom)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.1. Add a PitchShift effect to the bus<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.2. Configure the `AudioStreamPlayer2D`'s pitch and fix the speed with the PitchShift effect<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.3. set the `AudioStreamPlayer2D`'s bus to the new bus<br>
&nbsp;4. Drag the `AudioStreamPlayer2D` from the Scene explorer to the field labeled "Audio" in the `Control` node

# Using the speech engine
This section assumes you have the `SpeechEngine` node referenced as "SpeechEngine" in your script

## SpeechEngine.Say
`SpeechEngine.say(Message: String, Interrupt_Previous_Message: bool)`

Says a defined message (the fields describe themselves)