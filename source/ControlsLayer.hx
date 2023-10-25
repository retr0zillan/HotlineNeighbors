package;

import flixel.math.FlxPoint;
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
import flixel.group.FlxSpriteGroup;

class ControlsLayer extends FlxSpriteGroup{
    var keys:FlxSprite;
    var shiiiiit:Array<String>=[];
    //left,down,right, up
    var positions:Array<FlxPoint>=[new FlxPoint(875,208), new FlxPoint(1018, 209), new FlxPoint(1160, 209), new FlxPoint(1017, 65)];
   
    var keySelectorPositions:Array<FlxPoint>=[new FlxPoint(814+20,167), new FlxPoint(958+20, 167), new FlxPoint(1101+20, 167), new FlxPoint(958+20, 17)];
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
    var keyHolder:Array<FlxText>=[];
    var selector:FlxSprite;
   public var activeee:Bool = false;
    public function new(x:Float, y:Float){
        super(x,y);

        keys = new FlxSprite(829, 33);
        keys.frames = Paths.getSparrowAtlas('Options2','preload');
        keys.animation.addByPrefix('idle', 'Keys', 24, true);
        keys.animation.play('idle');
        keys.antialiasing=true;
        add(keys);


       

        for(i in 0...4){
            var key = new FlxText(positions[i].x , positions[i].y , 0,'?', 47);
            key.alignment = CENTER;
            key.font = 'assets/fonts/justiceoutsemital.ttf';
            key.color = 0xFFf8e943;

            add(key);

            switch(i){
                //left
                case 0:
                   var controlType:Control = Control.LEFT;
                    key.text = '${OptionUtils.getKey(controlType).toString()}';
                //down
                case 1: 
                    var controlType:Control = Control.DOWN;
                    key.text = '${OptionUtils.getKey(controlType).toString()}';
                //right
                case 2:
                    var controlType:Control = Control.RIGHT;
                    key.text = '${OptionUtils.getKey(controlType).toString()}';
                //up 
                case 3: 
                    var controlType:Control = Control.UP;
                    key.text = '${OptionUtils.getKey(controlType).toString()}';
                    

            }
            if(converMap.exists(key.text)){
                key.text = converMap.get(key.text);
                trace('converting to ${key.text}');
            }

            keyHolder.push(key);
        }



        selector = new FlxSprite(824,167);
        selector.frames = Paths.getSparrowAtlas('Options2','preload');
        selector.animation.addByPrefix('idle', 'SelectBox', 24, true);
        selector.animation.play('idle');
        selector.antialiasing=true;
        add(selector);

    }
    var curKey:Int = 0;
    //Hardcoding the shit out of this cuz im not planning on adding anything else

    var currentControlType:Control;
    var converMap:Map<String,String>=[
    'RIGHT'=>'RT',
    'LEFT'=>'LT',
    'DOWN'=>'DW',
    'PERIOD'=>'.',
    'COMMA'=>',',
    'MINUS'=>'-',
    'QUOTE'=>'?',
    'SLASH'=>'/',
    'INSERT'=>'IN',
    'END'=>'EN',
    'PAGEDOWN'=>'PD',
    'PAGEUP'=>'PU',
    'HOME'=>'HM',
    'DELETE'=>'DEL',
    'ZERO'=>'0',
    'ONE'=>'1',
    'TWO'=>'2',
    'THREE'=>'3',
    'FOUR'=>'4',
    'FIVE'=>'5',
    'SIX'=>'6',
    'SEVEN'=>'7',
    'EIGHT'=>'8',
    'NINE'=>'9',
    'NUMPADZERO'=>'N0',
    'NUMPADONE'=>'N1',
    'NUMPADTWO'=>'N2',
    'NUMPADTHREE'=>'N3',
    'NUMPADFOUR'=>'N4',
    'NUMPADFIVE'=>'N5',
    'NUMPADSIX'=>'N6',
    'NUMPADSEVEN'=>'N7',
    'NUMPADEIGHT'=>'N8',
    'NUMPADNINE'=>'N9',
    'NUMPADMINUS'=>'N-',
    'NUMPADSLASH'=>'N/',
    'NUMPADMULTIPLY'=>'N*',
    'NUMPADPERIOD'=>'N.',
    'NUMLOCK'=>'NL',



    ];
    function checkSpecial(str:String){
       
    }
    function changeInput(key:Int){

        switch(key){
            //left
            case 0:
                currentControlType = Control.LEFT;
             //down
             case 1: 
                currentControlType = Control.DOWN;

             //right
             case 2:
                currentControlType = Control.RIGHT;

             //up 
             case 3: 
                currentControlType = Control.UP;

        }
    }
    var allowMultiKeyInput:Bool = false;
	public  function keyPressed(pressed:FlxKey){
		//FlxKey.fromString(String.fromCharCode(event.charCode));
         var key:FlxKey;
         key=OptionUtils.getKey(currentControlType);

		for(k in OptionUtils.shit){
			if(pressed==k){
				pressed=-1;
				break;
			};
		};
		if(pressed!=BACKSPACE){
			OptionUtils.options.controls[OptionUtils.getKIdx(currentControlType)]=pressed;
			key=pressed;
		}
		keyHolder[curKey].text='${OptionUtils.getKey(currentControlType).toString()}';
        if(keyHolder[curKey].text == 'null')
            keyHolder[curKey].text = '?';

        

		if(pressed!=-1){
            if(converMap.exists(keyHolder[curKey].text)){
                keyHolder[curKey].text = converMap.get(keyHolder[curKey].text);
                trace('converting to ${keyHolder[curKey].text}');
            }
			trace("epic style " + pressed.toString() );
			controls.setKeyboardScheme(Custom,true);
			allowMultiKeyInput=false;
			return true;
		}
		return true;
	}
    public  function accept():Bool{
		changeInput(curKey);

		controls.setKeyboardScheme(None,true);
		allowMultiKeyInput=true;
		//FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		keyHolder[curKey].text = "?";
		return true;
	};
    
    override function update(elapsed:Float) {
        super.update(elapsed);
        

        FlxG.watch.addQuick('currentKey', curKey);
        if(activeee){
            updateCrap();
        }
        
       
    }

    function updateCrap(){
        var pressed = FlxG.keys.firstJustPressed();
        var released = FlxG.keys.firstJustReleased();
        if(controls.ACCEPT && !allowMultiKeyInput){

            accept();
         }
 
         if(allowMultiKeyInput){
            
           if(pressed!=-1){
             keyPressed(pressed);
           }
 
           if(released!=-1){
           
         }
         }
         else if(!allowMultiKeyInput){
             if(controls.LEFT_P){
             
                 switch(selector.x)
                 {
                   case 824: 
                   
                   case 968:
                       if(selector.y==167){
                           selector.x = 824;
                           curKey=0;
                       } 
                   
       
                   case 1111: 
                   selector.x = 968;
                   curKey=1;
       
       
       
                 }
               }
               if(controls.RIGHT_P){
                   switch(selector.x)
                 {
                   case 824: 
                       selector.x = 968;
                       curKey=1;
       
       
                   case 968: 
                       if(selector.y==167){
                       selector.x = 1111;
                       curKey=2;
                       }
       
                   case 1111: 
                      
       
       
                 }
               }
               if(controls.DOWN_P){
                   if(selector.x == 968 && selector.y==17){
                       selector.y = 167;
                       curKey = 1;
                   }
               }
               if(controls.UP_P){
                   if(selector.x == 968 && selector.y==167){
                       selector.y = 17;
                       curKey = 3;
       
                   }
               }
         }
    }
}