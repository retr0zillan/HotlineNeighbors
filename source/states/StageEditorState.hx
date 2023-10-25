package states;
import ui.HealthIcon;
import flixel.tweens.FlxTween;
import ui.Healthbar;
import ui.Checkbox;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import sys.io.File;
import lime.ui.FileDialog;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.util.FlxCollision;
import openfl.events.Event;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxPoint;

import openfl.events.IOErrorEvent;
import haxe.Json;
import openfl.net.FileReference;
import openfl.net.FileFilter;
using StringTools;
import flixel.ui.FlxButton;
import sys.FileSystem;



class StageEditorState extends MusicBeatState{

    var positionsText:FlxText;
    var camFollow:FlxObject;
    var camHUD:FlxCamera;
	var camGame:FlxCamera;
	var helpText:FlxText;
    var posText:FlxText;
    var thisArr:Array<Dynamic>=[];
    var curSelected:Int = 0;
    public var boyfriend:Boyfriend;
    public var dad:Character;
    var animationsCheck:FlxUICheckBox;
    var daS:Stage;
    var controllingAnims:Bool = false;
    var usedObjects:Array<FlxSprite> = [];
    var usedForegroundObjs:Array<FlxSprite> = [];
    var usedChars:Array<FlxSprite> = [];
    var curEditingGroup:Array<String>=['default objects', 'characters', 'foreground objects'];
    var curFocus:String='FREE';
    var curG:FlxText;
    var daG:String;
    var curCharString:String;
    var defIconBf:Bool = true;
    var curChar:Dynamic;
    var charDropdown:FlxUIDropDownMenu;
    var charDropdown2:FlxUIDropDownMenu;
    var UI_box:FlxUITabMenu;
    var UI_box2:FlxUITabMenu;
    public var gf:Character;

    var tabs = [
        {name: "Camera", label: 'Camera'},
        {name: "Assets", label: 'Assets'},
        {name: "Characters", label: 'Characters'},

    ];
    var iconTab = [
        {name: "Icon", label: 'Icon'},
       

    ];
    public static var theGodVar:Bool = true;
     var coolMap:Map<FlxObject,
		Float> = [];
       var offMap:Map<String, Array<Int>>=[];
    
    var cameraZoom:FlxUINumericStepper;
    var sprSize:FlxUINumericStepper;
    var scaler:Float = 1;
    var dropdowns:Array<FlxUIDropDownMenu> = [];
    var stageMap:Map<String, Array<Float>>=[];
    var charCamOffsets:FlxText;
    var iconAnimationList:Array<String> = ['normal', 'losing', 'winning'];
    public var charID:Map<String,
    FlxSprite> = [];
    var focuses:Array<String> = ['FREE','CENTER', 'FOCUS ON BF', 'FOCUS ON DAD'];
    var cameraCenter:FlxUICheckBox;
    var cameraP1:FlxUICheckBox;
    var cameraP2:FlxUICheckBox;
    var cameraFree:FlxUICheckBox;
    var freeX:Float;
    var freeY:Float;
    var camCenterText:FlxText;
    var curIcon:String = 'BF';
    var daCharMan:String;
    var daCharDad:String;
    var curStagee:String;
    var stageDP:FlxUIDropDownMenu;
   var camMenu:FlxCamera;
   var daIns:StageEditorState;
   var stageEditormarker:FlxUICheckBox;
   var iconEditormarker:FlxUICheckBox;
    var currentEdited:String = 'stage';
    var healthBar:Healthbar;
    var tweeners:Array<FlxBasic>=[];
    var wopps:Array<FlxUICheckBox>=[];
   var characters_:Array<String> = EngineData.characters;
   var daIcon:HealthIcon;
    var p1Icons:Array<String> = ['bf', 'coolbf', 'hank'];
   var bfIconString:String;
   var dadIconString:String;
    var iconP1DP:FlxUIDropDownMenu;
    var iconP2DP:FlxUIDropDownMenu;
    var animationsWithSavedOffsets:Array<String>=[];
    var allMap:Map<String, FlxSprite>=[];
    override function create() 
        {
            super.create();
            //based from kade character editor, props to him :)
            camGame = new FlxCamera();

        camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
        camMenu = new FlxCamera();
		camMenu.bgColor.alpha = 0;


		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
        FlxG.cameras.add(camMenu);

		FlxCamera.defaultCameras = [camGame];
  
        
            daIns = this;
            InitState.getCharacters();
    
            FlxG.sound.playMusic(Paths.music('breakfast','shared'));
           
            
           
           
        curStagee = PlayState.curStage;
        daS = new Stage(curStagee, PlayState.daIns.currentOptions);
        if(daS.foreground.members.length <=0){
            var relleno = new FlxSprite(0,0).makeGraphic(1,1, FlxColor.TRANSPARENT);
            daS.foreground.add(relleno);
            daS.foreGroundObjID['relleno']=relleno;

            trace('Foreground empty so lets add smth');
        }
        add(daS);
                

            //daG = curEditingGroup[0];
            daCharDad=PlayState.SONG.player2;
            dad = new Character(PlayState.daIns.dad.x, PlayState.daIns.dad.y, daCharDad, false, !PlayState.daIns.currentOptions.noChars);
            gf = new Character(PlayState.daIns.gf.x, PlayState.daIns.gf.y, PlayState.daIns.gfVersion, false, !PlayState.daIns.currentOptions.noChars);
		    gf.scrollFactor.set(1,1);
           
						
						
				
						daCharMan= PlayState.SONG.player1;

			
					//mog scale 20.5
						
			
                boyfriend = new Boyfriend(PlayState.daIns.boyfriend.x, PlayState.daIns.boyfriend.y, daCharMan, !PlayState.daIns.currentOptions.noChars);
                
                add(dad);
                add(daS.layers.get("dad"));

                
                add(boyfriend);
                add(daS.layers.get("boyfriend"));

                add(daS.foreground);


                charID['dad'] = dad;
                charID['boyfriend'] = boyfriend;
                
                mainMap();
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(daS.centerX, daS.centerY);
        freeX = camFollow.x;
        freeY=camFollow.y;
		add(camFollow);
        parseJson(curStagee);
		
		//camGame.follow(camFollow);
        FlxG.camera.follow(camFollow, LOCKON, Main.adjustFPS(.03));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
	
		FlxG.camera.focusOn(camFollow.getPosition());
        FlxG.camera.zoom = PlayState.defaultCamZoom;

       //curChar=daS.editorContainer[0];

        UI_box = new FlxUITabMenu(null, tabs, true);
        UI_box.cameras = [camMenu];
		UI_box.resize(300, 400);
       
		UI_box.x = 890;
		UI_box.y = 10;
        UI_box.scrollFactor.set();
		add(UI_box);
        UI_box2 = new FlxUITabMenu(null, iconTab, true);
        UI_box2.cameras = [camMenu];
		UI_box2.resize(300, 400);
       
		UI_box2.x = 890;
		UI_box2.y = 10;
        UI_box2.scrollFactor.set();
		add(UI_box2);
        makeTabs(UI_box2, 'icon');
        UI_box2.kill();
        FlxG.mouse.visible = true;
       
        makeTabs(UI_box, 'camera');
        makeTabs(UI_box, 'assets');
        makeTabs(UI_box, 'character');
      
        addEditorsThings();


        curCharString = 'none';

		helpText = new FlxText(70, 40, 0, 'YOU ARE EDITING '+curCharString, 20);
		helpText.scrollFactor.set();
		helpText.cameras = [camMenu];
		helpText.color = FlxColor.WHITE;
        helpText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2,1);
		add(helpText);
       
        posText = new FlxText(helpText.x+10, 0, 0,'X: '+0 + 'Y: '+0, 20);
		posText.scrollFactor.set();
		posText.cameras = [camMenu];
		posText.color = FlxColor.WHITE;
        posText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2,1);

		add(posText);

        curG = new FlxText(posText.x -20, posText.y + 120, 0, 'CURRENT GROUP '+daG, 20);
		curG.scrollFactor.set();
		curG.cameras = [camMenu];
		curG.color = FlxColor.WHITE;
        curG.setBorderStyle(OUTLINE, FlxColor.BLACK, 2,1);

		add(curG);
     

        charCamOffsets = new FlxText(posText.x -40, posText.y + 640, 0, 'CHAR CAMERA OFFSETS ', 20);
		charCamOffsets.scrollFactor.set();
		charCamOffsets.cameras = [camMenu];
		charCamOffsets.color = FlxColor.WHITE;
        charCamOffsets.alpha=0;
        charCamOffsets.setBorderStyle(OUTLINE, FlxColor.BLACK, 2,1);
		add(charCamOffsets);


        tweeners.push(charCamOffsets);

        camCenterText = new FlxText(posText.x -40, posText.y + 570, 0, 'CAMERA CENTER ', 20);
		camCenterText.scrollFactor.set();
		camCenterText.cameras = [camMenu];
		camCenterText.color = FlxColor.WHITE;
        camCenterText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2,1);

		add(camCenterText);
        tweeners.push(camCenterText);
         bfIconString=boyfriend.iconName;
         dadIconString = dad.iconName;

		healthBar = new Healthbar(0,FlxG.height*.8,bfIconString,dadIconString,this,'health',0,2);
		healthBar.smooth = true;
		healthBar.x = FlxG.width/2 - 293;
		healthBar.scrollFactor.set();

		healthBar.setColors(dad.iconColor,boyfriend.iconColor);
        add(healthBar);
        daIcon = healthBar.iconP1;
      
        healthBar.cameras = [camMenu];
        healthBar.kill();
        changeGroup(0);
       
        
        
      
        }
        var _file:FileReference;

        function saveCamOffsets(){
            if(curChar!=null && curChar.camOffset.x!=null && curChar.camOffset.y!=null && daG == 'characters' && (curFocus == 'FOCUS ON DAD'||curFocus == 'FOCUS ON BF'))
                {
                    curChar.charData.camOffset[0] = curChar.camOffset.x;
                    curChar.charData.camOffset[1] = curChar.camOffset.y;

                    saveCamOff(Json.stringify(curChar.charData,"\t"),'${curChar.curCharacter}${curChar.isPlayer==true?"-player":""}.json');

                }

        }
        private function saveCamOff(data:String,name:String)
            {
              if ((data != null) && (data.length > 0))
              {
                _file = new FileReference();
                _file.addEventListener(Event.COMPLETE, onSaveComplete);
                _file.addEventListener(Event.CANCEL, onSaveCancel);
                _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                _file.save(data.trim(), name);
              }
            }
          
        function addEditorsThings()
            {
                stageEditormarker = new FlxUICheckBox(963, 624, null, null, "Toggle stage editing", 200);
                stageEditormarker.checked = true;
             
                stageEditormarker.box.scale.set(2.5,2.5);
                stageEditormarker.mark.scale.set(2.5,2.5);

                
                stageEditormarker.button.label.scale.set(2.5,2.5);
                stageEditormarker.textX += 180;
                stageEditormarker.callback = function()
                    //stageEditormarker.max_width = 1000*1000;
               
                {
                   if(currentEdited!='stage')
                    {
                        someName('stage');

                    }
                    else
                        {
                            stageEditormarker.checked=true;
                        }
                };
                
                stageEditormarker.scrollFactor.set();
               
                add(stageEditormarker);
             
                wopps.push(stageEditormarker);
               

            
                stageEditormarker.cameras = [camMenu];
             
            }
            private function save(data:String,name:String)
                {
                  if ((data != null) && (data.length > 0))
                  {
                    _file = new FileReference();
                    _file.addEventListener(Event.COMPLETE, onSaveComplete);
                    _file.addEventListener(Event.CANCEL, onSaveCancel);
                    _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                    _file.save(data.trim(), name);
                  }
                }
              
                function onSaveComplete(_):Void
                {
                  _file.removeEventListener(Event.COMPLETE, onSaveComplete);
                  _file.removeEventListener(Event.CANCEL, onSaveCancel);
                  _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                  _file = null;
                  FlxG.log.notice("Successfully saved LEVEL DATA.");
                 
                }
              
                function onSaveCancel(_):Void
                {
                  _file.removeEventListener(Event.COMPLETE, onSaveComplete);
                  _file.removeEventListener(Event.CANCEL, onSaveCancel);
                  _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                  _file = null;
               
                }
              
                function onSaveError(_):Void
                {
                  _file.removeEventListener(Event.COMPLETE, onSaveComplete);
                  _file.removeEventListener(Event.CANCEL, onSaveCancel);
                  _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                  _file = null;
                  FlxG.log.error("Problem saving Level data");
              
                }
            function someName(act:String)
                {
                    switch(act)
                    {
                        case 'icon': 
                            stageEditormarker.checked=false;
                        currentEdited='icon';
                        UI_box.kill();
                        healthBar.revive();
                        UI_box2.revive();
                       
                        for(b in 0...tweeners.length)
                            {
                               tweeners[b].visible = false;
                            }
                            for(p in 0...wopps.length)
                                {
                                    //FlxTween.tween(wopps[p], {y:wopps[p].y -300}, 0.9+(p*0.3));
                                    wopps[p].y = wopps[p].y -200;
                                }
                        
                        trace("got hit in icon");
                        case 'stage': 
                            iconEditormarker.checked=false;
                            currentEdited = 'stage';
                            UI_box2.kill();
                            healthBar.kill();
                            UI_box.revive();
                            for(b in 0...tweeners.length)
                                {
                                    tweeners[b].visible = true;
                                }
                                iconEditormarker.y = 674;
                                stageEditormarker.y = 624;
                            trace("got hit in stage");

                    }
                }
        function refreshStage()
            {
                remove(daS);
                remove(daS.foreground);
                curStagee = stageDP.selectedLabel;
                daS = new Stage(curStagee, PlayState.daIns.currentOptions);
                add(daS);
                add(daS.foreground);
                switch(daG)
                    {
                        case 'default objects': 
                            animationsCheck.checked = false;
                            getNextObject('default');
                            case 'characters': 
                                getNextObject('foreground'); 
                                case 'foreground objects': 
                                    animationsCheck.checked = false;
                                    getNextObject('char');
                    }
                    sprSize.value = 1;
            }
        function showCharacter(char:String = 'bf')
            {
                switch(char)
                {
                    case 'bf': 
                        remove(boyfriend);
                        daCharMan = charDropdown.selectedLabel;
                        boyfriend = new Boyfriend(PlayState.daIns.boyfriend.x, PlayState.daIns.boyfriend.y, daCharMan, !PlayState.daIns.currentOptions.noChars);
                        add(boyfriend);
                       charID['boyfriend'] = boyfriend;
                       allMap.set(daCharMan, boyfriend);

                       next();
                    case 'dad': 
                        remove(dad);
                        daCharDad = charDropdown2.selectedLabel;
                        dad = new Character(PlayState.daIns.dad.x, PlayState.daIns.dad.y, daCharDad, false, !PlayState.daIns.currentOptions.noChars);
                        add(dad);
                       charID['dad'] = dad;
                       allMap.set(daCharDad, dad);

                       next();

                }
                
            }
            function mainMap()
                {
                    for(str => spr in daS.objectID)
                        {
                            allMap.set(str, spr);
                        }
                        for(str => spr in daS.foreGroundObjID)
                            {
                                allMap.set(str, spr);
                            }
                            allMap.set(daCharDad, dad);
                            allMap.set(daCharMan, boyfriend);
                            if(gf!=null)
                                allMap.set(gf.curCharacter, gf);


                }
        function getNextObject(what:String):Void
            {
                switch(what)
                {
                    case 'foreground': 
                        for (key => value in daS.foreGroundObjID)
                            {
                                if (!usedForegroundObjs.contains(value))
                                {
                                    usedForegroundObjs.push(value);
                                    curCharString = key;
                                    curChar = value;
                                   
                                    return;
                                }
                               
                            }
                            usedForegroundObjs = [];
                            getNextObject('foreground');

                        case 'default':
                            for (key => value in daS.objectID)
                                {
                                    if (!usedObjects.contains(value))
                                    {
                                        usedObjects.push(value);
                                        curCharString = key;
                                        curChar = value;
                                       
                                        return;
                                    }
                                   
                                }
                                usedObjects = [];
                                getNextObject('default');
                            case 'char': 
                                for (key => value in charID)
                                    {
                                        if (!usedChars.contains(value))
                                        {
                                            usedChars.push(value);
                                            curCharString = key;
                                            curChar = value;
                                           
                                            return;
                                        }
                                       
                                    }
                                    usedChars = [];
                                    getNextObject('char');
                }
               
               
            }
         
            override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
                if(id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
                    if (sender == sprSize)
                    {
                       
                        scaler = sender.value;
                        curChar.setGraphicSize(Std.int(curChar.frameWidth*scaler));
                       
                    }
                    if (sender == cameraZoom)
                        {
                           
                            camGame.zoom = cameraZoom.value;
                           
                        }
                }
            }
            var def:Int = 0;
            function changeGroup(changer:Int=0){
                def+=changer;
                if(def>curEditingGroup.length-1)
                    {
                        def = 0;
                    }
                    daG = curEditingGroup[def];
                    curG.text = 'CURRENT GROUP '+daG;
                    switch(daG)
                    {
                        case 'default objects': 
                            animationsCheck.checked = false;
                            getNextObject('default');
                            case 'characters': 
                                getNextObject('char'); 
                                case 'foreground objects': 
                                    animationsCheck.checked = false;
                                    getNextObject('foreground');
                    }
            }
           
             
                    function makeTabs(daBox:FlxUITabMenu, eltab:String)
                        {
                            switch(eltab)
                            {
                                case 'camera': 
                                    var cameraST = new FlxText(10, 61, 'Camera styles');
                                    var cameraF = new FlxUIDropDownMenu(10, 80, FlxUIDropDownMenu.makeStrIdLabelArray(focuses, true), function(cfocus:String)
                                        {
                                            curFocus = focuses[Std.parseInt(cfocus)];
                                            
                                        });
                                        cameraF.dropDirection = FlxUIDropDownMenuDropDirection.Down;
                                    
                                        cameraF.selectedLabel = curFocus;
                                        dropdowns.push(cameraF);
            
            
                                       
                                    cameraZoom = new FlxUINumericStepper(10, 40, 0.1,PlayState.defaultCamZoom, 0.1, 20, 1);
                                    cameraZoom.value = camGame.zoom;
                                    cameraZoom.name = 'zoom';
                            
                                    var cameraZoomT = new FlxText(10, 25, 'Cur zoom');
                            
                                    var tab_camera = new FlxUI(null, UI_box);
                                    tab_camera.name = "Camera";
                                    tab_camera.add(cameraZoom);
                                    tab_camera.add(cameraZoomT);
                                    tab_camera.add(cameraF);
                                    tab_camera.add(cameraST);
            
            
                                    daBox.addGroup(tab_camera);
                                case 'assets': 
                                    sprSize = new FlxUINumericStepper(10, 40, 0.1, scaler, 0.1, 90, 1);
                                    sprSize.value = scaler;
                                    sprSize.name = 'size';
                                    var sprSizeT = new FlxText(10, 25, 'Spr size');
                                    var tab_ass = new FlxUI(null, UI_box);
                                    tab_ass.name = "Assets";
                            
                                    var saveButton:FlxButton = new FlxButton(10, 70, "Save scale", function()
                                        {
                                           
                            
                                            coolMap[curChar] = sprSize.value;
                                        });
                                        var saveButton2:FlxButton = new FlxButton(110, 70, "Save json", function()
                                            {
                                               
                                
                                                //var curStage = stageMap.get(curStagee);
                                                
                                                for (str => spr in allMap)
                                                    {
                                                       
                                                      
                                                                stageMap.set(str, [spr.x, spr.y]);
                                                           
                                                        
                                                        /*
                                                        for(str in daS.objectID.keys())
                                                            {
                                                                
                                                            }
                                                       */
                                                        trace(stageMap);
                                                    }
                                                   save(Json.stringify(stageMap,"\t"),'${curStagee}.json');
                                                    trace("done");
                                            });
                                        var stage = new FlxText(10, 105, 'Stage list');
                                        stageDP = new FlxUIDropDownMenu(10, 120, FlxUIDropDownMenu.makeStrIdLabelArray(Stage.stageNames, true), function(stage:String)
                                            {
                                                curStagee = Stage.stageNames[Std.parseInt(stage)];
                                                refreshStage();
                                            });
                                            stageDP.dropDirection = FlxUIDropDownMenuDropDirection.Down;
                                        
                                            stageDP.selectedLabel = curStagee;
                                            dropdowns.push(stageDP);
                                    tab_ass.add(sprSize);
                                    tab_ass.add(sprSizeT);
                                    tab_ass.add(saveButton);
                                    tab_ass.add(saveButton2);

                                    tab_ass.add(stageDP);
                                    tab_ass.add(stage);
                                    daBox.addGroup(tab_ass);
            
                                case 'character':
                                    var characters = new FlxUI(null, UI_box);
                                    characters.name = "Characters";
                            
                            
                                    
                                    animationsCheck = new FlxUICheckBox(10, 40, null, null, "Control this character animations", 100);
                                    animationsCheck.checked = controllingAnims;
                                    animationsCheck.callback = function()
                                    {
                                        if(daG == 'characters')
                                            {
                                                controllingAnims = !controllingAnims;
                            
                                            }
                                            else
                                                {
                                                    animationsCheck.checked = false;
                                                }
                                    };
                            
                                    characters.add(animationsCheck);
                                    var charP1 = new FlxText(10, 92, 'Bf list');
                                    var charP2 = new FlxText(140, 92, 'Dad list');
                                    charDropdown = new FlxUIDropDownMenu(10, 110, FlxUIDropDownMenu.makeStrIdLabelArray(characters_, true), function(character:String)
                                        {
                                            daCharMan = characters_[Std.parseInt(character)];
                                            showCharacter('bf');
                                        });
                                    charDropdown.dropDirection = FlxUIDropDownMenuDropDirection.Down;
                                    
                                    charDropdown.selectedLabel = daCharMan;
                                    dropdowns.push(charDropdown);
                                    charDropdown2 = new FlxUIDropDownMenu(140, 110, FlxUIDropDownMenu.makeStrIdLabelArray(characters_, true), function(character:String)
                                        {
                                            daCharDad = characters_[Std.parseInt(character)];
                                            showCharacter('dad');
                                        });
                                    charDropdown2.dropDirection = FlxUIDropDownMenuDropDirection.Down;
                                    
                                    charDropdown2.selectedLabel = daCharDad;

                                    var camOffSave = new FlxButton(140,40, 'Save Camera Offsets', function(){
                                        saveCamOffsets();
                                    });

                                    dropdowns.push(charDropdown2);
                            
                                    characters.add(charDropdown);
                                    characters.add(charDropdown2);
                                    characters.add(charP1);
                                    characters.add(charP2);
                                    characters.add(camOffSave);
                                    daBox.addGroup(characters);

                                  

                            }
                        }
                        function parseJson(XD:String)
                            {
                                var path = 'assets/stages/${XD}.json';
                                //var shit:Null<Dynamic>=null;
                                if(FileSystem.exists(path)){
                                    var deta = Json.parse(File.getContent(path));
                
                                     for(field in Reflect.fields(deta))
                                        {
                                            stageMap.set(field, Reflect.field(deta, field));
                                        }
                                  
                                        for(str=>spr in allMap)
                                            {
                                                var mappy = stageMap[str];
                                                if(spr!=null && spr!=dad && spr!=boyfriend && spr!=gf)
                                                    {
                                                        if(stageMap.exists(str))
                                                        spr.setPosition(mappy[0], mappy[1]);
                                                        else
                                                            spr.setPosition(0,0);
                                                        
                                                    }
                                                    else
                                                        {
                                                            trace('found a null character${str}');
                                                        }
                                                
                                            }
                                        
                                        
                                            
                                            if(stageMap.exists(gf.curCharacter))
                                                {
                                                    var gfPos = new FlxPoint(stageMap[gf.curCharacter][0], stageMap[gf.curCharacter][1]);
                                                    gf.setPosition(gfPos.x,gfPos.y);
                                                    trace("found gf position data");
                
                                                }
                                                else
                                                    {
                                                        trace("dad gf no position data");
                                                    }
                                            if(stageMap.exists(dad.curCharacter))
                                                {
                                                    var dadPos = new FlxPoint(stageMap[dad.curCharacter][0], stageMap[dad.curCharacter][1]);
                                                    dad.setPosition(dadPos.x,dadPos.y);
                                                    trace("found dad position data");
                
                                                }
                                                else
                                                    {
                                                        trace("dad has no position data");
                                                    }
                                                    if(stageMap.exists(daCharMan))
                                                        {
                                                            var bfPos = new FlxPoint(stageMap[daCharMan][0], stageMap[daCharMan][1]);
                                                            boyfriend.setPosition(bfPos.x,bfPos.y);
                                                            trace("found bf position data");
                
                                                        }
                                                        else{
                                                            trace("bf has no position data");
                
                                                        }
                                    
                                     trace(boyfriend.curCharacter);
                                    trace("WE PARSED THE STAGE JSON LETS GOOO");
                                }
                                else
                                    {
                                        trace("FUCKKKKKK THERES NO STAGE JSON BRO");
                                    }
                                    
                            }
                        
               function updateStuffOff(?what:String='stage')
                {
                    switch(what)
                    {
                        case 'stage': 
                          
                            if(curChar == boyfriend || curChar == dad)
                                {
                                    charCamOffsets.text = 'CHAR CAMERA OFFSETS '+'X: '+curChar.camOffset.x + 'Y: '+ curChar.camOffset.y;
                                    charCamOffsets.alpha = 1;
                                }
                                else
                                    {
                                        charCamOffsets.alpha=0;
                                    }
                            curG.text = 'CURRENT GROUP '+daG;
                            if (FlxG.keys.justPressed.SHIFT)
                                {
                                 
                                    changeGroup(1);
                                        
                                  
                                }
                            if (FlxG.keys.justPressed.SPACE)
                                {
                                    
                                     
                                    next();
                                    
                                     
                                  
                                }
                                var bfMid = boyfriend.getMidpoint();
                                    var dadMid = dad.getMidpoint();
                                    camCenterText.text = 'CAMERA CENTER '+ 'X: '+ daS.centerX+ 'Y: '+daS.centerY;
                                switch(curFocus)
                                {
                                    case 'FREE': 
                                        camFollow.setPosition(freeX, freeY);
                                        if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
                                            {
                                                if (FlxG.keys.pressed.I)
                                                    freeY -= 3;
                                                else if (FlxG.keys.pressed.K)
                                                    freeY += 3;
                                               
                                    
                                                if (FlxG.keys.pressed.J)
                                                    freeX -=3;
                                                else if (FlxG.keys.pressed.L)
                                                    freeX += 3;
                                                
                                            }
            
                                    case 'CENTER': 
                                        camFollow.setPosition(daS.centerX, daS.centerY);

                                        if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
                                            {
                                                if (FlxG.keys.pressed.I)
                                                    daS.centerY -= 1;
                                                else if (FlxG.keys.pressed.K)
                                                    daS.centerY += 1;
                                               
                                    
                                                if (FlxG.keys.pressed.J)
                                                    daS.centerX -=1;
                                                else if (FlxG.keys.pressed.L)
                                                    daS.centerX += 1;
                                                
                                            }
                                            
                                        case 'FOCUS ON BF': 
                                            camFollow.setPosition(bfMid.x - daS.camOffset.x  + boyfriend.camOffset.x, bfMid.y - daS.camOffset.y + boyfriend.camOffset.y);
                                            case 'FOCUS ON DAD':
                                                camFollow.setPosition(dadMid.x + dad.camOffset.x, dadMid.y + dad.camOffset.y);
                                           
                                            
                                }
                               
                                
                                     if(daG == 'characters' && (curFocus == 'FOCUS ON DAD'||curFocus == 'FOCUS ON BF'))
                                        {
                                            if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
                                                {
                                                    if (FlxG.keys.pressed.I)
                                                        curChar.camOffset.y -= 1;
                                                    else if (FlxG.keys.pressed.K)
                                                        curChar.camOffset.y += 1;
                                                   
                                        
                                                    if (FlxG.keys.pressed.J)
                                                        curChar.camOffset.x -=1;
                                                    else if (FlxG.keys.pressed.L)
                                                        curChar.camOffset.x += 1;
                                                    
                                                }
                                               
                                        }
                           
                                
                             
                                FlxG.watch.addQuick('Camera Zoom', camGame.zoom);
                        
                                
                                        helpText.text = 'YOU ARE EDITING '+curCharString;
                                   
                           
                            
                            if(curChar!=null)
                                {
                                   
                                    posText.text = 'X: '+curChar.x + 'Y: '+curChar.y;
                                   
                                       
            
                                    
                                }
                           
                                if(!controllingAnims)
                                    {
                                        if(FlxG.keys.pressed.LEFT)
                                            {
                                                curChar.x -= 1;
                                              
                                            }
                                            if(FlxG.keys.pressed.RIGHT)
                                                {
                                                    curChar.x += 1;
                                                  
            
                                                }
                                                if(FlxG.keys.pressed.UP)
                                                    {
                                                        curChar.y -= 1;
                                                     
            
                        
                                                    }
                                                    if(FlxG.keys.pressed.DOWN)
                                                        {
                                                            curChar.y += 1;
            
                                                           
            
                                                        }
                                                     
                                                     
            
                                    }
                                    else if(controllingAnims && daG == 'characters')
                                        {
                                            if(FlxG.keys.pressed.LEFT)
                                                {
                                                    curChar.playAnim('singLEFT');
                                                }
                                                if(FlxG.keys.pressed.RIGHT)
                                                    {
                                                        curChar.playAnim('singRIGHT');
                                                    }
                                                    if(FlxG.keys.pressed.UP)
                                                        {
                                                            curChar.playAnim('singUP');
            
                            
                                                        }
                                                        if(FlxG.keys.pressed.DOWN)
                                                            {
                                                                curChar.playAnim('singDOWN');
                            
                                                            }
                                                            if(FlxG.keys.justReleased.ANY)
                                                                {
                                                                    curChar.dance();
                                                                }
                                        }
                                      

                                        
                                           
                                               
                                                       
                                                                     
                                                                     
                            
                                                   
                                                      
                    }
                }
                function next()
                    {
                        switch(daG)
                        {
                            case 'default objects': 
                                getNextObject('default');
                                case 'characters': 
                                    getNextObject('char'); 
                                    case 'foreground objects': 
                                        getNextObject('foreground');
                        }
                       
                        if (coolMap.exists(curChar)) {
                            var val = coolMap[curChar];
                            sprSize.value = val;
                            trace("found a value in the map");
                          }
                          else
                            {
                                sprSize.value = 1;
                                trace("not a value found");

                            }
                            
                          
                    }
               
                var iconIti:Int = 0;
        override function update(elapsed:Float)
            {
            
               
                Conductor.songPosition = FlxG.sound.music.time;
          
                if(FlxG.keys.justPressed.ESCAPE){
                    FlxG.sound.music.stop();
                    Conductor.changeBPM(0);
                    theGodVar=false;
                    FlxG.switchState(new PlayState());
                  }
                  var canInput = true;


                  if(canInput){
                      for(drop in dropdowns){
                          if(drop.dropPanel.visible
                              #if FLX_MOUSE
                                  && FlxG.mouse.overlaps(drop)
                              #end
                          ){
                              canInput=false;
                              break;
                          }
                      }
                  }
                switch(currentEdited)
                {
                    case 'stage': 
                        updateStuffOff('stage');

                  

                }
                              super.update(elapsed);
            }
}
typedef StructData ={
  
    var coolAOMap:Map<String, Array<Int>>;
    }

