package canvas.media;

import cpp.Int16;
import cpp.UInt32;
import cpp.UInt64;
import cpp.Helpers;
import cpp.Pointer;
import cpp.RawPointer;

import dr.MP3;
import dr.WAV;
import stb.Vorbis;

import al.AL;

import canvas.servers.AudioServer;
import canvas.utils.AssetCache.IDisposable;

// TODO: Add length field and audio streaming capabilities

/**
 * A simple audio buffer class including
 * file path and audio data.
 */
class AudioBuffer implements IDisposable {
	/**
	 * The length of this audio stream in seconds.
	 */
	public var length:Float = 0;

	/**
	 * The file path to the audio that this stream uses.
	 * 
	 * Blank if this stream wasn't loaded from a file.
	 */
	public var filePath:String = "";

	/**
	 * Makes a new `AudioBuffer` instance.
	 */
	public function new() {}

    /**
     * Returns an audio buffer from a given file path.
     * 
     * @param  filePath  The path to the audio to load.
     */
    public static function fromFile(filePath:String):AudioBuffer {
        final aud = new AudioBuffer();
        aud.filePath = filePath;
        aud.buffer = AudioServer.backend.createAudioBuffer();

        final ext:String = filePath.substring(filePath.lastIndexOf(".") + 1).toLowerCase();
        
        var format:Int = 0;
        var sampleData:RawPointer<Int16> = null;
        
        switch(ext) {
            case "wav":
                var channels:UInt32 = 0;
                var sampleRate:UInt32 = 0;
                var totalFrameCount:UInt64 = 0;
                sampleData = WAV.openFileAndReadPCMFramesShort16(filePath, channels, sampleRate, untyped __cpp__("(drmp3_uint64){0}", totalFrameCount), null);

                if(sampleData != null) {
                    aud.length = untyped __cpp__("(double)((drmp3_uint64){0} / {1})", totalFrameCount, sampleRate);
                    format = channels > 1 ? AL.FORMAT_STEREO16 : AL.FORMAT_MONO16;
                    AudioServer.backend.sendDataToBuffer(aud.buffer, format, cast sampleData, totalFrameCount, sampleRate);
                
                    if(sampleData != null)
                        WAV.free(cast sampleData, null);
                } else
                    Logs.trace('Audio file at ${filePath} failed to load: Sample data is null', ERROR);
        
            case "ogg":
                var channels:Int = 0;
                var sampleRate:Int = 0;
                var totalFrameCount:Int = Vorbis.decodeFileName(filePath, channels, sampleRate, cast sampleData);		
                
                if(sampleData != null) {
                    aud.length = untyped __cpp__("(double)((drmp3_uint64){0} / {1})", totalFrameCount, sampleRate);
                    format = channels > 1 ? AL.FORMAT_STEREO16 : AL.FORMAT_MONO16;
                    AudioServer.backend.sendDataToBuffer(aud.buffer, format, cast sampleData, untyped __cpp__("(drmp3_uint64){0}", totalFrameCount), sampleRate);
                    Helpers.free(sampleData);
                } else
                    Logs.trace('Audio file at ${filePath} failed to load: Sample data is null', ERROR);
                    
            case "mp3":
                var config:Pointer<DrMP3Config> = null;
                untyped __cpp__('
                    drmp3_config config_but_good;
                    {0} = &config_but_good;
                ', config);

                var totalFrameCount:DrMP3UInt64 = 0;
                sampleData = MP3.openFileAndReadPCMFramesShort16(filePath, config, untyped __cpp__("(drmp3_uint64){0}", totalFrameCount), null);
        
                if(sampleData != null) {
                    aud.length = untyped __cpp__("(double)((drmp3_uint64){0} / {1})", totalFrameCount, config.ref.sampleRate);
                    format = config.ref.channels > 1 ? AL.FORMAT_STEREO16 : AL.FORMAT_MONO16;
                    AudioServer.backend.sendDataToBuffer(aud.buffer, format, cast sampleData, untyped __cpp__("(drmp3_uint64){0}", totalFrameCount), config.ref.sampleRate);
                    MP3.free(sampleData, null);
                } else
                    Logs.trace('Audio file at ${filePath} failed to load: Sample data is null', ERROR);
        }
        return aud;
    }

	/**
	 * Disposes of this audio buffer and removes it's
	 * properties from memory.
	 */
    public function dispose():Void {
		if(buffer != null)
			AudioServer.backend.disposeAudioBuffer(buffer);
	}
    
    // --------------- //
    // [ Private API ] //
    // --------------- //
    
    private var buffer:IAudioBufferData = null;
}