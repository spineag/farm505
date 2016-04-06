/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import data.DataMoney;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;
import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyCurrency extends WindowMain {
    private var _tabHard:CSprite;
    private var _tabSoft:CSprite;
    private var _woBG:WindowBackground;
    private var _cartonBG:CartonBackground;
    private var _contCarton:Sprite;
    private var _birka:Birka;
    private var _isHard:Boolean = false;
    private var _cartonHardTab:CartonBackground;
    private var _cartonSoftTab:CartonBackground;
    private var _contItems:Sprite;
    private var _arrItems:Array;
    private var SHADOW:BlurFilter;
    private var _defaultY:int;

    public function WOBuyCurrency() {
        super();
        _defaultY = -234;
        _windowType = WindowsManager.WO_BUY_CURRENCY;
        _woWidth = 700;
        _woHeight = 560;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _contCarton = new Sprite();
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        SHADOW = ManagerFilters.getShadowFilter();
        _cartonBG = new CartonBackground(618, 398);
        _cartonBG.x = -308;
        _cartonBG.y = -166;
        _contCarton.addChild(_cartonBG);
        _contCarton.filter = SHADOW;
        _source.addChild(_contCarton);

        _contItems = new Sprite();
        _contItems.x = -305;
        _contItems.y = -167;
        _source.addChild(_contItems);

        _birka = new Birka('БАНК', _source, 700, 560);
    }

    private function createTabs():void {
        _tabHard = new CSprite();
        _cartonHardTab = new CartonBackground(255, 80);
        _cartonHardTab.touchable = true;
        _tabHard.addChild(_cartonHardTab);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        var txt:TextField = new TextField(160, 67, 'Рубины', g.allData.fonts['BloggerBold'], 24, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 85;
        txt.touchable = false;
        _tabHard.addChild(txt);
        _tabHard.x = -289;
        _tabHard.y = _defaultY;
        MCScaler.scale(im, 55, 55);
        im.x = 27;
        im.y = 9;
        _tabHard.addChild(im);
        _tabHard.endClickCallback = onClick;
        _tabHard.hoverCallback = onHover;
        _tabHard.outCallback = onOut;

        _tabSoft = new CSprite();
        _cartonSoftTab = new CartonBackground(255, 80);
        _cartonSoftTab.touchable = true;
        _tabSoft.addChild(_cartonSoftTab);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins"));
        txt= new TextField(160, 67, 'Монеты', g.allData.fonts['BloggerBold'], 24, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 85;
        txt.touchable = false;
        _tabSoft.addChild(txt);
        _tabSoft.x = -9;
        _tabSoft.y = _defaultY;
        MCScaler.scale(im, 55, 55);
        im.x = 27;
        im.y = 9;
        _tabSoft.addChild(im);
        _tabSoft.endClickCallback = onClick;
        _tabSoft.hoverCallback = onHover;
        _tabSoft.outCallback = onOut;
    }

    private function createLists():void {
        var item:WOBuyCurrencyItem;
        var arrAdd:Array;
        var arrCost:Array;
        var currency:int;

        _arrItems = [];
        if (_isHard) {
            arrAdd = [15, 45, 95, 185, 515, 1115];
            arrCost = [2, 5, 10, 19, 49, 99];
            currency = DataMoney.HARD_CURRENCY;
        } else {
            arrAdd = [220, 1100, 2500, 7000, 22000, 50000];
            arrCost = [1, 4, 9, 24, 69, 149];
            currency = DataMoney.SOFT_CURRENCY;
        }
        for (var i:int=0; i< arrAdd.length; i++) {
            item = new WOBuyCurrencyItem(currency, arrAdd[i], "", arrCost[i]);
            item.source.x = 13;
            item.source.y = 12 + i*64;
            _contItems.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function deleteLists():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _contItems.removeChild(_arrItems[i].source);
            (_arrItems[i] as WOBuyCurrencyItem).deleteIt();
        }
        _arrItems.length = 0;
    }

    override public function showItParams(callback:Function, params:Array):void {
        _isHard = params[0];
        createTabs();
        fillTabs();
        createLists();
        super.showIt();
    }

    private function fillTabs():void {
        if (_isHard) {
            _contCarton.addChild(_tabHard);
            _tabHard.isTouchable = false;
            _tabHard.y = _defaultY;
            _source.addChildAt(_tabSoft, _source.getChildIndex(_contCarton)-1);
            _tabSoft.filter = SHADOW;
            _tabSoft.isTouchable = true;
            _tabSoft.y = _defaultY + 10;
        } else {
            _source.addChildAt(_tabHard, _source.getChildIndex(_contCarton)-1);
            _tabHard.isTouchable = true;
            _tabHard.filter = SHADOW;
            _tabHard.y = _defaultY + 10;
            _contCarton.addChild(_tabSoft);
            _tabSoft.isTouchable = false;
            _tabSoft.y = _defaultY;
        }
    }

    private function onClick():void {
        deleteLists();
        _tabHard.filter = null;
        _tabSoft.filter = null;
        if (_contCarton.contains(_tabHard)) _contCarton.removeChild(_tabHard);
        if (_contCarton.contains(_tabSoft)) _contCarton.removeChild(_tabSoft);
        if (_source.contains(_tabHard)) _source.removeChild(_tabHard);
        if (_source.contains(_tabSoft)) _source.removeChild(_tabSoft);
        _isHard = !_isHard;
        fillTabs();
        createLists();
    }

    private function onHover():void {
        if (_isHard) {
            _tabSoft.y = _defaultY + 3;
        } else {
            _tabHard.y = _defaultY + 3;
        }
    }

    private function onOut():void {
        if (_isHard) {
            _tabSoft.y = _defaultY + 10;
        } else {
            _tabHard.y = _defaultY + 10;
        }
    }

    override protected function deleteIt():void {
        deleteLists();
        _tabHard.filter = null;
        _tabSoft.filter = null;
        _contCarton.filter = null;
        if (_contCarton.contains(_tabHard)) _contCarton.removeChild(_tabHard);
        if (_contCarton.contains(_tabSoft)) _contCarton.removeChild(_tabSoft);
        if (_source.contains(_tabHard)) _source.removeChild(_tabHard);
        if (_source.contains(_tabSoft)) _source.removeChild(_tabSoft);
        _tabHard.deleteIt();
        _tabHard = null;
        _tabSoft.deleteIt();
        _tabSoft = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _contCarton.removeChild(_cartonBG);
        _cartonBG.deleteIt();
        _cartonBG = null;
        _source.removeChild(_birka);
        _birka.deleteIt();
        _birka = null;
        SHADOW.dispose();
        SHADOW = null;
        super.deleteIt();
    }

}
}
