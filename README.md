> [!IMPORTANT]
> Canvas2D is being discontinued in favor of **zina.hx**, a simple graphics and audio API for Haxe.
> 
> It will be kept publicly archived for people who may still want to
> give Canvas2D a try, or atleast to look at it's code.
> 
> You can find zina.hx on this same organization [here](https://github.com/zina-framework/zina.hx)!

<img src="github/logo.png" align="right" width="128" height="128" />

# Canvas2D 
The core backend library used to power Vortex, designed to abstract lower level
parts of an application/game engine into friendlier classes/functions.

The library is meant to feel like **[lime](https://github.com/openfl/lime)** and **[openfl](https://github.com/openfl/openfl)** combined into one whole library, with fresh backends pulled away from Flash!

You setup your Canvas2D projects with `config.xml` files!
These files configure things such as window title, framerate, etc.

Refer to the wiki for an explanation on what `config.xml` files do.

Testing your project is as simple as one command:
```bat
haxelib run canvas2d test
```

> [!IMPORTANT]
> Canvas2D requires Haxe 4.3+ to compile, it will not work on anything below.

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
