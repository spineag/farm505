/**
 * Created by andy on 6/28/16.
 */
package tutorial.helpers {
import build.WorldObject;
import build.farm.Animal;

import com.junkbyte.console.Cc;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import manager.ManagerFilters;
import manager.Vars;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;
import utils.SimpleArrow;
import utils.CButton;
import utils.CSprite;

public class GameHelper {
    private var _source:Sprite;
    private var _bg:Image;
    private var _txt:CTextField;
    private var _txtBtnShow:CTextField;
    private var _catHead:Sprite;
    private var _onCallback:Function;
    private var _reason:Object;
    private var _arrow:SimpleArrow;
    private var _spArrow:Sprite;
    private var _centerPoint:Point;
    private var _targetPoint:Point;
    private const MIN_RADIUS:int = 250;
    private var _btnExit:CButton;
    private var _btnShow:CButton;
    private var _angle:Number;
    private var _isUnderBuild:Boolean;
    private var _timer:int;
    private var g:Vars = Vars.getInstance();

    public function GameHelper() {
        _source = new Sprite();
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
        _bg.x = -208;
        _bg.y = -81;
        _source.addChild(_bg);
        _txt = new CTextField(220, 80, "");
        _txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
        _txt.x = -100;
        _txt.y = -55;
        _txt.autoScale = true;
        _source.addChild(_txt);
        _isUnderBuild = false;
        createCatHead();
        _timer = 2;
        g.gameDispatcher.addToTimer(createExitButton);
        createShowButton();
    }

//    public function onResize():void {
//        if (_reason == HelperReason.REASON_BUY_ANIMAL || _reason == HelperReason.REASON_BUY_FABRICA ||
//                _reason == HelperReason.REASON_BUY_FARM || _reason == HelperReason.REASON_BUY_HERO || _reason == HelperReason.REASON_BUY_RIDGE) {
//            var ob:Object = g.bottomPanel.getShopButtonProperties();
//            _source.x = ob.x + ob.width/2;
//            _source.y = ob.y + ob.height/2 - 200;
//            _spArrow.x = _source.x;
//            _spArrow.y = _source.y;
//        } else {
//            _centerPoint = new Point(Starling.current.nativeStage.stageWidth / 2, Starling.current.nativeStage.stageHeight / 2);
//            _source.x = _centerPoint.x;
//            _source.y = _centerPoint.y;
//            _spArrow.x = _centerPoint.x;
//            _spArrow.y = _centerPoint.y;
//            checkPosition();
//        }
//    }

    private function createExitButton():void {
        _timer --;
        if (_timer <= 0) {
            g.gameDispatcher.removeFromTimer(createExitButton);
            if (_source) {
                _btnExit = new CButton();
                _btnExit.addDisplayObject(new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_close')));
                _btnExit.setPivots();
                _btnExit.x = 144;
                _btnExit.y = -53;
                _btnExit.createHitArea('bt_close');
                _source.addChild(_btnExit);
                _btnExit.clickCallback = onExit;
            }
        }
    }

    private function createShowButton():void {
        _btnShow = new CButton();
        _btnShow.addButtonTexture(126, 40, CButton.YELLOW, true);
        _txtBtnShow = new CTextField(125, 40, 'Показать');
        _txtBtnShow.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.YELLOW_COLOR);
        _btnShow.addChild(_txtBtnShow);
        _btnShow.x = 4;
        _btnShow.y = 52;
        _btnShow.clickCallback = onClickShow;
        _source.addChild(_btnShow);
    }

    private function createCatHead():void {
        _catHead = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_right'));
        im.scaleX = im.scaleY = .7;
        _catHead.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        im.scaleX = 1.3;
        im.scaleY = 1.3;
        im.x = 24;
        im.y = 16;
        _catHead.addChild(im);
        _catHead.x = -200;
        _catHead.y = -29;
        _source.addChild(_catHead);
    }

    public function deleteHelper():void {
        if (_source) {
            g.gameDispatcher.removeFromTimer(createExitButton);
            _arrow.deleteIt();
            _arrow = null;
            g.cont.hintGameCont.removeChild(_spArrow);
            _spArrow = null;
            g.gameDispatcher.removeEnterFrame(checkPosition);
            if (_source) {
                g.cont.hintGameCont.removeChild(_source);
                while (_source.numChildren) _source.removeChildAt(0);
            }
            if (_catHead) {
                _catHead.dispose();
                _catHead = null;
            }
            if (_txt) _txt.dispose();
            _bg = null;
            _source = null;
            if (_btnExit) {
                _btnExit.deleteIt();
                _btnExit = null;
            }
            if (_btnShow) {
                _btnShow.deleteIt();
                _btnShow = null;
            }
        }
    }

    private function onExit():void {
        if (_onCallback != null) {
            _onCallback.apply();
        }
    }

    public function showIt(callback:Function, r:Object):void {
        _onCallback = callback;
        _reason = r;
        _txt.text = _reason.txt;

        switch (_reason.reason) {
            case HelperReason.REASON_ORDER: releaseTownBuild(); break;
            case HelperReason.REASON_FEED_ANIMAL: releaseTownBuild(); break;
            case HelperReason.REASON_CRAFT_PLANT: releaseTownBuild(); break;
            case HelperReason.REASON_RAW_PLANT: releaseTownBuild(); break;
            case HelperReason.REASON_RAW_FABRICA: releaseTownBuild(); break;
            case HelperReason.REASON_BUY_FABRICA: releaseBuy(); break;
            case HelperReason.REASON_BUY_FARM: releaseBuy(); break;
            case HelperReason.REASON_BUY_HERO: releaseBuy(); break;
            case HelperReason.REASON_BUY_ANIMAL: releaseBuy(); break;
            case HelperReason.REASON_BUY_RIDGE: releaseBuy(); break;
            case HelperReason.REASON_CRAFT_ANY_PRODUCT: releaseTownBuild(); break;
        }
    }

    private function releaseTownBuild():void {
        _centerPoint = new Point(Starling.current.nativeStage.stageWidth/2, Starling.current.nativeStage.stageHeight/2);
        _source.x = _centerPoint.x;
        _source.y = _centerPoint.y;
        g.cont.hintGameCont.addChild(_source);
        _targetPoint = new Point();

        _spArrow = new Sprite();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, _spArrow);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(0, -150);
        _spArrow.x = _centerPoint.x;
        _spArrow.y = _centerPoint.y;
        g.cont.hintGameCont.addChildAt(_spArrow, 0);
        _source.visible = false;
        _arrow.visible = false;

        g.gameDispatcher.addEnterFrame(checkPosition);
    }

    private function checkPosition():void {
        if (!_reason.build) {
            Cc.error('GameHelper:: _reason.build = null');
            onExit();
            return;
        }
        _targetPoint.x = 0;
        _targetPoint.y = 0;
        if (_reason.reason == HelperReason.REASON_FEED_ANIMAL) {
            _targetPoint = (_reason.animal as Animal).source.localToGlobal(_targetPoint);
            _targetPoint.y -= 30;
        } else {
            _targetPoint = (_reason.build as WorldObject).source.localToGlobal(_targetPoint);
        }

        var dist:Number = Math.sqrt((_targetPoint.x - _centerPoint.x)*(_targetPoint.x - _centerPoint.x) + (_targetPoint.y - _centerPoint.y)*(_targetPoint.y - _centerPoint.y));
        if (dist < MIN_RADIUS && _targetPoint.y > 200) {
            if (_isUnderBuild) {
                _spArrow.rotation = Math.PI;
                _arrow.changeY(-150);
                _source.x = _targetPoint.x;
                if (_reason.reason == HelperReason.REASON_FEED_ANIMAL) {
                    _source.y = _targetPoint.y - 170;
                } else {
                    _source.y = _targetPoint.y + (_reason.build as WorldObject).rect.y + (_reason.build as WorldObject).rect.height/8 - 140;
                }
                _spArrow.x = _source.x;
                _spArrow.y = _source.y;
                _arrow.visible = true;
                _source.visible = true;
                _btnShow.visible = false;
            } else showUnderTownBuild();
        } else {
            if (_isUnderBuild) {
                _isUnderBuild = false;
                _btnShow.visible = true;
                _source.x = _centerPoint.x;
                _source.y = _centerPoint.y;
                _spArrow.x = _centerPoint.x;
                _spArrow.y = _centerPoint.y;
            }
            _source.visible = true;
            _arrow.visible = true;
            if (_targetPoint.y < _centerPoint.y) {
                _angle = Math.asin((_targetPoint.x - _centerPoint.x)/dist);
                _spArrow.rotation = _angle;
            } else {
                _angle = -Math.asin((_targetPoint.x - _centerPoint.x)/dist);
                _spArrow.rotation = _angle + Math.PI;
            }
            _arrow.changeY(-150 - int(Math.abs(_angle)*80));
        }
    }

    private function showUnderTownBuild():void {
        _isUnderBuild = true;
    }

    private function onClickShow():void {
        _arrow.visible = false;
        _source.visible = false;
        var cX:int = (_reason.build as WorldObject).posX - 3;
        var cY:int = (_reason.build as WorldObject).posY - 3;
        if (cX < 0) cX = 0;
        if (cY < 0) cY = 0;
        g.cont.moveCenterToPos(cX, cY, false, 1);
        createDelay(1.2, showUnderTownBuild);
    }

    private function createDelay(delay:Number, f:Function):void {
        var func:Function = function():void {
            timer.removeEventListener(TimerEvent.TIMER, func);
            timer = null;
            if (f != null) {
                f.apply();
            }
        };
        var timer:Timer = new Timer(delay*1000, 1);
        timer.addEventListener(TimerEvent.TIMER, func);
        timer.start();
    }

    private function releaseBuy():void {
        _btnShow.visible = false;
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        _source.x = ob.x + ob.width/2;
        _source.y = ob.y + ob.height/2 - 200;
        g.cont.hintGameCont.addChild(_source);

        _spArrow = new Sprite();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, _spArrow);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(0, -150);
        _spArrow.rotation = Math.PI;
        _spArrow.x = _source.x;
        _spArrow.y = _source.y;
        g.cont.hintGameCont.addChildAt(_spArrow, 0);
    }


}
}
