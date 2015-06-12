/**
 * Created by user on 6/11/15.
 */
package hint {
import manager.Vars;

import starling.display.Image;


import starling.display.Quad;
import starling.display.Sprite;

import starling.text.TextField;
import starling.utils.Color;

public class Hint {
    public var source:Sprite;
    private var _contHint:Sprite;
    private var _txtHintOne:TextField;
    private var _txtHintTwo:TextField;
    private var _isShow:Boolean;
    private var _delta:int;
    private var _timer:int;

    private var _hintSide1:Image;
    private var _hintSide2:Image;
    private var _hintSide3:Image;
    private var _hintSide4:Image;
    private var _hintTopLeftPort1:Image;
    private var _hintTopLeftPort2:Image;
    private var _hintTopLeftPort3:Image;
    private var _hintTopLeftPort4:Image;
    private var _hintMiddle:Image;



    private var g:Vars = Vars.getInstance();

    public function Hint() {
        source = new Sprite();
        _contHint = new Sprite();

        _isShow = false;

         _hintSide1 = new Image(g.interfaceAtlas.getTexture("hintSidePixels"));
         _hintSide2 = new Image(g.interfaceAtlas.getTexture("hintSidePixels"));
         _hintSide3 = new Image(g.interfaceAtlas.getTexture("hintSidePixels"));
         _hintSide4 = new Image(g.interfaceAtlas.getTexture("hintSidePixels"));
         _hintTopLeftPort1 = new Image(g.interfaceAtlas.getTexture("hintTopLeftPart"));
         _hintTopLeftPort2 = new Image(g.interfaceAtlas.getTexture("hintTopLeftPart"));
         _hintTopLeftPort3 = new Image(g.interfaceAtlas.getTexture("hintTopLeftPart"));
         _hintTopLeftPort4 = new Image(g.interfaceAtlas.getTexture("hintTopLeftPart"));
         _hintMiddle = new Image(g.interfaceAtlas.getTexture("hintMiddle"));
        _contHint.addChild(_hintSide1);
        _contHint.addChild(_hintSide2);
        _contHint.addChild(_hintSide3);
        _contHint.addChild(_hintSide4);
        _contHint.addChild(_hintTopLeftPort1);
        _contHint.addChild(_hintTopLeftPort2);
        _contHint.addChild(_hintTopLeftPort3);
        _contHint.addChild(_hintTopLeftPort4);
        _contHint.addChild(_hintMiddle);
        source.addChild(_contHint);
        _txtHintOne = new TextField(70,50,"one ","Arial",14,Color.BLACK);
        _txtHintTwo = new TextField(70,25,"two ","Arial",14,Color.BLACK);
        _txtHintTwo.y = _txtHintOne.y + 30;
        source.addChild(_txtHintOne);
        source.addChild(_txtHintTwo);

//        source.addChild(_txtHintTwo);

    }

    public function showIt(name:String, number:String):void {
        if(_isShow) return;
        _isShow = true;
        g.cont.hintCont.addChild(source);


        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function createHide():void {
        var i:int;
//        _hintMiddle.width =



    }

    private function onEnterFrame():void{
        source.x = g.ownMouse.mouseX + 20;
        source.y = g.ownMouse.mouseY - 40;
    }

    public function hideIt():void {
        _isShow = false;
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.cont.hintCont.removeChild(source);
    }
}
}
