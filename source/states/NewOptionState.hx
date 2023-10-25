package states;

import flixel.tweens.FlxTween;
import Controls;
import Controls.Control;
import Controls.KeyboardScheme;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.transition.FlxTransitionableState;
import Options;
import flixel.graphics.FlxGraphic;
import ui.*;
using StringTools;

#if desktop
import Discord.DiscordClient;
#end
class NewOptionState extends MusicBeatState{
    var gay:FlxSprite;

    var options:FlxTypedGroup<HotOption>;
    var names:Array<String> = ['Controls','Downscroll','Middlescroll','GhostTapping','ResetKey', 'CalibrateOffset','AccuracySystem', 'Judgements'];
    var positions:Array<Int>=[151,118, 104, 97, 151, 81, 71, 151];
  
    var currentAccuracy:FlxSprite;
    var currentJudgement:FlxSprite;
    var coolControls:ControlsLayer;
    var selectArrow:FlxSprite;
    override function create() {
        super.create();
        //are you
        gay = new FlxSprite(0,0);
        gay.loadGraphic(Paths.image('opts','preload'));
        gay.antialiasing = true;
        add(gay);//?

        /*
        var option = new FlxSprite();
        option.frames = Paths.getSparrowAtlas('Options','preload');
        option.animation.addByPrefix('idle', 'Controls', 24, true);
        option.animation.play('idle');
        option.antialiasing = true;
        add(option);


        var controller = new ObjectController(option, 1, false, true);
        add(controller);

        */
      
        /*
        currentAccuracy = new FlxSprite(526,481);
        currentAccuracy.frames = Paths.getSparrowAtlas('Options2','preload');
        for(i in 0...accuTypes.length){
            currentAccuracy.animation.addByPrefix(accuTypes[i], accuTypes[i], 24, true);

        }
        currentAccuracy.animation.play(accuTypes[OptionUtils.options.accuracySystem]);
        currentAccuracy.antialiasing=true;
        add(currentAccuracy);


        currentJudgement = new FlxSprite(476,553);
        currentJudgement.frames = Paths.getSparrowAtlas('Options2','preload');
        for(i in 0...judgementTypes.length){
            currentJudgement.animation.addByPrefix(judgementTypes[i].substr(0, judgementTypes[i].length-1), judgementTypes[i], 24, true);

        }
        currentJudgement.animation.play(OptionUtils.options.judgementWindow);
        currentJudgement.antialiasing=true;
        add(currentJudgement);



        */
        options = new FlxTypedGroup<HotOption>();

        add(options);


      

        var control = new HotControlOption(0,0, 'Controls', 'controls');
        var downscroll = new HotCheckOption(0,0, 'Downscroll', 'downScroll');
        var middlescroll = new HotCheckOption(0,0, 'Middlescroll', 'middleScroll');
        var ghosttapping = new HotCheckOption(0,0, 'GhostTapping', 'ghosttapping');
        var resetkey = new HotCheckOption(0,0, 'ResetKey', 'resetKey');
        var offset = new HotStateOption(0,0, 'CalibrateOffset', new SoundOffsetState());
        var accuracySys = new HotScrollOption(0,0, 'AccuracySystem', accuTypes, accuTypes[OptionUtils.options.accuracySystem], 'accuracySystem',0,2);
        var judgement = new HotJudgementOption(0,0, 'judgementWindow');

        options.add(control);
        options.add(downscroll);
        options.add(middlescroll);
        options.add(ghosttapping);
        options.add(resetkey);
        options.add(offset);
        options.add(accuracySys);
        options.add(judgement);

       
        for(i in 0...names.length){
            options.members[i].ID = i;
            options.members[i].x = positions[i];
            options.members[i].y = 60 + (i*70);
        }


        selectArrow = new FlxSprite(0,0);
        selectArrow.frames = Paths.getSparrowAtlas('Options2','preload');
        selectArrow.animation.addByPrefix('idle', 'SelectArrow', 24, true);
        selectArrow.animation.play('idle');
        add(selectArrow);


        coolControls = new ControlsLayer(0,0);
        coolControls.activeee = false;
        coolControls.alpha = 0;
        add(coolControls);

        changeSel(0);
         /*
        for(i in 0...names.length){
         
            var option = new FlxSprite(positions[i], 60 + (i*70));
            option.frames = Paths.getSparrowAtlas('Options2','preload');
            option.animation.addByPrefix('idle', names[i], 24, true);
            option.ID = i;
            option.animation.play('idle');
            option.antialiasing = true;
            options.add(option);
           
          

        }

       
        var arrow1 = new FlxSprite(494, options.members[6].y);
        arrow1.frames = Paths.getSparrowAtlas('Options2','preload');
        arrow1.animation.addByPrefix('idle', 'Arrows0', 24, true);
        arrow1.ID = options.members[6].ID;
        arrow1.animation.play('idle');
        arrow1.antialiasing = true;
        add(arrow1);

        var arrow2 = new FlxSprite(447, options.members[7].y);
        arrow2.frames = Paths.getSparrowAtlas('Options2','preload');
        arrow2.animation.addByPrefix('idle', 'Arrows2', 24, true);
        arrow2.ID = options.members[7].ID;
        arrow2.animation.play('idle');
        arrow2.antialiasing = true;
        add(arrow2);

    

        */
       

    }
    var controlSprite:FlxSprite;
    function changeSel(jj:Int=0){
        curSel += jj; 

        if(curSel<0)curSel=names.length-1;
        if(curSel>names.length-1)curSel=0;

      
        for(o in options){
            o.isSelected=false;
            if(o.ID == curSel){
                o.isSelected=true;
                trace('Option ${o.ID} is selected');
            }
        }
    }
    var curSel:Int;
    var judgementTypes:Array<String>=['Andromeda',
        'Vanilla0',
        'Vanilla-like',
        'Quaver',
        'ITG',
        'Kade Engine',
        'Judge Four',
        'Judge Six',
        'JUSTICE',
        'Forever'];
    var accuTypes:Array<String>=['Basic', 'SM', 'Wife3'];
    var timeElapsed:Float = 0;
    override function update(elapsed:Float) {
        super.update(elapsed);
        var selectedSprite = options.members[curSel];

        var arrowX = selectedSprite.x - selectArrow.frameWidth; // sex

       

        selectArrow.x = arrowX;
        selectArrow.y = options.members[curSel].y;

        timeElapsed += elapsed;

        for(i in 0...names.length){
            
            options.members[i].x = options.members[i].x + 0.01 * Math.sin((timeElapsed + i * 0.4) * Math.PI);

        }

        if(!coolControls.activeee){
            if(controls.DOWN_P)changeSel(1);
            if(controls.UP_P)changeSel(-1);
    
            if(controls.RIGHT_P)options.members[curSel].right();
            if(controls.LEFT_P)options.members[curSel].left();
    
            if(controls.BACK){
                OptionUtils.saveOptions(OptionUtils.options);
                FlxG.switchState(new NewMainMenuState());
    
            }
            if(controls.ACCEPT){
                options.members[curSel].accept();
                if(curSel==0){
                    coolControls.activeee = true;
                    FlxTween.tween(coolControls, {alpha:1}, 0.5, {onComplete: function(_) {
                        
                    }});
                }
            }
        }
        else if(coolControls.activeee && controls.BACK){
            coolControls.activeee = false;

            FlxTween.tween(coolControls, {alpha:0}, 0.5);

        }
        
    }
}