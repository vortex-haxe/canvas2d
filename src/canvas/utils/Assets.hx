package canvas.utils;

import canvas.graphics.Font;
import canvas.graphics.BitmapData;

import canvas.media.Sound;

/**
 * A utility class for loading/retrieving cached assets.
 */
class Assets {
    /**
     * Clears all cached assets from memory.
     */
    public static function clearCache():Void {
        for(cache in [bitmapCache, soundCache, fontCache])
            cache.dispose();
    }

    /**
     * Returns bitmap data from a specified file path.
     * 
     * @param  filePath  A file path of the image to load.
     */
    public static function getBitmapData(filePath:String):BitmapData {
        final key:String = '#__BITMAP__${filePath}';
        if(!bitmapCache.exists(filePath))
            bitmapCache.add(key, BitmapData.fromFile(filePath));

        return bitmapCache.get(key);
    }

    /**
     * Returns sound data from a specified file path.
     * 
     * @param  filePath  A file path of the sound to load.
     */
    public static function getSound(filePath:String):Sound {
        final key:String = '#__SOUND__${filePath}';
        if(!soundCache.exists(filePath))
            soundCache.add(key, Sound.fromFile(filePath));

        return soundCache.get(key);
    }

    /**
     * Returns font data from a specified file path.
     * 
     * @param  filePath  A file path of the font to load.
     */
    public static function getFont(filePath:String):Font {
        final key:String = '#__FONT__${filePath}';
        if(!fontCache.exists(filePath))
            fontCache.add(key, new Font(filePath));

        return fontCache.get(key);
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //
    
    private static var bitmapCache:AssetCache<BitmapData> = new AssetCache();
    private static var soundCache:AssetCache<Sound> = new AssetCache();
    private static var fontCache:AssetCache<Font> = new AssetCache();
}