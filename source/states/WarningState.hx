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

class WarningState extends MusicBeatState {
    var IMTIREDBOSS:FlxSprite;
    var canSkip:Bool = false;
    override function create() {
        super.create();
      
        IMTIREDBOSS = new FlxSprite().loadGraphic(Paths.image('warninggg','preload'));
        IMTIREDBOSS.antialiasing=true;

        add(IMTIREDBOSS);
        
       
       
        new FlxTimer().start(5, function(_){
            FlxG.switchState(new NewMainMenuState());

        });
      }    
    override function update(elapsed:Float) {
        super.update(elapsed);
        
    }
    
}