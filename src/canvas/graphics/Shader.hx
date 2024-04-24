package canvas.graphics;

import sys.io.File;
import sys.FileSystem;

import cpp.ConstCharStar;

import canvas.graphics.Color;

import canvas.math.Vector2;
import canvas.math.Vector3;
import canvas.math.Vector4;
import canvas.math.Matrix4x4;

import canvas.servers.RenderingServer;
import canvas.utils.AssetCache.IDisposable;

@:access(canvas.ui.Window)
class Shader implements IDisposable {
	public static final VERTEX_PREFIX:String = "
		#version 330 core
		layout (location = 0) in vec4 data;
		uniform mat4 PROJECTION;
		uniform mat4 TRANSFORM;
		uniform vec4 SOURCE;
		out vec2 UV;
	";

	public static final VERTEX_DEFAULT:String = "
		void main() {
			gl_Position = PROJECTION * TRANSFORM * vec4(data.x, data.y, 0.0, 1.0);
			UV = mix(SOURCE.xy, SOURCE.zw, data.zw);
		}
	";

	public static final FRAGMENT_PREFIX:String = "
		#version 330 core
		uniform sampler2D TEXTURE;
		uniform vec4 MODULATE;
		in vec2 UV;
		layout(location = 0) out vec4 COLOR;
	";

	public static final FRAGMENT_DEFAULT:String = "
		void main() {
			COLOR = texture(TEXTURE, UV) * MODULATE;
		}
	";

	private var shaderData:IShaderData;

	/**
	 * Makes a new `Shader` based on the
	 * given `frag` and `vert` code.
	 */
	public function new(?frag:String, ?vert:String) {
		var fragContent = ConstCharStar.fromString(FRAGMENT_PREFIX + ((frag != null && FileSystem.exists(frag)) ? File.getContent(frag) : (frag != null && frag.trim().length > 0) ? frag : FRAGMENT_DEFAULT));
		var vertContent = ConstCharStar.fromString(VERTEX_PREFIX + ((vert != null && FileSystem.exists(vert)) ? File.getContent(vert) : (vert != null && vert.trim().length > 0) ? vert : VERTEX_DEFAULT));
		
		shaderData = RenderingServer.backend.createShader(fragContent, vertContent);
		useProgram();

		_shaders.push(this);
	}

	private function useProgram():Void {
		RenderingServer.backend.useShader(shaderData);
	}

	public function setUniformInt(name:ConstCharStar, value:Int):Void {
		RenderingServer.backend.setUniformInt(shaderData, name, value);
	}

	public function setUniformFloat(name:ConstCharStar, value:Float):Void {
		RenderingServer.backend.setUniformFloat(shaderData, name, value);
	}

	public function setUniformVec2(name:ConstCharStar, value:Vector2):Void {
		RenderingServer.backend.setUniformVec2(shaderData, name, value);
	}

	public function setUniformVec3(name:ConstCharStar, value:Vector3):Void {
		RenderingServer.backend.setUniformVec3(shaderData, name, value);
	}

	public function setUniformVec4(name:ConstCharStar, value:Vector4):Void {
		RenderingServer.backend.setUniformVec4(shaderData, name, value);
	}

	public function setUniformColor(name:ConstCharStar, value:Color):Void {
		RenderingServer.backend.setUniformColor(shaderData, name, value);
	}

	public function setUniformMat4x4(name:ConstCharStar, value:Matrix4x4):Void {
		RenderingServer.backend.setUniformMat4x4(shaderData, name, value);
	}

	/**
	 * Disposes of this shader and removes it's
	 * properties from memory.
	 */
	public function dispose():Void {
		_shaders.remove(this);
		RenderingServer.backend.disposeShader(shaderData);
	}

	// --------------- //
	// [ Private API ] //
	// --------------- //

	private static var _shaders:Array<Shader> = [];
}