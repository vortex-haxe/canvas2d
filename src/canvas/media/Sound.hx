package canvas.media;

import canvas.servers.AudioServer;
import canvas.utils.AssetCache.IDisposable;

/**
 * A class built for playing sound files.
 * 
 * Compatible formats are: `MP3`, `WAV`, and `OGG`.
 */
@:access(canvas.media.AudioBuffer)
class Sound implements IDisposable {
    /**
	 * The current time of the audio in seconds.
	 */
	public var time(get, set):Float;

	/**
	 * Whether or not the stream is playing.
	 */
	public var playing(get, set):Bool;

	/**
	 * Whether or not the stream is looping.
	 */
	public var looping(get, set):Bool;

	/**
	 * The gain/volume of this audio player.
	 * 
	 * This is a linear value from 0 to 1.
	 */
	public var gain(get, set):Float;

	/**
	 * The pitch of this audio player.
	 * 
	 * This is a linear value, 1 being default.
	 */
	public var pitch(get, set):Float;

    /**
     * Makes a new `Sound` instance.
     */
    public function new() {
        _source = AudioServer.backend.createAudioSource();
    }

    /**
	 * Plays the audio stream.
	 */
	public function play(fromTime:Float = 0.0):Void {
		playing = true;
		time = fromTime;
	}

	/**
	 * Resumes the audio stream.
	 */
	public function resume():Void {
		playing = true;
	}

	/**
	 * Pauses the audio stream.
	 */
	public function pause():Void {
		playing = false;
	}

    /**
	 * Stops the audio stream.
	 */
	public function stop():Void {
		AudioServer.backend.stopSourcePlaying(_source);
	}

    /**
     * Returns a new sound and loads an audio buffer
     * from a given file path into it.
     * 
     * @param  filePath  A file path to an audio file to load into this sound.
     */
    public static function fromFile(filePath:String):Sound {
        final snd:Sound = new Sound();
        snd._buffer = AudioBuffer.fromFile(filePath);
        return snd;
    }

    /**
	 * Disposes of this sound and removes it's
	 * properties from memory.
	 */
    public function dispose():Void {
        stop();

        if(_buffer != null)
            _buffer.dispose();

        if(_source != null)
            AudioServer.backend.disposeAudioSource(_source);
    }

    // --------------- //
	// [ Private API ] //
	// --------------- //

	private var _buffer(default, set):AudioBuffer;
	private var _source:IAudioSourceData;

    @:noCompletion
	private function get_time():Float {
		return AudioServer.backend.getSourceTime(_source);
	}

	@:noCompletion
	private function set_time(newTime:Float):Float {
		AudioServer.backend.setSourceTime(_source, newTime);
		return newTime;
	}

	@:noCompletion
	private function get_playing():Bool {
		return AudioServer.backend.getSourcePlaying(_source);
	}

	@:noCompletion
	private function set_playing(newPlaying:Bool):Bool {
		AudioServer.backend.setSourcePlaying(_source, newPlaying);
		return newPlaying;
	}

	@:noCompletion
	private function get_looping():Bool {
		return AudioServer.backend.getSourceLooping(_source);
	}

	@:noCompletion
	private function set_looping(newLooping:Bool):Bool {
		AudioServer.backend.setSourceLooping(_source, newLooping);
		return newLooping;
	}

	@:noCompletion
	private function get_gain():Float {
		return AudioServer.backend.getSourceGain(_source);
	}

	@:noCompletion
	private function set_gain(newGain:Float):Float {
		AudioServer.backend.setSourceGain(_source, Math.max(Math.min(newGain, 1), 0));
		return newGain;
	}

	@:noCompletion
	private function get_pitch():Float {
		return AudioServer.backend.getSourcePitch(_source);
	}

	@:noCompletion
	private function set_pitch(newPitch:Float):Float {
		AudioServer.backend.setSourcePitch(_source, newPitch);
		return newPitch;
	}

	@:noCompletion
	private inline function set__buffer(newBuffer:AudioBuffer):AudioBuffer {
		AudioServer.backend.sendBufferToSource(_source, newBuffer.buffer);
		return _buffer = newBuffer;
	}
}