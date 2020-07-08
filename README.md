# Godot Utility Scripts
 Various and sundry scripts to do things in Godot 


## audio_mixer.gd
Plays BGM music nicely. Godot does not have built-in fade-in or -out support for the AudioStream node.

*License*
Feel free to use it anywhere and everywhere. If you feel like crediting, go for it. If not, no biggie.

*To use:* 
1. Create a new scene in Godot using default Node type
2. Name the scene whatever you like (e.g. audio_mixer)
3. Add two children to the parent node: AudioStreamer, Timer
4. (Optional, but recommended otherwise you must refactor script to update the $node calls to match default or custom names) Name the audio streamer "bgm_streamer" and the timer "bgm_timer"
5. Using the Attach Script action, point the script to audio_mixer.gd
6. Connect the timeout() signal on bgm_timer to the script
7. Adjust volume, fade, and delay ('seconds_btw_songs') variables to your liking
8. Save the scene, name it however you like
9. Go to Project > Project Settings > Autoload 
9. Set the path to point to your audio_mixer scene, name the node however

Now whenever you have a scene that needs to play background music, or switch from what's currently playing to its own music, you can call the global node and have it call play_song function, e.g.:

<pre><code>var my_song = load($path_to_song_file)
AudioMixer.play_song(my_song)
</code></pre>

The selected song will nicely fade-in, or if something is already playing it will switch over the music.

**Considerations**
* As is, if a song is already playing, and a new different song is queued through AudioMixer.play_song, it will cut the playing song immediately, then fade in the new song. This is due to the fact the game I'm making this for nearly instantly loads between scenes, and I didn't want the fadeout between menu music and in-game music to take place once the in-game scene had already loaded ;). **To disable this** simply comment out line 35 "hard_switch = true"
* As is, if left alone, the currently playing song will automatically fade out once it nears the end of the song, wait a couple of seconds, and then play the same song over again. This is intended to be useful for game menu music, as well as ingame BGM tracks that need to loop cleanly

**Possible Improvements**

With the project I designed this for, I don't really need to make the script much more complex for now, that said here are the ideas I have for it if I need to get more fine-grained control if the game complexity increases:
* Make looping adjustable in case a song is needed to play, but only once, in a given scene 
	* This could be avoided, by just adding a pause function and giving the scene its own AudioStream and script though
* Pause functionality
* Multi-track support (e.g. bgm + ambience)
* Make hard-switching optional thru code variables and functions (if BGM needs to change nicely within the same scene, and not hard-cut between two scenes such as a Main Menu and Level scene
