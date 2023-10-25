package;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import ui.*;
import flixel.group.FlxSpriteGroup;

class HotOption extends FlxSpriteGroup
{
  public var type:String = "Option";
  public var parent:OptionCategory;
  public var name:String = "Option";
  public var description:String = "";
  public var allowMultiKeyInput=false;
  public var text:Alphabet;
  public var isSelected:Bool=false;

  public function new(x:Float, y:Float, ?name:String){
    super(x,y);
    this.type = "Option";
    if(name!=null){
      this.name = name;
    }
  }

  public function keyPressed(key:FlxKey):Bool{
    trace("Unset");
    return false;
  }
  public function keyReleased(key:FlxKey):Bool{
    trace("Unset");
    return false;
  }

  public function accept():Bool{
    trace("Unset");
    return false;
  };
  public function right():Bool{
    trace("Unset");
    return false;
  };
  public function left():Bool{
    trace("Unset");
    return false;
  };
  public function selected():Bool{
    trace("Unset");
    return false;
  };
  public function deselected():Bool{
    trace("Unset");
    return false;
  };


  override function update(elapsed:Float){
    super.update(elapsed);
  };
}
