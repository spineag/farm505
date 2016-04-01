/**
 * Created by user on 6/9/15.
 */
package windows.buyPlant {
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

import tutorial.SimpleArrow;
import tutorial.TutorialAction;

import utils.CSprite;
import utils.MCScaler;

import windows.WindowsManager;

public class WOBuyPlantItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _dataPlant:Object;
    private var _clickCallback:Function;
    private var _txtNumber:TextField;
    private var _countPlants:int;
    private var _arrow:SimpleArrow;
    private var _defaultY:int;
    private var _maxAlpha:Number;

    private var g:Vars = Vars.getInstance();

    public function WOBuyPlantItem() {
        source = new CSprite();
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_k'));
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        source.endClickCallback = onClick;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        source.alpha = .5;
        _txtNumber = new TextField(40,30,'',g.allData.fonts['BloggerBold'],18, Color.WHITE);
        _txtNumber.hAlign = HAlign.RIGHT;
        _txtNumber.x = 52;
        _txtNumber.y = 68;
        source.addChild(_txtNumber);
        source.alpha = 0;
    }

    public function setCoordinates(_x:int, _y:int):void {
        _defaultY = _y;
        source.x = _x;
        source.y = _y;
    }

    public function fillData(ob:Object, f:Function):void {
        _dataPlant = ob;
        if (!_dataPlant) {
            Cc.error('WOBuyPlantItem:: empty _dataPlant');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woBuyPlantItem');
            return;
        }
        _clickCallback = f;
        if (_dataPlant.blockByLevel == g.user.level + 1) {
            _maxAlpha = .5;
        } else if (_dataPlant.blockByLevel <= g.user.level) {
            _maxAlpha = 1;
        } else {
            _maxAlpha = 0;
            Cc.error("Warning woBuyPlantItem filldata:: _dataPlant.blockByLevel > g.user.level + 1");
        }
        fillIcon(_dataPlant.imageShop);
        _countPlants = g.userInventory.getCountResourceById(_dataPlant.id);
        if (_countPlants <= 0) {
            _txtNumber.color = ManagerFilters.TEXT_ORANGE;
            if (_txtNumber.nativeFilters == ManagerFilters.TEXT_STROKE_LIGHT_BLUE) _txtNumber.nativeFilters = null;
        }
        else {
            _txtNumber.color = Color.WHITE;
            _txtNumber.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
        }
        _txtNumber.text = String(_countPlants);
        if (g.managerTutorial && (g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE || g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE) && g.managerTutorial.isTutorialResource(_dataPlant.id)) {
            addArrow();
        }
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            source.removeChild(_icon);
            _icon.dispose();
            _icon = null;
        }
        _icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(s + '_icon'));
        if (!_icon) {
            Cc.error('WOItemFabrica fillIcon:: no such image: ' + s);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woBuyPlantItem');
            return;
        }
        MCScaler.scale(_icon, 80, 80);
        _icon.x = _bg.width/2 - _icon.width/2;
        _icon.y = _bg.height/2 - _icon.height/2;
        source.addChildAt(_icon,1);
    }

    public function showAnimateIt(delay:Number):void {
        source.y = _defaultY - 35;
        source.scaleX = source.scaleY = .9;
        source.alpha = 0;
        TweenMax.to(source, .3, {scaleX:1, scaleY:1, alpha:_maxAlpha, y: _defaultY, delay:delay});
    }

    public function showChangeAnimate(d:Number, ob:Object, f:Function):void {
        if (_dataPlant) {
            TweenMax.to(source, .3, {scaleX:.9, scaleY:.9, alpha:0, y: _defaultY - 35, onComplete: onChangeAnimationComplete, delay: d, onCompleteParams: [0, ob, f]});
        } else {
            onChangeAnimationComplete(.3 + d, ob, f);
        }
    }

    private function onChangeAnimationComplete(d:Number, ob:Object, f:Function):void {
        if (_dataPlant) {
            unfillIt();
            _dataPlant = null;
            source.alpha = 0;
        }
        if (ob) {
            fillData(ob, f);
            TweenMax.to(source, .3, {scaleX:1, scaleY:1, alpha:_maxAlpha, y: _defaultY, delay:d});
        }
    }

    private function unfillIt():void {
        removeArrow();
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _countPlants = 0;
        _dataPlant = null;
        _clickCallback = null;
        source.filter = null;
        source.alpha = .5;
        _txtNumber.text = '';
    }

    private function onClick():void {
        if (_dataPlant.blockByLevel > g.user.level) return;
        source.filter = null;
        g.resourceHint.hideIt();
        g.fabricHint.hideIt();
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_dataPlant]);
        }
    }

    private function onHover():void {
        if (!_dataPlant) return;
        source.filter = ManagerFilters.YELLOW_STROKE;
        if (_dataPlant) {
            g.resourceHint.hideIt();
            g.resourceHint.showIt(_dataPlant.id, source.x, source.y, source, true);
        }
    }

    private function onOut():void {
        if (!_dataPlant) return;
        source.filter = null;
        g.resourceHint.hideIt();
    }

    private function addArrow():void {
        removeArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, source, 1);
        _arrow.animateAtPosition(source.width/2, 0);
    }

    private function removeArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function deleteIt():void {
        removeArrow();
        _dataPlant = null;
        _clickCallback = null;
        source.deleteIt();
        source = null;
    }
}
}
