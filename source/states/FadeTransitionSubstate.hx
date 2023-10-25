package states;

import flixel.addons.transition.TransitionSubstate;
import flixel.addons.transition.FlxTransitionSprite.TransitionStatus;
import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxColor;
import Shaders;
import lime.system.System;
import lime.graphics.opengl.GL;
class FadeTransitionSubstate extends TransitionSubstate
{
  var _finalDelayTime:Float = 0.0;

  public static var defaultCamera:FlxCamera;
  public static var nextCamera:FlxCamera;

   var curStatus:TransitionStatus;

  public var inst:FadeTransitionSubstate;
  var gradient:FlxSprite;
  var gradientFill:FlxSprite;
  public function new(){
    super();
  }
  var newvhs:CoolVhsEffect2;

  public override function destroy():Void
  {
    super.destroy();
    if(gradient!=null)
      gradient.destroy();

    if(gradientFill!=null)
      gradientFill.destroy();

    gradient=null;
    gradientFill=null;
    finishCallback = null;
  }

  function onFinish(f:FlxTimer):Void
  {
    if (finishCallback != null)
    {
      finishCallback();
      finishCallback = null;
    }
  }

  function delayThenFinish():Void
  {
    new FlxTimer().start(_finalDelayTime, onFinish); // force one last render call before exiting
  }

  public override function update(elapsed:Float){
    if(gradientFill!=null && gradient!=null){
      switch(curStatus){
        case IN:
          //gradientFill.y = gradient.y - gradient.height;
        case OUT:
          //gradientFill.y = gradient.y + gradient.height;
        default:
      }
    }
    super.update(elapsed);
  }
 

  override public function start(status: TransitionStatus){
    var cam = nextCamera!=null?nextCamera:(defaultCamera!=null?defaultCamera:FlxG.cameras.list[FlxG.cameras.list.length - 1]);
    cameras = [cam];

    nextCamera = null;
    curStatus=status;
    var yStart:Float = 0;
    var yEnd:Float = 0;
    var duration:Float = .50;
    var angle:Int = 90;
    var zoom:Float = FlxMath.bound(cam.zoom,0.001);
    var width:Int = Math.ceil(cam.width/zoom);
    var height:Int = Math.ceil(cam.height/zoom);

    var initialAlpha:Float = 0;
    var nextAlpha:Float = 0;

    //yStart = -height;
    //yEnd = height;

    switch(status){
      case IN:
       
        initialAlpha = 0;
        nextAlpha = 1;
    
      case OUT:
        initialAlpha = 1;
        nextAlpha = 0;
      default:
        trace("bruh");
    }
    /*
    gradient = FlxGradient.createGradientFlxSprite(width, height, [FlxColor.BLACK, FlxColor.TRANSPARENT], 1, angle);
    gradient.scrollFactor.set();
    gradient.screenCenter(X);
    gradient.y = yStart;

    */
    gradientFill = new FlxSprite().makeGraphic(width,height,FlxColor.BLACK);
    gradientFill.alpha = initialAlpha;
    gradientFill.screenCenter(X);
    gradientFill.scrollFactor.set();
    add(gradientFill);
    //add(gradient);




    if(!InitState.isAmd){
      newvhs = new CoolVhsEffect2();

      ModChart.addGlobalEffect(newvhs, FlxG.camera);
      trace('added the crt shader && shaders length is ${ModChart.globalShaders.length}');
      trace('youre not an amd user lol');
    }
   
    if(EngineData.options.fastTransitions)
      duration*=.4;


    trace('status is ${curStatus}');
    trace('initalAlpha ${initialAlpha} to nextAlpha ${nextAlpha}');

    FlxTween.tween(gradientFill,{alpha: nextAlpha}, duration,{
      onComplete: function(t:FlxTween){
        trace("done");
        delayThenFinish();
      }
    });

  }
}
