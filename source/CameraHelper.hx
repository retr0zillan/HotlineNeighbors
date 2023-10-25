
package;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import Shaders;
import states.*;

import flixel.FlxCamera;

class CameraHelper{
    public static var camShaders=[];

    public static function addEffect(camera:FlxCamera,effect:ShaderEffect){
        camShaders.push(effect);
        var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
        for(i in camShaders){
          newCamEffects.push(new ShaderFilter(i.shader));
        }
        camera.setFilters(newCamEffects);
    }
    public static function removeEffect(camera:FlxCamera,effect:ShaderEffect){
       camShaders.remove(effect);
        var newCamEffects:Array<BitmapFilter>=[];
        for(i in camShaders){
          newCamEffects.push(new ShaderFilter(i.shader));
        }
        camera.setFilters(newCamEffects);
    }
  
}