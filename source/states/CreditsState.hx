package states;



#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import Options;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;
import lime.app.Application;
import openfl.Assets;
import flixel.addons.transition.FlxTransitionSprite.TransitionStatus;
import ui.*;
using StringTools;

class CreditsState extends MusicBeatState {
    var IMTIREDBOSS:VideoHandler;
    var canSkip:Bool = false;
    override function create() {
        super.create();
        IMTIREDBOSS = new VideoHandler();
        IMTIREDBOSS.disposeVid = false;
        IMTIREDBOSS.playVideo(Paths.video('HotlineMiamiNeighborsCredits.mp4'));
        IMTIREDBOSS.volume = 2;
        IMTIREDBOSS.finishCallback = function(){
            FlxG.switchState(new NewMainMenuState());
        }
       
        new FlxTimer().start(2, function(_){
            canSkip=true;
        });
      }    
    override function update(elapsed:Float) {
        super.update(elapsed);
        if(canSkip&&controls.ACCEPT)
            FlxG.switchState(new NewMainMenuState());
    }
    
}