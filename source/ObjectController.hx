import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
class ObjectController extends FlxSpriteGroup
{
    var classObj:FlxSprite;
    var pulse:Int;
    var forced:Bool;
   public var forcedX:Float = 0;
    public var forcedY:Float= 0;
    public var sizeControl:Bool = false;
    public function new(Object:FlxSprite, ?Strength:Int = 1, ?forcedVal:Bool= false, ?sizeController:Bool=false)
        {
            super();
            this.classObj = Object;
            this.pulse = Strength;
            this.forced=forcedVal;
           this.sizeControl = sizeController;
        
            if(Strength<=0)
                {
                    Strength=1;
                }
        }
        var scaler:Float = 1;
        override function update(elapsed:Float) {
            super.update(elapsed);
            var left=FlxG.keys.pressed.LEFT;
            var right=FlxG.keys.pressed.RIGHT;
            var up=FlxG.keys.pressed.UP;
            var down=FlxG.keys.pressed.DOWN;


            if(sizeControl){
                FlxG.watch.addQuick('Scaler', scaler);

                classObj.setGraphicSize(Std.int(classObj.frameWidth*scaler));


                if(FlxG.keys.pressed.Q){
                    scaler -= 0.01;
                }
                if(FlxG.keys.pressed.E){
                    scaler += 0.01;

                }
            }
            if(forced)
                {
                    FlxG.watch.addQuick('Obj X', forcedX);
                    FlxG.watch.addQuick('Obj Y', forcedY);

                    if(left)
                        {
                            classObj.x -= pulse;
                            forcedX -= pulse;

                        }
                        if(right)
                            {
                                classObj.x += pulse;
                                forcedX += pulse;

                            }
                            if(up)
                                {
                                    classObj.y -= pulse;
                                    forcedY -= pulse;

                                }
                                if(down)
                                    {
                                        classObj.y += pulse;
                                        forcedY += pulse;

                                    }
                }
                else
                    {
                        FlxG.watch.addQuick('Obj X', classObj.x);
                        FlxG.watch.addQuick('Obj Y', classObj.y);
            
                        if(left)
                            {
                                classObj.x -= pulse;
                            }
                            if(right)
                                {
                                    classObj.x += pulse;
                                }
                                if(up)
                                    {
                                        classObj.y -= pulse;
                                    }
                                    if(down)
                                        {
                                            classObj.y += pulse;
                                        }
                    }
        
        }
}