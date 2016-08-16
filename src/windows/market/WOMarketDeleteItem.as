/**
 * Created by user on 5/5/16.
 */
package windows.market {
import manager.ManagerFilters;

import starling.display.Image;

import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;
import utils.MCScaler;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import starling.events.Event;

import windows.WindowsManager;

public class WOMarketDeleteItem extends WindowMain{
    private var _woBG:WindowBackground;
    private var _b:CButton;
    private var _callback:Function;
    private var _data:Object;
    private var _count:int;
    public function WOMarketDeleteItem() {
        _windowType = WindowsManager.WO_MARKET_DELETE_ITEM;
        _woWidth = 400;
        _woHeight = 200;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        var txt:TextField = new TextField(300,30,'Этот продукт будет возвращен в хранилище.',g.allData.fonts['BloggerMedium'],20,Color.WHITE);
        txt.autoScale = true;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -20;
        txt.touchable = false;
        _source.addChild(txt);
        txt = new TextField(300,30,'УБРАТЬ ТОВАР С ПРИЛАВКА?',g.allData.fonts['BloggerBold'],22,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -157;
        txt.y = -60;
        txt.touchable = false;
        _source.addChild(txt);
        _callbackClickBG = onClickExit;
        _b = new CButton();
        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        _b.y = 120;
        _source.addChild(_b);
        txt = new TextField(200, 34, "Убрать за 1", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _b.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        im.x = 150;
        im.y = 1;
//        MCScaler.scale(im,30,30);
        _b.addChild(im);
        _b.y = 70;
        _b.clickCallback = onClick;
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        super.hideIt();
    }

    override public function showItParams(f:Function, params:Array):void {
        super.showIt();
        _callback = f;
        _data = params[0];
        _count = params[1];
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.user.hardCurrency < 1) {
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        if (_callback != null) {
            _callback.apply(null,[]);
        }
        super.hideIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_b);
        _b.deleteIt();
        _b = null;
        _callback = null;
        super.deleteIt();
    }
}
}
