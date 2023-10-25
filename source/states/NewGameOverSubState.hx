package states;


import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import ui.*;
class NewGameOverSubState extends MusicBeatSubstate
{
	

    var coolVid:VideoHandler;
	var stageSuffix:String = "";

    var canSkip:Bool = false;
	public function new()
	{
		
	
		super();

		Conductor.songPosition = 0;
        coolVid = new VideoHandler();
     
        
		
        coolVid.playVideo(Paths.video('ded.mp4'));
        coolVid.canSkip=false;
    
		FlxG.sound.play(Paths.sound('shot', 'preload'), 0.7);

        coolVid.finishCallback = function() {
            
            LoadingState.loadAndSwitchState(new PlayState());

        }
	
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        if(canSkip){


         
        }
		
		

	
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	
}
