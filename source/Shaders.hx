package;

// STOLEN FROM HAXEFLIXEL DEMO LOL
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;
import flixel.math.FlxPoint;

using StringTools;
typedef ShaderEffect = {
  var shader:Dynamic;
}

class NoteEffect {
  public var shader: NoteShader = new NoteShader();
  public function new(){
    shader.flash.value = [0];
  }

  public function setFlash(val: Float){
    shader.flash.value=[val];
  }

}


class ColorSwap {
  public var shader:ColorSwapShader = new ColorSwapShader();
  public var hasOutline(default, set):Bool = false;
  public var hue(default, set):Float = 0;
  public var sat(default, set):Float = 0;
  public var val(default, set):Float = 0;

  private function set_hasOutline(value:Bool){
    hasOutline=value;
    shader.awesomeOutline.value[0]=value;
    return hasOutline;
  }

  private function set_hue(value:Float){
    hue=value;
    shader.hue.value[0]=value;
    return hue;
  }

  private function set_sat(value:Float){
    sat=value;
    shader.sat.value[0]=value;
    return sat;
  }

  private function set_val(value:Float){
    val=value;
    shader.val.value[0]=value;
    return val;
  }

  public function new(){
    shader.hue.value = [hue];
    shader.sat.value = [sat];
    shader.val.value = [val];
    shader.awesomeOutline.value = [hasOutline];
  }
}

class NoteShader extends FlxShader
{
  @:glFragmentSource('
    #pragma header
    uniform float flash;

    float scaleNum(float x, float l1, float h1, float l2, float h2){
        return ((x - l1) * (h2 - l2) / (h1 - l1) + l2);
    }

    void main()
    {
        vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);
        vec4 newCol = col;
        if(flash!=0.0 && col.a>0.0)
          newCol = mix(col,vec4(1.0,1.0,1.0,col.a),flash) * col.a;

        gl_FragColor = newCol;
    }
  ')
  public function new()
  {
    super();
  }

}

class ColorSwapShader extends FlxShader
{
  @:glFragmentSource('
    #pragma header
    uniform float hue;
    uniform float sat;
    uniform float val;
    uniform bool awesomeOutline;


    const float offset = 1.0 / 128.0;



    vec3 normalizeColor(vec3 color)
    {
        return vec3(
            color[0] / 255.0,
            color[1] / 255.0,
            color[2] / 255.0
        );
    }

    vec3 rgb2hsv(vec3 c)
    {
        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }

    vec3 hsv2rgb(vec3 c)
    {
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }

    void main()
    {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

        vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);

        // [0] is the hue???
        swagColor[0] += hue;
        swagColor[1] += sat;
        swagColor[2] *= (1.0+val);

        // swagColor[1] += uTime;

        if(swagColor[1] < 0.0)
  			{
  				swagColor[1] = 0.0;
  			}
  			else if(swagColor[1] > 1.0)
  			{
  				swagColor[1] = 1.0;
  			}

        color = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);


        if (awesomeOutline)
        {
             // Outline bullshit?
            vec2 size = vec2(3, 3);

            if (color.a <= 0.5) {
                float w = size.x / openfl_TextureSize.x;
                float h = size.y / openfl_TextureSize.y;

                if (flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y)).a != 0.
                || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y)).a != 0.
                || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + h)).a != 0.
                || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y - h)).a != 0.)
                    color = vec4(1.0, 1.0, 1.0, 1.0);
            }


        }



        gl_FragColor = color;


        /*
        if (color.a > 0.5)
            gl_FragColor = color;
        else
        {
            float a = flixel_texture2D(bitmap, vec2(openfl_TextureCoordv + offset, openfl_TextureCoordv.y)).a +
                      flixel_texture2D(bitmap, vec2(openfl_TextureCoordv, openfl_TextureCoordv.y - offset)).a +
                      flixel_texture2D(bitmap, vec2(openfl_TextureCoordv - offset, openfl_TextureCoordv.y)).a +
                      flixel_texture2D(bitmap, vec2(openfl_TextureCoordv, openfl_TextureCoordv.y + offset)).a;
            if (color.a < 1.0 && a > 0.0)
                gl_FragColor = vec4(0.0, 0.0, 0.0, 0.8);
            else
                gl_FragColor = color;
        } */
      }
  ')
  public function new()
  {
    super();
  }
}

// https://www.shadertoy.com/view/WtGXDD

class RaymarchEffect {
  var rad = Math.PI/180;
  public var shader:RaymarchShader = new RaymarchShader();
  public function new(){
    shader.yaw.value = [0];
    shader.pitch.value = [0];
  }
  public function addYaw(yaw:Float){
    shader.yaw.value[0]+=yaw*rad;
  }
  public function setYaw(yaw:Float){
    shader.yaw.value[0]=yaw*rad;
  }

  public function addPitch(pitch:Float){
    shader.pitch.value[0]+=pitch*rad;
  }
  public function setPitch(pitch:Float){
    shader.pitch.value[0]=pitch*rad;
  }
}

class RaymarchShader extends FlxShader {
  @:glFragmentSource('
    #pragma header

    // "RayMarching starting point"
    // Modified by Nebula_Zorua
    // by Martijn Steinrucken aka The Art of Code/BigWings - 2020
    // The MIT License
    // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, moy, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    // Email: countfrolic@gmail.com
    // Twitter: @The_ArtOfCode
    // YouTube: youtube.com/TheArtOfCodeIsCool
    // Facebook: https://www.facebook.com/groups/theartofcode/
    //
    // You can use this shader as a template for ray marching shaders

    #define MAX_STEPS 100
    #define MAX_DIST 100.
    #define SURF_DIST 0.01

    uniform float yaw;
    uniform float pitch;

    mat2 Rot(float a) {
        float s=sin(a), c=cos(a);
        return mat2(c, -s, s, c);
    }

    float sdBox(vec3 p, vec3 s) {
        p = abs(p)-s;
    	return length(max(p, 0.))+min(max(p.x, max(p.y, p.z)), 0.);
    }

    float GetDist(vec3 p) {
        float d = sdBox(p, vec3(1.,1.,0));

        return d;
    }



    float RayMarch(vec3 ro, vec3 rd) {
    	float dO=0.;

        for(int i=0; i<MAX_STEPS; i++) {
        	vec3 p = ro + rd*dO;
            float dS = GetDist(p);
            dO += dS;
            if(dO>MAX_DIST || abs(dS)<SURF_DIST) break;
        }

        return dO;
    }

    vec3 GetNormal(vec3 p) {
    	float d = GetDist(p);
        vec2 e = vec2(.001, 0);

        vec3 n = d - vec3(
            GetDist(p-e.xyy),
            GetDist(p-e.yxy),
            GetDist(p-e.yyx));

        return normalize(n);
    }

    vec3 GetRayDir(vec2 uv, vec3 p, vec3 l, float z) {
        vec3 f = normalize(l-p),
            r = normalize(cross(vec3(0,1,0), f)),
            u = cross(f,r),
            c = f*z,
            i = c + uv.x*r + uv.y*u,
            d = normalize(i);
        return d;
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv - vec2(0.5);
        vec3 ro = vec3(0, 0., -2);

        ro.xz *= Rot(yaw);
        ro.yz *= Rot(pitch);

        vec3 rd = GetRayDir(uv, ro, vec3(0,0.,0.), 1.);
        vec4 col = vec4(0);

        float d = RayMarch(ro, rd);

        if(d<MAX_DIST) {
            vec3 p = ro + rd * d;
            vec3 n = GetNormal(p);
            uv = vec2(p.x,p.y) * .5 + vec2(0.5);
            col = flixel_texture2D(bitmap,uv);
        }
        gl_FragColor = col;
    }
  ')
  public function new()
  {
    super();
  }
}

class BuildingEffect {
  public var shader:BuildingShader = new BuildingShader();
  public function new(){
    shader.alphaShit.value = [0];
  }
  public function addAlpha(alpha:Float){
    shader.alphaShit.value[0]+=alpha;
  }
  public function setAlpha(alpha:Float){
    shader.alphaShit.value[0]=alpha;
  }
}

class BuildingShader extends FlxShader
{
  @:glFragmentSource('
    #pragma header
    uniform float alphaShit;
    void main()
    {

      vec4 color = flixel_texture2D(bitmap,openfl_TextureCoordv);
      if (color.a > 0.0)
        color-=alphaShit;

      gl_FragColor = color;
    }
  ')
  public function new()
  {
    super();
  }
}


class VCRDistortionEffect
{
  public var shader:VCRDistortionShader = new VCRDistortionShader();
  public function new(){
    shader.iTime.value = [0];
    shader.vignetteOn.value = [true];
    shader.perspectiveOn.value = [true];
    shader.distortionOn.value = [true];
    shader.scanlinesOn.value = [true];
    shader.vignetteMoving.value = [true];
    shader.noiseOn.value = [true];
    shader.glitchModifier.value = [1];
    shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight];
    var noise = Assets.getBitmapData(Paths.image("noise2"));
    shader.noiseTex.input = noise;
  }

  public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;
    shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight];
  }

  public function setVignette(state:Bool){
    shader.vignetteOn.value[0] = state;
  }

  public function setNoise(state:Bool){
    shader.noiseOn.value[0] = state;
  }

  public function setPerspective(state:Bool){
    shader.perspectiveOn.value[0] = state;
  }

  public function setGlitchModifier(modifier:Float){
    shader.glitchModifier.value[0] = modifier;
  }

  public function setDistortion(state:Bool){
    shader.distortionOn.value[0] = state;
  }

  public function setScanlines(state:Bool){
    shader.scanlinesOn.value[0] = state;
  }

  public function setVignetteMoving(state:Bool){
    shader.vignetteMoving.value[0] = state;
  }
}

class VCRDistortionShader extends FlxShader // https://www.shadertoy.com/view/ldjGzV and https://www.shadertoy.com/view/Ms23DR and https://www.shadertoy.com/view/MsXGD4 and https://www.shadertoy.com/view/Xtccz4
{

  @:glFragmentSource('
    #pragma header

    uniform float iTime;
    uniform bool vignetteOn;
    uniform bool perspectiveOn;
    uniform bool distortionOn;
    uniform bool scanlinesOn;
    uniform bool vignetteMoving;
    uniform sampler2D noiseTex;
    uniform float glitchModifier;
    uniform vec3 iResolution;
    uniform bool noiseOn;

    float onOff(float a, float b, float c)
    {
    	return step(c, sin(iTime + a*cos(iTime*b)));
    }

    float ramp(float y, float start, float end)
    {
    	float inside = step(start,y) - step(end,y);
    	float fact = (y-start)/(end-start)*inside;
    	return (1.-fact) * inside;

    }

    vec4 getVideo(vec2 uv)
      {
      	vec2 look = uv;
        if(distortionOn){
        	float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,1.)));
        	look.x = look.x + (sin(look.y*10. + iTime)/50.*onOff(4.,4.,.3)*(1.+cos(iTime*80.))*window)*(glitchModifier*2);
        	float vShift = 0.4*onOff(2.,3.,.9)*(sin(iTime)*sin(iTime*20.) +
        										 (0.5 + 0.1*sin(iTime*200.)*cos(iTime)));
        	look.y = mod(look.y + vShift*glitchModifier, 1.);
        }
      	vec4 video = flixel_texture2D(bitmap,look);

      	return video;
      }

    vec2 screenDistort(vec2 uv)
    {
      if(perspectiveOn){
        uv = (uv - 0.5) * 2.0;
      	uv *= 1.1;
      	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
      	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
      	uv  = (uv / 2.0) + 0.5;
      	uv =  uv *0.92 + 0.04;
      	return uv;
      }
    	return uv;
    }
    float random(vec2 uv)
    {
     	return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(iTime * 0.03));
    }
    float noise(vec2 uv)
    {
     	vec2 i = floor(uv);
        vec2 f = fract(uv);

        float a = random(i);
        float b = random(i + vec2(1.,0.));
    	float c = random(i + vec2(0., 1.));
        float d = random(i + vec2(1.));

        vec2 u = smoothstep(0., 1., f);

        return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;

    }


    vec2 scandistort(vec2 uv) {
    	float scan1 = clamp(cos(uv.y * 2.0 + iTime), 0.0, 1.0);
    	float scan2 = clamp(cos(uv.y * 2.0 + iTime + 4.0) * 10.0, 0.0, 1.0) ;
    	float amount = scan1 * scan2 * uv.x;

    	uv.x -= 0.05 * mix(flixel_texture2D(noiseTex, vec2(uv.x, amount)).r * amount, amount, 0.9);

    	return uv;

    }
    void main()
    {
    	vec2 uv = openfl_TextureCoordv;
      vec2 curUV = screenDistort(uv);
    	uv = scandistort(curUV);
    	vec4 video = getVideo(uv);
      float vigAmt = 1.0;
      float x =  0.;


      video.r = getVideo(vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
      video.g = getVideo(vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
      video.b = getVideo(vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
      video.r += 0.08*getVideo(0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
      video.g += 0.05*getVideo(0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
      video.b += 0.08*getVideo(0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

      video = clamp(video*0.6+0.4*video*video*1.0,0.0,1.0);
      if(vignetteMoving)
    	  vigAmt = 3.+.3*sin(iTime + 5.*cos(iTime*5.));

    	float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));

      if(vignetteOn)
    	 video *= vignette;

      if(curUV.x<0 || curUV.x>1 || curUV.y<0 || curUV.y>1){
        gl_FragColor = vec4(0,0,0,0);
      }else{
        if(noiseOn){
          gl_FragColor = mix(video,vec4(noise(uv * 75.)),.05);
        }else{
          gl_FragColor = video;
        }

      }



    }
  ')
  public function new()
  {
    super();
  }
}
class HotlineHeatEffect {
  public var shader: HotlineShader = new HotlineShader();
  public function new(){
    shader.iTime.value = [0];
 
   


  }
 
  public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;
    

  }

 

}

class HotlineShader extends FlxShader{
  @:glFragmentSource('
  #pragma header
  uniform float iTime;
 

  vec2 size = vec2(50.0, 50.0);
  vec2 distortion = vec2(20.0, 20.0);
  float speed = 0.75;

  void main()
  {
    vec2 iResolution = openfl_TextureSize;
    vec2 uv = openfl_TextureCoordv;
    vec2 fragCoord = uv * iResolution;

      vec2 transformed = vec2(
          fragCoord.x + sin(fragCoord.y / size.x + iTime * speed) * distortion.x,
          fragCoord.y + cos(fragCoord.x / size.y + iTime * speed) * distortion.y
      );
      vec2 relCoord = fragCoord.xy / iResolution.xy;
      gl_FragColor = texture(bitmap, transformed / iResolution.xy) + vec4(
          (cos(relCoord.x + iTime * speed * 4.0) + 1.0) / 2.0,
          (relCoord.x + relCoord.y) / 2.0,
          (sin(relCoord.y + iTime * speed) + 1.0) / 2.0,
          0
      );
  }

 ')
 
 public function new(){
 super();
 }
 }
 class ChromaEffect {
  public var shader: HotlineShader = new HotlineShader();
  public function new(){
    shader.iTime.value = [0];
 
   


  }
 
  public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;
    

  }

 

}

class ChromaShader extends FlxShader{
  @:glFragmentSource('
  #pragma header
  uniform float iTime;
 
  void main()
  {
    vec2 iResolution = openfl_TextureSize;
    vec2 uv = openfl_TextureCoordv;
    vec2 fragCoord = uv * iResolution;

      float ChromaticAberration =  10.0 + 8.0;
  
      vec2 texel = 1.0 / iResolution.xy;
      
      vec2 coords = (uv - 0.5) * 2.0;
      float coordDot = dot (coords, coords);
      
      vec2 precompute = ChromaticAberration * coordDot * coords;
      vec2 uvR = uv - texel.xy * precompute;
      vec2 uvB = uv + texel.xy * precompute;
      
      vec4 color;
      color.r = flixel_texture2D(bitmap, uvR).r;
      color.g = flixel_texture2D(bitmap, uv).g;
      color.b = flixel_texture2D(bitmap, uvB).b;
      vec4 texture = flixel_texture2D(bitmap, openfl_TextureCoordv);

    gl_FragColor = vec4(color.rgb*texture.a, texture.a);
  }
 ')
 
 public function new(){
 super();
 }
 }

 class CoolVhsEffect1 {
  public var shader: CoolVhsShaderPart2 = new CoolVhsShaderPart2();
  public function new(){
    shader.iTime.value = [0];
 
   


  }
 
  public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;
    

  }

 

}

class CoolVhsShaderPart2 extends FlxShader{
  @:glFragmentSource('
  #pragma header
  uniform float iTime;
  #define lerp mix

  #define NTSC 0
  #define PAL 1
  
  // Effect params
  #define VIDEO_STANDARD PAL
  
  #if VIDEO_STANDARD == NTSC
      const vec2 maxResLuminance = vec2(333.0, 480.0);
      const vec2 maxResChroma = vec2(40.0, 480.0);
  #elif VIDEO_STANDARD == PAL
      const vec2 maxResLuminance = vec2(335.0, 576.0);
      const vec2 maxResChroma = vec2(40.0, 240.0);
  #endif
  
  const vec2 blurAmount = vec2(0.2, 0.2);
  
  // End effect params
  #define VIDEO_TEXTURE bitmap


  
  
  
  
  mat3 rgb2yiq = mat3(0.299, 0.596, 0.211,
                          0.587, -0.274, -0.523,
                          0.114, -0.322, 0.312);
  
  mat3 yiq2rgb = mat3(1, 1, 1,
                          0.956, -0.272, -1.106,
                          0.621, -0.647, 1.703);
  
  
  vec4 cubic(float v)
  {
      vec4 n = vec4(1.0, 2.0, 3.0, 4.0) - v;
      vec4 s = n * n * n;
      float x = s.x;
      float y = s.y - 4.0 * s.x;
      float z = s.z - 4.0 * s.y + 6.0 * s.x;
      float w = 6.0 - x - y - z;
      return vec4(x, y, z, w) * (1.0/6.0);
  }
  
  vec4 textureBicubic(sampler2D sampler, vec2 texCoords)
  {
  
      vec2 texSize = vec2(textureSize(sampler, 0));
      vec2 invTexSize = vec2(1.0) / texSize;
  
      texCoords = texCoords * texSize - 0.5;
  
  
      vec2 fxy = fract(texCoords);
      texCoords -= fxy;
  
      vec4 xcubic = cubic(fxy.x);
      vec4 ycubic = cubic(fxy.y);
  
      vec4 c = texCoords.xxyy + vec2 (-0.5, +1.5).xyxy;
  
      vec4 s = vec4(xcubic.xz + xcubic.yw, ycubic.xz + ycubic.yw);
      vec4 offset = c + vec4 (xcubic.yw, ycubic.yw) / s;
  
      offset *= invTexSize.xxyy;
  
      vec4 sample0 = texture(sampler, offset.xz);
      vec4 sample1 = texture(sampler, offset.yz);
      vec4 sample2 = texture(sampler, offset.xw);
      vec4 sample3 = texture(sampler, offset.yw);
  
      float sx = s.x / (s.x + s.y);
      float sy = s.z / (s.z + s.w);
  
      return mix(
         mix(sample3, sample2, sx), mix(sample1, sample0, sx)
      , sy);
  }
  

  vec3 downsampleVideo(vec2 uv, vec2 pixelSize, ivec2 samples)
  {
      //return texture(VIDEO_TEXTURE, uv).rgb * rgb2yiq;
      
      vec2 uvStart = uv - pixelSize / 2.0;
      vec2 uvEnd = uv + pixelSize;
      
      vec3 result = vec3(0.0, 0.0, 0.0);
      for (int i_u = 0; i_u < samples.x; i_u++)
      {
          float u = lerp(uvStart.x, uvEnd.x, float(i_u) / float(samples.x));
          
          for (int i_v = 0; i_v < samples.y; i_v++)
          {
              float v = lerp(uvStart.y, uvEnd.y, float(i_v) / float(samples.y));
              
              result += texture(VIDEO_TEXTURE, vec2(u, v)).rgb;
          }
      }    
      
      return (result / float(samples.x * samples.y)) * rgb2yiq;
  }
  
  vec3 downsampleVideo(vec2 fragCoord, vec2 downsampledRes)
  {
     
      if (fragCoord.x > downsampledRes.x || fragCoord.y > downsampledRes.y)
      {
          return vec3(0.0);
      }
      
      vec2 uv = fragCoord / downsampledRes;
      vec2 pixelSize = 1.0 / downsampledRes;
      ivec2 samples = ivec2(8, 3);
      
      pixelSize *= 1.0 + blurAmount; // Slight box blur to avoid aliasing
      
      return downsampleVideo(uv, pixelSize, samples);
  }
  
  void main()
  {
      vec2 iResolution = openfl_TextureSize;
      vec2 uv = openfl_TextureCoordv;
      vec2 fragCoord = uv * iResolution;

      vec2 resLuminance = min(maxResLuminance, vec2(iResolution));
      vec2 resChroma = min(maxResChroma, vec2(iResolution));    
      
      float luminance = downsampleVideo(fragCoord, resLuminance).r;
      vec2 chroma = downsampleVideo(fragCoord, resChroma).gb;
      
      vec4 yeah = flixel_texture2D(bitmap, openfl_TextureCoordv);
      gl_FragColor = vec4(luminance, chroma, yeah.a);
  }

 ')
 
 public function new(){
 super();
 }
 }
 class CoolVhsEffect2 {
  public var shader: VhsShader2 = new VhsShader2();
  public function new(){
    shader.iTime.value = [0];
 
   


  }
 
  public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;
    

  }

 

}

class VhsShader2 extends FlxShader{
  @:glFragmentSource('
  #pragma header
  uniform float iTime;
  vec2 uv = openfl_TextureCoordv;
  vec2 iResolution = openfl_TextureSize;
  vec2 fragCoord = uv * iResolution;

  #define DEFINE(a) (iResolution.y / 450.0) * a
#define pow2(a) (a * a)
#define PI 3.1415926535897932384626433832795
#define THIRD 1.0 / 3.0
#define BLACK vec4(0.0, 0.0, 0.0, 1.0)
#define WHITE vec4(1.0)
#define W vec3(0.2126, 0.7152, 0.0722)
#define PHI 1.61803398874989484820459
#define SOURCE_FPS 30.0

float GetLuminance(vec3 color)
{
    return W.r * color.r + W.g * color.g + W.b * color.b;
}

float GetLuminance(vec4 color)
{
    return W.r * color.r + W.g * color.g + W.b * color.b;
}

float GetGaussianWeight(vec2 i, float sigma) 
{
    return 1.0 / (2.0 * PI * pow2(sigma)) * exp(-((pow2(i.x) + pow2(i.y)) / (2.0 * pow2(sigma))));
}

vec4 Blur(in float size, const in vec2 fragCoord, const in vec2 resolution, const in bool useGaussian, const in sampler2D source, const in float lodBias)
{
    vec4 pixel;
    float sum;
    
    vec2 uv = fragCoord / resolution;
    vec2 scale = vec2(1.0) / resolution;

    if (!useGaussian)
        size *= THIRD;
    
    for (float y = -size; y < size; y++)
    {
        if (fragCoord.y + y < 0.0) continue;
        if (fragCoord.y + y >= resolution.y) break;
    
        for (float x = -size; x < size; x++)
        {
            if (fragCoord.x + x < 0.0) continue;
            if (fragCoord.x + x >= resolution.x) break;

            vec2 uvOffset = vec2(x, y);
            float weight = useGaussian ? GetGaussianWeight(uvOffset, size * 0.25/*sigma, standard deviation*/) : 1.0f;
            pixel += texture(source, uv + uvOffset * scale) * weight;
            sum += weight;
        }    
    }
    
    return pixel / sum;
}

float GoldNoise(const in vec2 xy, const in float seed)
{
    //return fract(tan(distance(xy * PHI, xy) * seed) * xy.x);
    return fract(sin(dot(xy * seed, vec2(12.9898, 78.233))) * 43758.5453);
}

// BlendSoftLight credit to Jamie Owen: https://github.com/jamieowen/glsl-blend
float BlendSoftLight(float base, float blend) 
{
	return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
}

vec4 BlendSoftLight(vec4 base, vec4 blend) 
{
	return vec4(BlendSoftLight(base.r,blend.r),BlendSoftLight(base.g,blend.g),BlendSoftLight(base.b,blend.b), 1.0);
}

vec4 BlendSoftLight(vec4 base, vec4 blend, float opacity) 
{
	return (BlendSoftLight(base, blend) * opacity + base * (1.0 - opacity));
}

  vec4 Shrink(in vec2 fragCoord, const in float shrinkRatio, const in float bias)
  {
      float scale = 1.0 / iResolution.x;
      float numBands = iResolution.x * shrinkRatio;
      float bandWidth = iResolution.x / numBands;
      
      // How far are we along the band
      float t = mod(fragCoord.x, bandWidth) / bandWidth;
      
      // Sample current band in lower res
      fragCoord.x = floor(fragCoord.x * shrinkRatio) / shrinkRatio;
      vec2 uv = fragCoord / iResolution.xy;
      vec4 colorA = texture(bitmap, uv, bias);
  
      // Sample next band for interpolation
      uv.x += bandWidth * scale; 
      vec4 colorB = texture(bitmap, uv, bias);
  
      return mix(colorA, colorB, t);
  }
  
  
  vec3 ClipColor(in vec3 c)
  {
      float l = GetLuminance(c);
      float n = min(min(c.r, c.g), c.b);
      float x = max(max(c.r, c.g), c.b);
      
      if (n < 0.0)
      {
          c.r = l + (((c.r - l) * l) / (l - n));
          c.g = l + (((c.g - l) * l) / (l - n));
          c.b = l + (((c.b - l) * l) / (l - n));
      }
      
      if (x > 1.0)
      {
          c.r = l + (((c.r - l) * (1.0 - l)) / (x - l));
          c.g = l + (((c.g - l) * (1.0 - l)) / (x - l));
          c.b = l + (((c.b - l) * (1.0 - l)) / (x - l));
      }
      
      
      return c;
  }
  
  vec3 SetLum(in vec3 c, in float l)
  {
      float d = l - GetLuminance(c);
      c += d;
  
      return ClipColor(c);
  }
  
  vec4 BlendColor(const in vec4 base, const in vec4 blend)
  {
      vec3 c = SetLum(blend.rgb, GetLuminance(base));
      return vec4(c, blend.a);
  }
  
  vec4 BlendLuminosity(const in vec4 base, const in vec4 blend)
  {
      vec3 c = SetLum(base.rgb, GetLuminance(blend));
      return vec4(c, blend.a);
  }
  //part2
  

  void main()
  {
      vec4 luma = Shrink(fragCoord, 0.5, 0.0); // In VHS the luma band is half of the resolution
      luma = BlendLuminosity(vec4(0.5, 0.5, 0.5, 1.0), luma);
      
      vec4 chroma = Shrink(fragCoord,  1.0 / 10.0, 3.0); // In VHS chroma band is a much lower resolution (technically 1/16th)
      vec4 cool = flixel_texture2D(bitmap,openfl_TextureCoordv);

      chroma = BlendColor(luma, chroma);


      gl_FragColor = chroma*cool.a; 

  }
 ')
 
 public function new(){
 super();
 }
 }

 class HotlineEffect{
  public var shader: HotlinePauseShader = new HotlinePauseShader();
  public function new(){
    shader.iTime.value = [0];
 

  }

  public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;


  }

}
class HotlinePauseShader extends FlxShader{

  
  @:glFragmentSource('
  #pragma header
  uniform float iTime;
  uniform float floater1;
  uniform float floater2;
  uniform float copy;
  float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void main()
{
    vec4 texColor = vec4(0);
    // get position to sample
    vec2 samplePosition;
    samplePosition.xy = openfl_TextureCoordv.xy;
    float whiteNoise = 9999.0;
    
 	// Jitter each line left and right
    samplePosition.x = samplePosition.x+(rand(vec2(iTime,openfl_TextureCoordv.y))-0.5)/64.0;
    // Jitter the whole picture up and down
    samplePosition.y = samplePosition.y+(rand(vec2(iTime))-0.5)/32.0;
    // Slightly add color noise to each line
    texColor = texColor + (vec4(-0.5)+vec4(rand(vec2(openfl_TextureCoordv.y,iTime)),rand(vec2(openfl_TextureCoordv.y,iTime+1.0)),rand(vec2(openfl_TextureCoordv.y,iTime+2.0)),0))*0.1;
   
    // Either sample the texture, or just make the pixel white (to get the staticy-bit at the bottom)
    whiteNoise = rand(vec2(floor(samplePosition.y*150.0),floor(samplePosition.x*50.0))+vec2(iTime,0));
    if (whiteNoise > 27.0-30.0*samplePosition.y|| whiteNoise < 4.2 - 5.0*samplePosition.y) {
        // Sample the texture.
    	texColor = texColor + flixel_texture2D(bitmap,samplePosition);
    } else {
       
        texColor = vec4(1);
    }
	gl_FragColor = texColor;
}
  ')

  public function new()
    {
      super();
    }
}

class LSDEffect{
  public var shader: LSDShader = new LSDShader();
  public function new(){
    shader.iTime.value = [0];
 

  }

  public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;


  }

}
class LSDShader extends FlxShader{

  
  @:glFragmentSource('
  #pragma header
  uniform float iTime;
  
  
  #define posterSteps 6.0
  #define lumaMult 0.9
  #define timeMult 0.15
  #define BW 0
  
  float rgbToGray(vec4 rgba) {
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
      return dot(rgba.xyz, W);
  }
  
  vec3 hsv2rgb(vec3 c) {
      vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
      vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
      return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
  }
  

  void main()
  {
	
  vec2 uv = openfl_TextureCoordv;
  vec2 iResolution = openfl_TextureSize;
  vec2 fragCoord = uv * iResolution;

  vec4 color = flixel_texture2D(bitmap, uv);
  float luma = rgbToGray(color) * lumaMult;
  float lumaIndex = floor(luma * posterSteps);
   float lumaFloor = lumaIndex / posterSteps;
  float lumaRemainder = (luma - lumaFloor) * posterSteps;
  if(mod(lumaIndex, 2.) == 0.) lumaRemainder = 1.0 - lumaRemainder; 
  float timeInc = iTime * timeMult;
  float lumaCycle = mod(luma + timeInc, 1.);
  vec3 roygbiv = hsv2rgb(vec3(lumaCycle, 1., lumaRemainder));
  if(BW == 1) {
      float bw = rgbToGray(vec4(roygbiv, 1.));
      gl_FragColor = vec4(vec3(bw), 1.0);
  } else {
    gl_FragColor = vec4(roygbiv, 1.0);
  }

  }
  
  ')

  public function new()
    {
      super();
    }
}