package windows.cave {

import com.greensock.TweenMax;
import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import manager.Vars;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WindowsManager;

public class CaveItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _data:Object;
    private var _clickCallback:Function;
    private var _txtCount:TextField;
    private var _countResource:int;
    private var _defaultY:int;
    private var _maxAlpha:Number = 1;
    private var _wo:WOCave;

    private var g:Vars = Vars.getInstance();

    public function CaveItem(wo:WOCave) {
        _wo = wo;
        source = new CSprite();
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_k'));
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        source.endClickCallback = onClick;
        source.hoverCallback = function():void {source.filter = ManagerFilters.YELLOW_STROKE;};
        source.outCallback = function():void {source.filter = null;};
//        source.hoverCallback = onHover;
//        source.outCallback = onOut;
        _txtCount = new TextField(40,30,'');
        _txtCount.format.setTo(g.allData.bFonts['BloggerBold18'],16,Color.WHITE);
        _txtCount.filter =  ManagerFilters.TEXT_STROKE_BROWN;
        _txtCount.x = 60;
        _txtCount.y = 68;
        source.addChild(_txtCount);
    }

    public function setCoordinates(_x:int, _y:int):void {
        _defaultY = _y;
        source.x = _x;
        source.y = _y;
    }

    public function fillData(ob:Object, f:Function):void {
        _data = ob;
        if (!_data) {
            Cc.error('CaveItem fillData:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'caveItem');
            return;
        }
        _clickCallback = f;
        fillIcon();
    }

    private function fillIcon():void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
        if (!_icon ) {
            Cc.error('CaveItem fillIcon:: no such image: ' + _data.imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'caveItem');
            return;
        }
        MCScaler.scale(_icon, 80, 80);
        _icon.x = _bg.width/2 - _icon.width/2;
        _icon.y = _bg.height/2 - _icon.height/2;
        source.addChild(_icon);
        _countResource = g.userInventory.getCountResourceById(_data.id);
        _txtCount.text = String(_countResource);
    }

    public function showAnimateIt(delay:Number):void {
        source.y = _defaultY - 35;
        source.scaleX = source.scaleY = .9;
        source.alpha = 0;
        TweenMax.to(source, .3, {scaleX:1, scaleY:1, alpha:_maxAlpha, y: _defaultY, delay:delay});
    }

    private function onClick():void {
        source.filter = null;
        if (g.userInventory.getCountResourceById(_data.id) <= 0) {
            var ob:Object = {};
            ob.data = _data;
            ob.count = 1;
            g.windowsManager.cashWindow = _wo;
            _wo.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClick, 'menu', ob);
            return;
        }
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_data.id]);
        }
    }

    public function deleteIt():void {
        _wo = null;
        _data = null;
        _clickCallback = null;
        source.deleteIt();
        source = null;
    }
}
}
