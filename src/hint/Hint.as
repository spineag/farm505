/**
 * Created by user on 6/11/15.
 */
package hint {
import com.greensock.easing.Bounce;

import flash.geom.Rectangle;

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
    private var rectangle:Rectangle;

    private var g:Vars = Vars.getInstance();

    public function Hint() {
        source = new Sprite();
        _contHint = new Sprite();
        _isShow = false;
        _txtHintOne = new TextField(70,50,"","Arial",14,Color.BLACK);

         _plankUp = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintSidePixels"));
         _plankDown = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintSidePixels"));
         _plankRight = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintSidePixels2"));
         _plankLeft = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintSidePixels2"));
         _cornerLeftUp = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintTopLeftPart"));
         _cornerLeftDown = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintTopLeftPart"));
         _cornerRightDown = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintTopLeftPart"));
         _cornerRightUp = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintTopLeftPart"));
         _hintMiddle = new Image(g.allData.atlas['interfaceAtlas'].getTexture("hintMiddle"));

        _cornerRightUp.scaleX *= -1;
        _cornerRightDown.scaleY *= -1;
        _cornerRightDown.scaleX *= -1;
        _cornerLeftDown.scaleY *= -1;
        _plankDown.scaleY *= -1;
        _plankLeft.scaleX *= -1;
//        _plankRight.rotation = Math.PI / 2;
//        _plankLeft.rotation = Math.PI / 2;

        _contHint.addChild(_plankUp);
        _contHint.addChild(_plankDown);
        _contHint.addChild(_plankRight);
        _contHint.addChild(_plankLeft);
        _contHint.addChild(_cornerLeftUp);
        _contHint.addChild(_cornerLeftDown);
        _contHint.addChild(_cornerRightDown);
        _contHint.addChild(_cornerRightUp);
        _contHint.addChild(_hintMiddle);

        source.addChild(_contHint);
        source.addChild(_txtHintOne);
    }

    public function showIt(name:String, number:String):void {
        rectangle = _txtHintOne.textBounds;
        createHint();
        _txtHintOne.text = name;
        _hintMiddle.height = rectangle.height;
        _hintMiddle.width = rectangle.width;
        _plankUp.width = rectangle.width;
        _plankDown.width = rectangle.width;
        _plankRight.height = int(rectangle.height);//rectangle.height - _plankRight.width
        _plankLeft.height = int(rectangle.height);

        if(_isShow) return;
        _isShow = true;
        g.cont.hintCont.addChild(source);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function createHint():void {
        _hintMiddle.x = rectangle.x;
        _hintMiddle.y = rectangle.y;

        _plankUp.x = rectangle.x;
        _plankUp.y = rectangle.y - _plankUp.height;

        _plankDown.x = rectangle.x;
        _plankDown.y = rectangle.y + rectangle.height + _plankDown.height;
        if (_txtHintOne.text.length >= 9){
            _plankRight.x = rectangle.x + rectangle.width;
            _plankRight.y = rectangle.height - _plankRight.height + _cornerLeftUp.height;

            _plankLeft.x = rectangle.x;
            _plankLeft.y = rectangle.height - _plankRight.height + _cornerLeftUp.height;
        } else if (_txtHintOne.text.length <= 8){
            _plankRight.x = rectangle.x + rectangle.width;
            _plankRight.y = rectangle.height;

            _plankLeft.x = rectangle.x;
            _plankLeft.y = rectangle.height;
        }

        _cornerLeftUp.x = rectangle.x - _cornerLeftUp.width;
        _cornerLeftUp.y = rectangle.y - _cornerLeftUp.height;

        _cornerLeftDown.x = rectangle.x - _cornerLeftDown.width;
        _cornerLeftDown.y = rectangle.y + rectangle.height + _cornerLeftDown.height;

        _cornerRightDown.x = rectangle.x + rectangle.width + _cornerRightDown.width;
        _cornerRightDown.y = rectangle.y + rectangle.height + _cornerRightDown.height;

        _cornerRightUp.x = rectangle.x + rectangle.width + _cornerRightUp.width;
        _cornerRightUp.y = rectangle.y - _cornerRightUp.height;
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
