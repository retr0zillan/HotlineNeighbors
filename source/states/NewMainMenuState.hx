package states;

import WiggleEffect.WiggleEffectType;
import flixel.addons.effects.chainable.FlxWaveEffect.FlxWaveMode;
import Shaders.LSDEffect;
import Shaders.CoolVhsEffect2;
import Shaders.ChromaEffect;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import haxe.Exception;
using StringTools;
import flixel.util.FlxTimer;
import Options;
import flixel.input.mouse.FlxMouseEventManager;
import ui.*;
import EngineData.WeekData;
import EngineData.SongData;
class NewMainMenuState extends MusicBeatState
{
    var bg:FlxSprite;
    public var currentOptions:Options;
    var logo:FlxSprite;
    var elements:Array<String> = ['Prankcall', 'Options', 'Exit'];
    var menuCrap:FlxTypedGroup<FlxSprite>;
    var hotEffect:LSDEffect;
    var newvhs:CoolVhsEffect2;
    var coolwave:WiggleEffect;
    override  function create() {
        super.create();

        //sex
        FlxG.mouse.visible=false;
        newvhs = new CoolVhsEffect2();
       

        
        if(!FlxG.sound.music.playing){
            FlxG.sound.playMusic(Paths.music('menu_music', 'preload'), 0);
            FlxG.sound.music.fadeIn(4, 0, 0.7);
        }
       

        #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
        currentOptions = OptionUtils.options;
        weekData = EngineData.weekData;
        //persistentUpdate = persistentDraw = true;
       

      

        bg = new FlxSprite();
        bg.loadGraphic(Paths.image('BG2','preload'));
        bg.antialiasing=true;
       
        add(bg);

       
         logo = new FlxSprite(248,28);
        logo.loadGraphic(Paths.image('HMNLogo','preload'));
        logo.antialiasing=true;
        add(logo);


      
        /*
        var menuSpr = new FlxSprite(376,388);
        menuSpr.frames = Paths.getSparrowAtlas('MainMenu', 'preload');
        menuSpr.animation.addByPrefix('idle', '${elements[0]}0', 24, true);
        menuSpr.animation.addByPrefix('selected', 'Selected${elements[0]}');
        menuSpr.animation.play('idle');
        menuSpr.antialiasing=true;
        add(menuSpr);

        var controller = new ObjectController(menuSpr, 1, false, true);
        add(controller);

        */
        
        menuCrap = new FlxTypedGroup<FlxSprite>();
        add(menuCrap);

        for(i in 0...elements.length){
            var menuSpr = new FlxSprite(376,388 + (i*80));
            menuSpr.frames = Paths.getSparrowAtlas('MainMenu', 'preload');
            menuSpr.animation.addByPrefix('idle', '${elements[i]}0', 24, true);
            menuSpr.animation.addByPrefix('selected', 'Selected${elements[i]}');
            menuSpr.animation.play('idle');
            menuSpr.antialiasing=true;
            menuSpr.ID=i;
            menuCrap.add(menuSpr);

            if(i==1)menuSpr.x += 60;
        }
        changeItem(0);
    }
    var curSel:Int = 0;
    function changeItem(ll:Int = 0){
        curSel+=ll;
        if(curSel<0)
            curSel = elements.length-1;
        if(curSel>elements.length-1)
            curSel = 0;
        for(k in menuCrap){
            k.animation.play('idle');
            if(k.ID == curSel)k.animation.play('selected');
        }
    }
    var timeElapsed:Float = 0;

    override function update(elapsed:Float) {
        super.update(elapsed);
  
        timeElapsed += elapsed;



        logo.angle = Math.sin(timeElapsed * 0.5) * 1.2;

        var scale:Float = 1 + Math.cos(timeElapsed * 0.4) * 0.04;

        logo.scale.x = scale;
        logo.scale.y = scale;

        for(i in 0...menuCrap.length){
            
            menuCrap.members[i].x = menuCrap.members[i].x + 0.04 * Math.sin((timeElapsed + i * 0.4) * Math.PI);

        }

        if(controls.DOWN_P)changeItem(1);
        if(controls.UP_P)changeItem(-1);
        if(controls.ACCEPT)crap(curSel);

    }
    var selectedWeek:Bool = false;
    var weekData:Array<WeekData>;
        function crap(opt:Int){
            switch(opt){
                case 0:
                    //lol
                  
                    if(!selectedWeek){
                        PlayState.setStoryWeek(weekData[0],1);
                       
                           

                            LoadingState.loadAndSwitchState(new PlayState(), true);
                            selectedWeek = true;
                    }
                   
                case 1:
                    FlxG.switchState(new NewOptionState());
                case 2:
                    Sys.exit(0);
            }
        }
    
}