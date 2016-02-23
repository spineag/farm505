/**
 * Created by user on 7/23/15.
 */
package windows.cave {
import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowMine;

import windows.Window;

public class WOBuyCave extends Window {
    private var btn:CButton;
    private var txt:TextField;
    private var priceTxt:TextField;
    private var _callback:Function;
    private var _dataObject:Object;
    private var _wm:WindowMine;

    public function WOBuyCave() {
        super();
        _woWidth = 600;
        _woHeight = 350;
        _wm = new WindowMine(_woWidth,_woHeight);
        _source.addChild(_wm);
        createExitButton(onClickExit);
        callbackClickBG = onClickExit;

        btn = new CButton();
        btn.addButtonTexture(250, 35, CButton.BLUE, true);
//        btn.x = -btn.width/2;
        btn.y = 165;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = 215;
        im.y = 7;
        btn.addChild(im);
        MCScaler.scale(im,25,25);
        priceTxt = new TextField(217, 30, '',g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        priceTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        priceTxt.y = 5;
//        priceTxt.x = -20;
        btn.addChild(priceTxt);
        _source.addChild(btn);
        btn.clickCallback = onClickBuy;

        txt = new TextField(300, 30, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.x = -150;
        txt.y = -20;
        _source.addChild(txt);


    }

    private function onClickExit(e:Event = null):void {
        hideIt();
    }

    public function showItWithParams(_data:Object, _t:String, f:Function,cave:Boolean):void {
        if (!_data) {
            Cc.error('WOBuyCave showItWithParams: empty _data');
            g.woGameError.showIt();
            return;
        }
        var im:Image;
        if (cave){
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('mine_picture'));
            im.x = - 298;
            im.y = - 175;
            _source.addChildAt(im,0);
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('aerial_tram_all'));
            im.x = - 298;
            im.y = - 175;
            _source.addChildAt(im,0);
        }

        _dataObject = _data;
        priceTxt.text = 'Отремонтировать ' + String(_data.cost);
//        txt.text = _t;
        _callback = f;
        showIt();
    }

    private function onClickBuy():void {
        if (g.user.softCurrencyCount < _dataObject.cost) {
            g.woNoResources.showItMoney(2,_dataObject.cost - g.user.softCurrencyCount,onClickBuy);
            return;
        }
        if (_callback != null) {
            _callback.apply();
        }
        hideIt();
    }
}
}
