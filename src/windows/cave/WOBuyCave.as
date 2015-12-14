/**
 * Created by user on 7/23/15.
 */
package windows.cave {
import com.junkbyte.console.Cc;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.WOComponents.WOButtonTexture;

import windows.Window;

public class WOBuyCave extends Window {
    private var btn:CSprite;
    private var txt:TextField;
    private var priceTxt:TextField;
    private var _callback:Function;
    private var _dataObject:Object;

    public function WOBuyCave() {
        super();
        _woWidth = 300;
        _woHeight = 300;
        createTempBG();
        createExitButton(onClickExit);

        btn = new CSprite();
        var bg:WOButtonTexture = new WOButtonTexture(130, 40, WOButtonTexture.BLUE);
        btn.addChild(bg);
        btn.x = -btn.width/2;
        btn.y = 125;
        priceTxt = new TextField(217, 30, '', "Arial", 18, Color.WHITE);
        priceTxt.y = 10;
        btn.addChild(priceTxt);
        _source.addChild(btn);
        btn.endClickCallback = onClickBuy;

        txt = new TextField(300, 30, '', "Arial", 18, Color.WHITE);
        txt.x = -150;
        txt.y = -20;
        _source.addChild(txt);
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    public function showItWithParams(_data:Object, _t:String, f:Function):void {
        if (!_data) {
            Cc.error('WOBuyCave showItWithParams: empty _data');
            g.woGameError.showIt();
            return;
        }
        _dataObject = _data;
        priceTxt.text = String(_data.cost);
       txt.text = _t;
        _callback = f;
        showIt();
    }

    private function onClickBuy():void {
        if (g.user.softCurrencyCount < _dataObject.cost) {
//            g.woNoResources.showItTrain(_dataObject.id,_dataObject.cost - g.user.softCurrencyCount,onClickBuy);   - need remake
            return;
        }
        if (_callback != null) {
            _callback.apply();
        }
        hideIt();
    }
}
}
