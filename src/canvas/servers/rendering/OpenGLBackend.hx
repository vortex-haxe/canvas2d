package canvas.servers.rendering;

import cpp.RawConstPointer;
import cpp.ConstPointer;
import cpp.UInt32;
import cpp.Float32;
import cpp.Pointer;
import cpp.Helpers;
import cpp.RawPointer;
import cpp.UInt8;
import cpp.Star;
import cpp.ConstCharStar;

import sdl.SDL;
import glad.Glad;

import canvas.app.Application;
import canvas.ui.Window;

import canvas.math.Vector2;
import canvas.math.Vector2i;
import canvas.math.Vector3;
import canvas.math.Vector4;
import canvas.math.Rectangle;
import canvas.math.Rectanglei;
import canvas.math.Matrix4x4;

import canvas.graphics.Shader;
import canvas.graphics.Color;

import canvas.utils.IntBool;
import canvas.servers.RenderingServer;

class OpenGLTextureData implements ITextureData {
    public var texture:Any;
    
    public var size:Vector2i;
    public var channels:Int;
    public var mipmaps:Bool;
    public var wrapping:TextureWrapping;
    public var filter:TextureFilter;

    public function new(texture:UInt32, size:Vector2i, channels:Int, mipmaps:Bool, wrapping:TextureWrapping, filter:TextureFilter) {
        this.texture = texture;
        this.size = size;
        this.channels = channels;
        this.mipmaps = mipmaps;
        this.wrapping = wrapping;
        this.filter = filter;
    }
}

class OpenGLShaderData implements IShaderData {
    public var shader:Any;

    public function new(shader:UInt32) {
        this.shader = shader;
    }
}

@:access(canvas.graphics.Shader)
class OpenGLQuadRenderer implements IQuadRenderer {
    public final VERTICES:Array<Float32> = [
        // positions   // texture coords
        0.0,   1.0,    0.0,  0.0,    // top left
        0.0,   0.0,    0.0,  1.0,    // bottom left
        1.0,   0.0,    1.0,  1.0,    // bottom right
        1.0,   1.0,    1.0,  0.0     // top right 
    ];

    public final INDICES:Array<UInt32> = [
        // note that we start from 0!
        0, 1, 3, // first triangle
        1, 2, 3  // second triangle
    ];

    public var texture:ITextureData;
    public var shader:IShaderData;
    public var projection:Matrix4x4;

    // -------- //
    // Privates //
    // -------- //
    private var _trans:Matrix4x4;
    private var _vec2:Vector2;
    private var _vec3:Vector3;

    private var VAO:UInt32;
    private var VBO:UInt32;
    private var EBO:UInt32;

    private var window:Window;

    public function new(shader:IShaderData) {
        this.shader = shader;

        _trans = new Matrix4x4(1.0);
        _vec2 = new Vector2();
        _vec3 = new Vector3();

        Glad.genVertexArrays(1, Pointer.addressOf(VAO));
        Glad.bindVertexArray(VAO);

        Glad.genBuffers(1, Pointer.addressOf(VBO));
        Glad.bindBuffer(Glad.ARRAY_BUFFER, VBO);
        Glad.bufferFloatArray(Glad.ARRAY_BUFFER, VERTICES, Glad.STATIC_DRAW, 16);

        Glad.genBuffers(1, Pointer.addressOf(EBO));

        Glad.bindBuffer(Glad.ELEMENT_ARRAY_BUFFER, EBO);
        Glad.bufferIntArray(Glad.ELEMENT_ARRAY_BUFFER, INDICES, Glad.STATIC_DRAW, 6);

        Glad.vertexFloatAttrib(0, 4, Glad.FALSE, 4, 0);
        Glad.enableVertexAttribArray(0);

        // yeah
        window = Application.current.window;
        projection = Matrix4x4.ortho(0, window.initialSize.x, window.initialSize.y, 0, -1, 1);
    }

    public function drawColor(position:Vector2, size:Vector2, color:Color):Void {
        RenderingServer.backend.useShader(shader);

        Glad.bindVertexArray(VAO);

        _trans.reset(1.0);
        _trans.scale(_vec3.set(size.x, size.y, 1.0));
        _trans.translate(_vec3.set(position.x, position.y, 0.0));

        RenderingServer.backend.setUniformMat4x4(shader, "TRANSFORM", _trans);
        RenderingServer.backend.setUniformColor(shader, "MODULATE", color);

        Glad.drawElements(Glad.TRIANGLES, 6, Glad.UNSIGNED_INT, 0);
    }

    public function drawTexture(position:Vector2, size:Vector2, modulate:Color, sourceRect:Vector4, origin:Vector2, angle:Float):Void {
        // use shader
        RenderingServer.backend.useShader(shader);

        // use texture
        Glad.activeTexture(Glad.TEXTURE0);
        Glad.bindTexture(Glad.TEXTURE_2D, texture.texture);

        // vao
        Glad.bindVertexArray(VAO);
        
        // shader params
        _trans.reset(1.0);
        
        _vec2.set((sourceRect.z - sourceRect.x) * size.x, (sourceRect.w - sourceRect.y) * size.y);
        _trans.scale(_vec3.set(_vec2.x, _vec2.y, 1.0));

        if (angle != 0.0) {
            _trans.translate(_vec3.set(-origin.x * _vec2.x, -origin.y * _vec2.y, 0.0));
            _trans.radRotate(angle, _vec3.set(0, 0, 1)); // preventing memory from exploding 
            _trans.translate(_vec3.set(origin.x * _vec2.x, origin.y * _vec2.y, 0.0));
        }

        _trans.translate(_vec3.set(position.x + (-origin.x * _vec2.x), position.y + (-origin.y * _vec2.y), 0.0));
        
        RenderingServer.backend.setUniformMat4x4(shader, "TRANSFORM", _trans);
        RenderingServer.backend.setUniformColor(shader, "MODULATE", modulate);
        RenderingServer.backend.setUniformVec4(shader, "SOURCE", sourceRect);

        // draw
        Glad.drawElements(Glad.TRIANGLES, 6, Glad.UNSIGNED_INT, 0);
    }

    public function drawFrame(position:Vector2, frame:QuadFrame, size:Vector2, scale:Vector2, modulate:Color, sourceRect:Vector4, origin:Vector2, angle:Float):Void {
        // use shader
        RenderingServer.backend.useShader(shader);

        // use texture
        Glad.activeTexture(Glad.TEXTURE0);
        Glad.bindTexture(Glad.TEXTURE_2D, texture.texture);

        // vao
        Glad.bindVertexArray(VAO);
        
        // shader params
        _trans.reset(1.0);
        
        _vec2.set((sourceRect.z - sourceRect.x) * size.x, (sourceRect.w - sourceRect.y) * size.y);
        _trans.scale(_vec3.set(_vec2.x, _vec2.y, 1.0));
        
        if (frame.angle != 0.0) {
            _trans.rotate270Z(); // TODO: work on all angles
            _trans.translate(_vec3.set(0, frame.size.x, 0));
        }

        _trans.scale(_vec3.set(scale.x, scale.y, 1.0));
        
        _vec2.set(frame.marginSize.x * scale.x, frame.marginSize.y * scale.y);
        _trans.translate(_vec3.set(frame.offset.x * scale.x, frame.offset.y * scale.y, 0.0));

        if (angle != 0.0) {
            _trans.translate(_vec3.set(-origin.x * _vec2.x, -origin.y * _vec2.y, 0.0));
            _trans.radRotate(angle, _vec3.set(0, 0, 1)); // preventing memory from exploding
            _trans.translate(_vec3.set(origin.x * _vec2.x, origin.y * _vec2.y, 0.0));
        }
        
        _trans.translate(_vec3.set(position.x, position.y, 0.0));
        _trans.translate(_vec3.set(-origin.x * _vec2.x, -origin.y * _vec2.y, 0.0));
        
        RenderingServer.backend.setUniformMat4x4(shader, "TRANSFORM", _trans);
        RenderingServer.backend.setUniformColor(shader, "MODULATE", modulate);
        RenderingServer.backend.setUniformVec4(shader, "SOURCE", sourceRect);

        // draw
        Glad.drawElements(Glad.TRIANGLES, 6, Glad.UNSIGNED_INT, 0);
    }

    public function dispose():Void {
        Glad.deleteVertexArrays(1, Pointer.addressOf(VAO));
        Glad.deleteBuffers(1, Pointer.addressOf(VBO));
        Glad.deleteBuffers(1, Pointer.addressOf(EBO));
    }
}

class OpenGLFrameBuffer implements IFrameBufferData {
	public var buffer:Any;

    public function new(buffer:UInt32) {
        this.buffer = buffer;
    }
}

/**
 * The OpenGL rendering backend.
 */
@:access(canvas.ui.Window)
@:access(canvas.graphics.Shader)
class OpenGLBackend extends RenderingBackend {
    private static var _vec:Vector2 = new Vector2();

    /**
     * Initializes this rendering backend.
     */
    override function init():Void {
        var nativeQuadRenderer:OpenGLQuadRenderer = new OpenGLQuadRenderer(null);
        quadRenderer = nativeQuadRenderer;

        defaultShader = new Shader(
            Shader.FRAGMENT_DEFAULT,
            Shader.VERTEX_DEFAULT
        );

        colorRectShader = new Shader(
            "void main() {
                COLOR = MODULATE;
            }",
            Shader.VERTEX_DEFAULT
        );

        quadRenderer.shader = defaultShader.shaderData;

        Glad.enable(Glad.BLEND);
        Glad.blendFunc(Glad.SRC_ALPHA, Glad.ONE_MINUS_SRC_ALPHA);
    }

    /**
     * Sets the values of the current viewport rectangle.
     */
    override function setViewportRect(rect:Rectanglei):Void {
        Glad.viewport(rect.x, rect.y, rect.width, rect.height);
    }

    /**
     * Clears whatever is on-screen currently.
     */
    override function clear(window:Window):Void {
        DisplayServer.backend.useWindowContext(window._nativeWindow);
        Glad.clear(Glad.COLOR_BUFFER_BIT);
        
        colorRectShader.useProgram();
        quadRenderer.drawColor(Vector2.ZERO, _vec.set(window.size.x, window.size.y), RenderingServer.clearColor);
    }
 
    /**
     * Presents/renders whatever is on-screen currently.
     */
    override function present(window:Window):Void {
        DisplayServer.backend.present(window._nativeWindow);
    }

    /**
	 * TODO: Implement this!
	 */
	override function createFrameBuffer():IFrameBufferData {
        var id:UInt32 = 0;
        Glad.genFramebuffers(1, Pointer.addressOf(id));
        Glad.bindFramebuffer(Glad.FRAMEBUFFER, id);
		return new OpenGLFrameBuffer(id);
	}

	/**
	 * TODO: Implement this!
	 */
	override function setupFrameBuffer(frameBuffer:IFrameBufferData, texture:ITextureData):Void {
        Glad.framebufferTexture(Glad.FRAMEBUFFER, Glad.COLOR_ATTACHMENT0, texture.texture, 0);
        untyped __cpp__("GLenum DrawBuffers[1] = {GL_COLOR_ATTACHMENT0}");
        Glad.drawBuffers(1, untyped __cpp__("DrawBuffers"));
    }

	/**
	 * TODO: Implement this!
	 */
	override function disposeFrameBuffer(frameBuffer:IFrameBufferData):Void {
        Glad.deleteFramebuffers(1, Helpers.tempPointer(frameBuffer.buffer));
    }

    /**
	 * TODO: Implement this!
	 */
	override function useFrameBuffer(frameBuffer:IFrameBufferData):Void {
        if(frameBuffer != null)
            Glad.bindFramebuffer(Glad.FRAMEBUFFER, frameBuffer.buffer);
        else
            Glad.bindFramebuffer(Glad.FRAMEBUFFER, 0);
    }

    /**
	 * TODO: Implement this!
	 */
	override function isFrameBufferValid(frameBuffer:IFrameBufferData):Bool {
        Glad.bindFramebuffer(Glad.FRAMEBUFFER, frameBuffer.buffer);
        if(Glad.checkFramebufferStatus(Glad.FRAMEBUFFER) == Glad.FRAMEBUFFER_COMPLETE)
            return true;

		return false;
	}

    /**
     * TODO: Implement this!
     */
    override function createTexture(width:Int, height:Int, data:RawPointer<UInt8>, format:Null<Int> = null, channels:Int = 4, mipmaps:Bool = true, wrapping:TextureWrapping = REPEAT, filter:TextureFilter = LINEAR):ITextureData {
        Glad.pixelStorei(Glad.UNPACK_ALIGNMENT, 1);
        
        var id:UInt32 = 0;
        Glad.genTextures(1, Pointer.addressOf(id));
        Glad.bindTexture(Glad.TEXTURE_2D, id);

        var format:Int = (format != null) ? format : ((channels == 4) ? Glad.RGBA : Glad.RGB);
        Glad.texImage2D(Glad.TEXTURE_2D, 0, format, width, height, 0, format, Glad.UNSIGNED_BYTE, data);

        if(mipmaps)
            Glad.generateMipmap(Glad.TEXTURE_2D);

        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_WRAP_S, _getOpenGLWrap(wrapping));
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_WRAP_T, _getOpenGLWrap(wrapping));
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_MIN_FILTER, _getOpenGLFilter(filter));
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_MAG_FILTER, _getOpenGLFilter(filter));

        var textureData:OpenGLTextureData = new OpenGLTextureData(id, new Vector2i(width, height), channels, mipmaps, wrapping, filter);
        return textureData;
    }

    /**
	 * TODO: Implement this!
	 */
	override function setTextureFilter(texture:ITextureData, filter:TextureFilter = LINEAR):Void {
        Glad.bindTexture(Glad.TEXTURE_2D, texture.texture);
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_MIN_FILTER, _getOpenGLFilter(filter));
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_MAG_FILTER, _getOpenGLFilter(filter));        
    }

    /**
     * TODO: Implement this!
     */
    override function disposeTexture(texture:ITextureData):Void {
        // Helpers.tempPointer is used because regular cpp.Pointer just doesn't work
        // :3   - what-is-a-git
        var id:UInt32 = cast texture.texture;
        Glad.deleteTextures(1, Helpers.tempPointer(id));
    }

    /**
     * TODO: Implement this!
     */
    override function createShader(fragmentSource:ConstCharStar, vertexSource:ConstCharStar):IShaderData {
        var success:Int = 0;

        var vertID:UInt32 = Glad.createShader(Glad.VERTEX_SHADER);
        Glad.shaderSource(vertID, 1, Helpers.tempPointer(vertexSource), null);
        Glad.compileShader(vertID);
        Glad.getShaderiv(vertID, Glad.COMPILE_STATUS, Pointer.addressOf(success));

        if (success == 0) {
            var infoLog:cpp.Star<cpp.Char> = Helpers.malloc(1024, cpp.Char);
            Glad.getShaderInfoLog(vertID, 1024, null, infoLog);
            Helpers.nativeTrace("Failed to load Vertex Shader.\n%s\n", infoLog);
            Helpers.free(infoLog);
        }

        var fragID:UInt32 = Glad.createShader(Glad.FRAGMENT_SHADER);
        Glad.shaderSource(fragID, 1, Helpers.tempPointer(fragmentSource), null);
        Glad.compileShader(fragID);
        Glad.getShaderiv(fragID, Glad.COMPILE_STATUS, Pointer.addressOf(success));

        if (success == 0) {
            var infoLog:cpp.Star<cpp.Char> = Helpers.malloc(1024, cpp.Char);
            Glad.getShaderInfoLog(fragID, 1024, null, infoLog);
            Helpers.nativeTrace("Failed to load Fragment Shader.\n%s\n", infoLog);
            Helpers.free(infoLog);
        }

        var programID:UInt32 = Glad.createProgram();
        Glad.attachShader(programID, vertID);
        Glad.attachShader(programID, fragID);
        Glad.linkProgram(programID);
        Glad.getProgramiv(programID, Glad.LINK_STATUS, Pointer.addressOf(success));

        if (success == 0) {
            var infoLog:cpp.Star<cpp.Char> = Helpers.malloc(1024, cpp.Char);
            Glad.getProgramInfoLog(programID, 1024, null, infoLog);
            Helpers.nativeTrace("Failed to link Shader Program.\n%s\n", infoLog);
            Helpers.free(infoLog);
        }

        Glad.deleteShader(vertID);
        Glad.deleteShader(fragID);

        var shaderData:OpenGLShaderData = new OpenGLShaderData(programID);

        useShader(shaderData);
        setUniformMat4x4(shaderData, "PROJECTION", quadRenderer.projection);

        return shaderData;
    }

    /**
     * TODO: Implement this!
     */
    override function useShader(shader:IShaderData):Void {
        quadRenderer.shader = shader;
        Glad.useProgram(shader.shader);
    }

    /**
     * TODO: Implement this!
     */
    override function disposeShader(shader:IShaderData):Void {
        if (quadRenderer.shader == shader)
            quadRenderer.shader = null;

        Glad.deleteProgram(shader.shader);
    }

    override inline function setUniformInt(shader:IShaderData, name:ConstCharStar, value:Int) {
        untyped __cpp__("glUniform1i(glGetUniformLocation({0}, {1}), {2})", shader.shader, name, value);
    }

    override inline function setUniformFloat(shader:IShaderData, name:ConstCharStar, value:Float) {
        untyped __cpp__("glUniform1f(glGetUniformLocation({0}, {1}), {2})", shader.shader, name, value);
    }

    override inline function setUniformVec2(shader:IShaderData, name:ConstCharStar, value:Vector2) {
        untyped __cpp__("glUniform2f(glGetUniformLocation({0}, {1}), {2}, {3})", shader.shader, name, value.x, value.y);
    }

    override inline function setUniformVec3(shader:IShaderData, name:ConstCharStar, value:Vector3) {
        untyped __cpp__("glUniform3f(glGetUniformLocation({0}, {1}), {2}, {3}, {4})", shader.shader, name, value.x, value.y, value.z);
    }

    override inline function setUniformVec4(shader:IShaderData, name:ConstCharStar, value:Vector4) {
        untyped __cpp__("glUniform4f(glGetUniformLocation({0}, {1}), {2}, {3}, {4}, {5})", shader.shader, name, value.x, value.y, value.z, value.w);
    }

    override inline function setUniformColor(shader:IShaderData, name:ConstCharStar, value:Color) {
        untyped __cpp__("glUniform4f(glGetUniformLocation({0}, {1}), {2}, {3}, {4}, {5})", shader.shader, name, value.r, value.g, value.b, value.a);
    }

    override inline function setUniformMat4x4(shader:IShaderData, name:ConstCharStar, value:Matrix4x4) {
        untyped __cpp__("
            float* _star = {0};
            glUniformMatrix4fv(glGetUniformLocation({1}, {2}), 1, GL_FALSE, _star);
            free(_star)", value.toStar(), shader.shader, name);
    }

    /**
     * Disposes of this rendering backend and removes it's
     * properties from memory.
     */
    override function dispose():Void {
        quadRenderer.dispose();
        quadRenderer = null;
    }

    // --------------- //
    // [ Private API ] //
    // --------------- //

    private static function _getOpenGLWrap(wrapping:TextureWrapping):Int {
        switch (wrapping) {
            case REPEAT:
                return Glad.REPEAT;
            case MIRRORED_REPEAT:
                return Glad.MIRRORED_REPEAT;
            case CLAMP_EDGE:
                return Glad.CLAMP_TO_EDGE;
            case CLAMP_BORDER:
                return Glad.CLAMP_TO_BORDER;
        }

        return -1;
    }

    private static function _getOpenGLFilter(filter:TextureFilter):Int {
        switch (filter) {
            case LINEAR:
                return Glad.LINEAR;
            case NEAREST:
                return Glad.NEAREST;
        }

        return -1;
    }
}