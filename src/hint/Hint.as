/**
 * Created by user on 6/11/15.
 */
package hint {
import manager.Vars;

import starling.display.Image;

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

    private var _plankUp:Image;
    private var _plankDown:Image;
    private var _plankRight:Image;
    private var _plankLeft:Image;
    private var _cornerLeftUp:Image;
    private var _cornerLeftDown:Image;
    private var _cornerRightDown:Image;
    private var _cornerRightUp:Image;
    private var _hintMiddle:Image;

    private var g:Vars = Vars.getInstance();

    public function Hint() {
        source = new Sprite();
        _contHint = new Sprite();

        _isShow = false;
        _txtHintOne = new TextField(70,50,"dadadadadada ","Arial",14,Color.BLACK);

         _plankUp = new Image(g.interfaceAtlas.getTexture("hintSidePixels"));
         _plankDown = new Image(g.interfaceAtlas.getTexture("hintSidePixels"));
         _plankRight = new Image(g.interfaceAtlas.getTexture("hintSidePixels"));
         _plankLeft = new Image(g.interfaceAtlas.getTexture("hintSidePixels"));
         _cornerLeftUp = new Image(g.interfaceAtlas.getTexture("hintTopLeftPart"));
         _cornerLeftDown = new Image(g.interfaceAtlas.getTexture("hintTopLeftPart"));
         _cornerRightDown = new Image(g.interfaceAtlas.getTexture("hintTopLeftPart"));
         _cornerRightUp = new Image(g.interfaceAtlas.getTexture("hintTopLeftPart"));
         _hintMiddle = new Image(g.interfaceAtlas.getTexture("hintMiddle"));

        _cornerRightUp.scaleX *= -1;
        _cornerRightDown.scaleY *= -1;
        _cornerRightDown.scaleX *= -1;
        _cornerLeftDown.scaleY *= -1;
        _plankDown.scaleY *= -1;
        _plankLeft.scaleY *= -1;

        _contHint.addChild(_plankUp);
        _contHint.addChild(_plankDown);
        _contHint.addChild(_plankRight);
        _contHint.addChild(_plankLeft);
        _contHint.addChild(_cornerLeftUp);
        _contHint.addChild(_cornerLeftDown);
        _contHint.addChild(_cornerRightDown);
        _contHint.addChild(_cornerRightUp);
        _contHint.addChild(_hintMiddle);

        _hintMiddle.height = _txtHintOne.textBounds.height;
        _hintMiddle.width = _txtHintOne.textBounds.width;
        _plankUp.width = _txtHintOne.textBounds.width;
        _plankDown.width = _txtHintOne.textBounds.width;
        _plankRight.width = _txtHintOne.textBounds.height  - _plankRight.width;
        _plankLeft.width = _txtHintOne.textBounds.height  - _plankLeft.width;

        _plankRight.rotation = Math.PI / 2;
        _plankLeft.rotation = Math.PI / 2;

        source.addChild(_contHint);
        source.addChild(_txtHintOne);
    }

    public function showIt(name:String, number:String):void {
        if(_isShow) return;
        _isShow = true;
//        _txtHintOne.text = name;
        createHint();
        g.cont.hintCont.addChild(source);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function createHint():void {
        _hintMiddle.x = _txtHintOne.textBounds.x;
        _hintMiddle.y = _txtHintOne.textBounds.y;

        _plankUp.x = _txtHintOne.textBounds.x;
        _plankUp.y = _txtHintOne.textBounds.y - _plankUp.height;

        _plankDown.x = _txtHintOne.textBounds.x;
        _plankDown.y = _txtHintOne.textBounds.y + _txtHintOne.textBounds.height + _plankDown.height;

        _plankRight.x = _txtHintOne.textBounds.x + _txtHintOne.textBounds.width + _plankRight.width;
        _plankRight.y = _txtHintOne.textBounds.y + _plankRight.height - _txtHintOne.textBounds.height;

        _plankLeft.x = _txtHintOne.textBounds.x - _plankLeft.width;
        _plankLeft.y = _txtHintOne.textBounds.y + _plankLeft.height - _txtHintOne.textBounds.height;

        _cornerLeftUp.x = _txtHintOne.textBounds.x - _cornerLeftUp.width;
        _cornerLeftUp.y = _txtHintOne.textBounds.y - _cornerLeftUp.height;

        _cornerLeftDown.x = _txtHintOne.textBounds.x - _cornerLeftDown.width;
        _cornerLeftDown.y = _txtHintOne.textBounds.y + _txtHintOne.textBounds.height + _cornerLeftDown.height;

        _cornerRightDown.x = _txtHintOne.textBounds.x + _txtHintOne.textBounds.width + _cornerRightDown.width;
        _cornerRightDown.y = _txtHintOne.textBounds.y + _txtHintOne.textBounds.height + _cornerRightDown.height;

        _cornerRightUp.x = _txtHintOne.textBounds.x + _txtHintOne.textBounds.width + _cornerRightUp.width;
        _cornerRightUp.y = _txtHintOne.textBounds.y - _cornerRightUp.height;
    }

    private function onEnterFrame():void {
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
