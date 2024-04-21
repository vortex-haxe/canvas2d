<img src="github/logo.png" align="right" width="128" height="128" />

# Canvas2D 
The core backend library used to power Vortex, designed to abstract lower level
parts of an application/game engine into friendlier classes/functions.

It also allows you to setup projects easier with `config.xml` files!
These files configure things such as window title, framerate, etc.

You can look at the wiki to find out what these files do or
look at the sample provided in the main source folder!

If you setup a project this way, you can build your app with the following command:
```bat
haxelib run canvas2d test
```
It's that simple!

## 🖥 Platforms
Canvas2D can natively compile to the following platforms via `hxcpp`:

- <img src="https://upload.wikimedia.org/wikipedia/commons/5/5f/Windows_logo_-_2012.svg" width="14" height="14" /> **Windows 8.0+**
- <img src="https://upload.wikimedia.org/wikipedia/commons/1/1b/Apple_logo_grey.svg" width="12" height="14" /> **macOS Ventura+**
- <img src="https://upload.wikimedia.org/wikipedia/commons/3/35/Tux.svg" width="14" height="14" /> **Linux** (Ubuntu, Debian, Fedora, openSUSE, Arch)

## 🧱 Libraries
Canvas2D uses a few other libraries to work, such as:

- <img src="https://upload.wikimedia.org/wikipedia/commons/1/16/Simple_DirectMedia_Layer%2C_Logo.svg" width="24" height="14" /> **[hxsdl](https://github.com/swordcube/hxsdl)**
  - 🪟 Spawns the main game window
  - 🖱️ Handles input for keyboard, mouse and controllers.

- 🖼️ **[hxstb_image](https://github.com/swordcube/hxstb_image)**
  - 🖥 Responsible for loading the data of `PNG`, `JPG`, `BMP`, and `HDR` files

- <img src="https://upload.wikimedia.org/wikipedia/commons/e/e9/Opengl-logo.svg" width="24" height="14" /> **[hxglad](https://github.com/swordcube/hxglad)**
  - 🖼️ Renders textures to the game window
  - 📷 Allows shaders to be applied to textures

- 🎵 **[hxdr_mp3](https://github.com/swordcube/hxdr_mp3)**
  - 🖥 Responsible for loading the data of MP3 files

- 🎵 **[hxdr_wav](https://github.com/swordcube/hxdr_wav)**
  - 🖥 Responsible for loading the data of WAV files

- 🎵 **[hxstb_vorbis](https://github.com/swordcube/hxstb_vorbis)**
  - 🖥 Responsible for loading the data of OGG files

- <img src="https://upload.wikimedia.org/wikipedia/en/thumb/1/1f/OpenAL_logo.svg/1280px-OpenAL_logo.svg.png" width="30" height="14" /> **[hxal](https://github.com/swordcube/hxal)**
  - 🔊 Responsible for playing back the data of compatible audio files
