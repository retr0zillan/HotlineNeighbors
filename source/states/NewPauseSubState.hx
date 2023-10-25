package states;


import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import ui.*;
import WiggleEffect.WiggleEffectType;

import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import Shaders;
import openfl.display.Shader;
using StringTools;
import sys.io.Process;
import sys.FileSystem;
import flixel.math.*;
class NewPauseSubState extends MusicBeatSubstate
{
	var startTimer:FlxTimer;
	var grpMenuShit:FlxTypedGroup<CustomText>;
	var fullPt:String = FileSystem.fullPath('assets/tools');

	var menuItems:Array<String> = [
		'PLAY',
		'REWIND',
		'EJECT'];
	var curSelected:Int = 0;
		var canLerp:Bool = false;
	var pauseMusic:FlxSound;
	var countingDown:Bool=false;
	var Square:FlxSprite;
	var texts:CustomText;
	public var modchart:ModChart;
	public static var cusColor:FlxColor;
	var effect:HotlineEffect;
	public function new(x:Float, y:Float)
	{
		super();

		
		pauseMusic = new FlxSound().loadEmbedded(Paths.sound('inPause', 'preload'), true, true);
		pauseMusic.play();

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = .30;
		bg.scrollFactor.set();
		add(bg);

		
		 Square = new FlxSprite(192,111).makeGraphic(280, 400, 0xFF0000c8);
		Square.alpha = .90;
		
		Square.scrollFactor.set();
		add(Square);
	
		var menu=new FlxText(274, 121, 0, 'MENU', 40);
		menu.font = Paths.font('vcr.ttf');
		add(menu);

		/*
		var obj = new ObjectController(menu,1);
		obj.sizeControl=true;
		add(obj);
		*/
		
		
		grpMenuShit = new FlxTypedGroup<CustomText>();
		add(grpMenuShit);
		




		for (i in 0...menuItems.length)
		{
			texts = new CustomText(226, 200+(i * 60), 0, menuItems[i], 37);
            texts.font = Paths.font('vcr.ttf');
			texts.ID = i;
			grpMenuShit.add(texts);

		}
	
		
		changeSelection();

	
	
	
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		effect = new HotlineEffect();
		newvhs = new CoolVhsEffect2();

		//effect.shader.floater1.value[0] = 27.0;
		//effect.shader.floater2.value[0] = 4.2;
		CameraHelper.addEffect(FlxG.camera, effect);

	}
	var newvhs:CoolVhsEffect2;

	private var camShaders=[];
	public function addCamEffect(effect:ShaderEffect){
		camShaders.push(effect);
		var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
		for(i in camShaders){
		  newCamEffects.push(new ShaderFilter(i.shader));
		}
		FlxG.camera.setFilters(newCamEffects);
		
	
	  }
	  public function removeCamEffect(effect:ShaderEffect){
		camShaders.remove(effect);
		var newCamEffects:Array<BitmapFilter>=[];
		for(i in camShaders){
		  newCamEffects.push(new ShaderFilter(i.shader));
		}
		FlxG.camera.setFilters(newCamEffects);
		
	  }
	var intW:Int = 400;
	var intH:Int = 400;
	var cons:Float = 0;
	var idk:Float =0.0042;
	var destinationX:Float =0;
	var sway:Bool = false;
	override function update(elapsed:Float)
	{
		FlxG.watch.addQuick('str', listString);
		if (FlxG.keys.firstJustPressed() != -1){
			var daK:FlxKey = FlxG.keys.firstJustPressed();
			listString += daK.toString().toLowerCase();
	
			trace("hit");
	
		}

		
	
		super.update(elapsed);
		if(effect!=null){
			effect.update(elapsed);
		}


		for(item in grpMenuShit){
			item.y = 200+(item.ID * 55) + FlxG.random.int(-1,1);
		}

	

	//cons +=idk;
	
	

	FlxG.watch.addQuick('shaders', CameraHelper.camShaders.length);
	/*
		for(i in 0...menuItems.length){
			grpMenuShit.members[i].x = FlxMath.lerp(grpMenuShit.members[i].x, 226+ grpMenuShit.members[i].destX, 0.3);
			if(grpMenuShit.members[i].ID == curSelected)
				{
					grpMenuShit.members[i].x = Std.int(226 + 15 * Math.sin((cons + i *  0.25) * Math.PI));
					
					if(grpMenuShit.members[i].text.length<6)
					grpMenuShit.members[i].destX = 70;
					else
						grpMenuShit.members[i].destX = 40;
					
	
				}
				else
					{
						grpMenuShit.members[i].x = Std.int(226 + 7 * Math.sin((cons + i *  0.25) * Math.PI));
						//grpMenuShit.members[i].destX = 0;
					}
	
	
		}
		*/
		//Square.x =  Std.int(123 + 7 * Math.sin((cons + 1 *  0.25) * Math.PI));


		
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		/*
	for (i in 0...menuItems.length)
		{
			grpMenuShit.members[i].y = 71+(i*intW);
     

		}
		
		*/
		/*
		Square.setGraphicSize(intW, intH);

		
		
		*/
		if (upP)
		{
			changeSelection(-1);

		}
		if (downP)
		{
			changeSelection(1);

		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			CameraHelper.removeEffect(FlxG.camera, effect);

			switch (daSelected)
			{
				case "PLAY":
					FlxG.sound.play(Paths.sound('Pause', 'preload'));

					close();
				case "REWIND":
					FlxG.resetState();
				case "EJECT":
				

					PlayState.cachedSound = false;

				
						FlxG.switchState(new NewMainMenuState());
				


					Cache.clear();
				
					
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}
	var listString:String = '';

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}
	
	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.ID == curSelected)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
class CustomText extends FlxText {
	public var destX:Int = 0;
	public function new(x:Float, y:Float, field:Int, text:String, size:Int){
		super(x,y);
		this.fieldWidth = field;
		this.text = text;
		this.size = size;
	}
	
}