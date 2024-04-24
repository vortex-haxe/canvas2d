package canvas.utils;

import canvas.graphics.Font;
import canvas.graphics.BitmapData;

import canvas.media.Sound;

/**
 * A utility class for loading/retrieving cached assets.
 */
class Assets {
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