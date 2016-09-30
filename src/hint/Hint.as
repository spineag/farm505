/**
 * Created by user on 6/11/15.
 */
package hint {

import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.Vars;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import tutorial.TutorialAction;

import utils.CTextField;

import utils.TimeUtils;

import windows.WOComponents.HintBackground;

public class Hint {
    public var source:Sprite;
    private var _txtHint:CTextField;
    private var _txtHintTime:CTextField;
    private var _isShow:Boolean;
    private var _newX:int;
    private var _catXp:Boolean;
    private var _type:String;
    private var _timeHint:int;
    private var _fabric:Boolean;
    private var g:Vars = Vars.getInstance();

    public function Hint() {
        source = new Sprite();
        _txtHint = new CTextField(150,20,"");
        _txtHint.setFormat(CTextField.MEDIUM18, 15,ManagerFilters.BLUE_COLOR);
        _txtHintTime = new CTextField(150,20,"");
        _txtHintTime.setFormat(CTextField.MEDIUM18, 15, ManagerFilters.BLUE_COLOR);
        _txtHintTime.cacheIt = false;
        source.touchable = false;
        _isShow = false;
    }

    public function showIt(st:String, type:String = 'none', newX:int = 0, time:int = 0):void {
        _fabric = false;
        _catXp = false;
        _timeHint = 0;
        switch (type) {
            case 'none':
                _txtHint.text = st;
                break;
            case 'ambar':
                _txtHint.text = String(st + ' ' + g.userInventory.currentCountInAmbar + '/' + g.user.ambarMaxCount);
                break;
            case 'sklad':
                _txtHint.text = String(st + ' ' + g.userInventory.currentCountInSklad + '/' + g.user.skladMaxCount);
                break;
            case 'xp':
                _txtHint.text = st;
                _catXp = true;
                break;
            case 'market_paper':
                _txtHint.text = st;
                break;
            case 'market_delete':
                _txtHint.text = st;
                break;
            case 'fabric':
                _fabric = true;
                _timeHint = time;
                _txtHint.text = st;
                g.gameDispatcher.addToTimer(timer);
//                    return;
                break;
        }
        _txtHint.updateIt();
        _type = type;
        _newX = newX;

        var rectangle:Rectangle;
        if (!_catXp )  {
            rectangle = _txtHint.textBounds;
            _txtHint.x = 0;
            _txtHint.width = rectangle.width + 20;
//            var tween:Tween = new Tween(source, 0.1);
//            tween.scaleTo(1);
//            tween.onComplete = function ():void {
//                g.starling.juggler.remove(tween);
//            };
//            g.starling.juggler.add(tween);
        } else {
            _txtHint.width = 150;
        }
        rectangle = _txtHint.textBounds;

        _txtHint.height = rectangle.height + 10;
        if (_fabric) {
            _txtHintTime.height = rectangle.height + 10;
            _txtHintTime.x = 0;
            _txtHintTime.y = 20;
            _txtHintTime.width = rectangle.width + 20;
        }
        if (source.numChildren) {
            while (source.numChildren) source.removeChildAt(0);
        }
        var bg:HintBackground;
        if (_fabric) bg = new HintBackground(rectangle.width + 22, rectangle.height + 30);
        else bg = new HintBackground(rectangle.width + 22, rectangle.height + 12);
        if (_catXp) {
            _txtHint.x = bg.x + 8;
        }
        source.addChild(bg);
        source.addChild(_txtHint);
        if (_fabric) source.addChild(_txtHintTime);
        if(_isShow) return;
        _isShow = true;
        g.cont.hintCont.addChild(source);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
//        source.scaleX = source.scaleY = 0;
//        tween = new Tween(source, 0.4);
//        tween.scaleTo(1);
//        tween.onComplete = function ():void {
//            g.starling.juggler.remove(tween);
//
//        };
//        g.starling.juggler.add(tween);
    }

    private function onEnterFrame():void {
        switch (_type) {
            case 'market_paper':
                source.x = g.ownMouse.mouseX + 20;
                source.y = g.ownMouse.mouseY - 60;
                checkPosition();
                return;
                break;
            case 'market_delete':
                source.x = g.ownMouse.mouseX + 20;
                source.y = g.ownMouse.mouseY + 20;
                checkPosition();
                return;
                break;
        }
        if (_catXp || _newX > 0) {
            source.x = _newX;
            source.y = g.ownMouse.mouseY + 20;
            checkPosition();
            return;
        }
        source.x = g.ownMouse.mouseX + 20;
        source.y = g.ownMouse.mouseY - 40;
        checkPosition();
    }

    private function checkPosition():void {  // check is hint source is in stage width|height
        if (source.x < 20) source.x = 20;
        if (source.x > Starling.current.nativeStage.stageWidth - source.width - 20) source.x = Starling.current.nativeStage.stageWidth - source.width - 20;
        if (source.y < 20) source.y = 20;
        if (source.y > Starling.current.nativeStage.stageHeight - source.height - 20) source.y = Starling.current.nativeStage.stageHeight - source.height - 20;
    }

    public function hideIt():void {
        _isShow = false;
        _timeHint = 0;
        if (_txtHintTime)_txtHintTime.text = '';
        g.gameDispatcher.removeFromTimer(timer);
        while (source.numChildren) source.removeChildAt(0);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.cont.hintCont.removeChild(source);
    }

    private function timer():void {
        _txtHintTime.text = TimeUtils.convertSecondsToStringClassic(_timeHint);
        _timeHint --;
        if (_timeHint <= 0) {
            g.gameDispatcher.removeFromTimer(timer);
            _txtHintTime.text = '';
        }
    }
}
}
