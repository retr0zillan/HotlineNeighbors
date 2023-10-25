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

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
    var coolVid:VideoHandler;

	override public function create():Void
	{


		// DEBUG BULLSHIT

		super.create();

		/*NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end*/

		FlxG.autoPause=true;

		

		var video = new VideoSprite(0,0);
		video.playVideo(Paths.video('ded.mp4'));
		video.visible = false;
		add(video);

       

		Conductor.changeBPM(102);
		persistentUpdate = true;

		FlxG.sound.playMusic(Paths.music('menu_music', 'preload'), 0);
		FlxG.sound.music.fadeIn(1, 0, 1, function(_){
			if(!InitState.isAmd)
			FlxG.switchState(new NewMainMenuState());
			else
				FlxG.switchState(new WarningState());

		});

		

	}

	var logoBl:FlxSprite;
	
	var speaker:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var bg:FlxSprite;
	var bgLit:FlxSprite;


	

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		
		

		

		super.update(elapsed);
	}

	

	

	

	var skippedIntro:Bool = false;

	
}
