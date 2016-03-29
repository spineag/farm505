/**
 * Created by user on 6/9/15.
 */
package windows.buyPlant {
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
    }

    public function fillData(ob:Object, f:Function):void {
        _dataPlant = ob;
//        if (_dataPlant.id == 117) return;
        if (!_dataPlant) {
            Cc.error('WOBuyPlantItem:: empty _dataPlant');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woBuyPlantItem');
            return;
        }
        _clickCallback = f;
        if (_dataPlant.blockByLevel == g.user.level + 1) {
            source.alpha = .5;
        } else if (_dataPlant.blockByLevel <= g.user.level) {
            source.alpha = 1;
        } else {
            source.alpha = 0;
            Cc.error("Warning woBuyPlantItem filldata:: _dataPlant.blockByLevel > g.user.level + 1");
        }
        fillIcon(_dataPlant.imageShop);
        _countPlants = g.userInventory.getCountResourceById(_dataPlant.id);
        if (_countPlants <= 0) _txtNumber.color = ManagerFilters.TEXT_ORANGE;
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

    public function unfillIt():void {
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
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_dataPlant]);
        }
        source.filter = null;
        g.resourceHint.hideIt();
        g.fabricHint.hideIt();
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
}
}
