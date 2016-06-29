/**
 * Created by andy on 6/28/16.
 */
package tutorial.helpers {
import build.WorldObject;
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
import tutorial.SimpleArrow;
import utils.CButton;
import utils.CSprite;

public class GameHelper {
    private var _source:CSprite;
    private var _bg:Image;
    private var _txt:TextField;
    private var _catHead:Sprite;
    private var _onCallback:Function;
    private var _reason:Object;
    private var _arrow:SimpleArrow;
    private var _spArrow:Sprite;
    private var _centerPoint:Point;
    private var _targetPoint:Point;
    private const MIN_RADIUS:int = 200;
    private var _btnExit:CButton;
    private var _btnShow:CButton;
    private var _angle:Number;
    private var _isUnderBuild:Boolean;
    private var g:Vars = Vars.getInstance();

    public function GameHelper() {
        _source = new CSprite();
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
        _bg.x = -208;
        _bg.y = -81;
        _source.addChild(_bg);
        _txt = new TextField(220, 90, "", g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE_COLOR);
        _txt.x = -100;
        _txt.y = -60;
        _txt.autoScale = true;
        _source.addChild(_txt);
        _isUnderBuild = false;
        createCatHead();
        createExitButton();
        createShowButton();
    }

    private function createExitButton():void {
        _btnExit = new CButton();
        _btnExit.addDisplayObject(new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_close')));
        _btnExit.setPivots();
        _btnExit.x = 144;
        _btnExit.y = -53;
        _btnExit.createHitArea('bt_close');
        _source.addChild(_btnExit);
        _btnExit.clickCallback = onExit;
    }

    private function createShowButton():void {
        _btnShow = new CButton();
        _btnShow.addButtonTexture(126, 40, CButton.YELLOW, true);
        var txt:TextField = new TextField(125, 40, 'ПОКАЗАТЬ', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
        _btnShow.addChild(txt);
        _btnShow.x = 4;
        _btnShow.y = 52;
        _btnShow.clickCallback = onClickShow;
        _source.addChild(_btnShow);
    }

    private function createCatHead():void {
        _catHead = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_right'));
        im.scaleX = im.scaleY = .5;
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

    public function deleteIt():void {
        deleteHelper();
    }

    private function deleteHelper():void {
        if (_source) {
            g.cont.hintGameCont.removeChild(_source);
            while (_source.numChildren) _source.removeChildAt(0);
            _catHead.dispose();
            _catHead = null;
            _txt.dispose();
            _bg = null;
            _source = null;
            _btnExit.deleteIt();
            _btnShow.deleteIt();
        }
    }

    private function onExit():void {

    }

    public function showIt(callback:Function, r:Object):void {
        _onCallback = callback;
        _reason = r;
        _txt.text = _reason.txt;
        _centerPoint = new Point(Starling.current.nativeStage.stageWidth/2, Starling.current.nativeStage.stageHeight/2);
        _source.x = _centerPoint.x;
        _source.y = _centerPoint.y;
        _source.endClickCallback = callback;
        g.cont.hintGameCont.addChild(_source);
        _targetPoint = new Point();

        switch (_reason.reason) {
            case HelperReason.REASON_ORDER: releaseOrder(); break;
//            case HelperReason.REASON_FEED_ANIMAL: releaseFeedAnimal(); break;
//            case HelperReason.REASON_CRAFT_PLANT: releaseCraftPlant(); break;
//            case HelperReason.REASON_RAW_PLANT: releaseRawPlant(); break;
//            case HelperReason.REASON_RAW_FABRICA: releaseRawFabrica(); break;
//            case HelperReason.REASON_BUY_FABRICA: releaseBuyFabrica(); break;
//            case HelperReason.REASON_BUY_FARM: releaseBuyFarm(); break;
//            case HelperReason.REASON_BUY_HERO: releaseBuyHero(); break;
//            case HelperReason.REASON_BUY_ANIMAL: releaseBuyAnimal(); break;
//            case HelperReason.REASON_BUY_RIDGE: releaseBuyRidge(); break;
        }
    }

    private function releaseOrder():void {
        createTownArrow();
    }

    private function createTownArrow():void {
        _spArrow = new Sprite();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, _spArrow);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(0, -170);
        _spArrow.x = _centerPoint.x;
        _spArrow.y = _centerPoint.y;
        g.cont.hintGameCont.addChildAt(_spArrow, 0);

        g.gameDispatcher.addEnterFrame(checkArrowPosition);
    }

    private function checkArrowPosition():void {
        if (!_reason.build) {
            Cc.error('GameHelper:: _reason.build = null');
            onExit();
            return;
        }
//        _targetPoint.x = (_reason.build as WorldObject).rect.x + (_reason.build as WorldObject).rect.width/2;
        _targetPoint.x = 0;
        _targetPoint.y = 0;
        _targetPoint = (_reason.build as WorldObject).source.localToGlobal(_targetPoint);

        var dist:Number = Math.sqrt((_targetPoint.x - _centerPoint.x)*(_targetPoint.x - _centerPoint.x) + (_targetPoint.y - _centerPoint.y)*(_targetPoint.y - _centerPoint.y));
        if (dist < MIN_RADIUS) {
            if (_isUnderBuild) {
                _spArrow.rotation = Math.PI;
//                _source.x = (_reason.build as WorldObject).rect.
            } else showUnderTownBuild();
        } else {
            if (_targetPoint.y < _centerPoint.y) {
                _angle = Math.asin((_targetPoint.x - _centerPoint.x)/dist);
                _spArrow.rotation = _angle;
            } else {
                _angle = -Math.asin((_targetPoint.x - _centerPoint.x)/dist);
                _spArrow.rotation = _angle + Math.PI;
            }
            _arrow.changeY(-180 - int(Math.abs(_angle)*80));
        }
    }

    private function showUnderTownBuild():void {
        _arrow.visible = true;
        _source.visible = true;
        _btnShow.visible = false;
        _isUnderBuild = true;
    }

    private function onClickShow():void {
        _arrow.visible = false;
        _source.visible = false;
        g.cont.moveCenterToPos((_reason.build as WorldObject).posX, (_reason.build as WorldObject).posY, false, 1);
        createDelay(1, showUnderTownBuild);
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


}
}
