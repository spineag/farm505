/**
 * Created by user on 7/23/15.
 */
package windows.cave {
import data.DataMoney;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.Window;

public class WOBuyCave extends Window {
    private var btn:CSprite;
    private var txt:TextField;
    private var priceTxt:TextField;
    private var _callback:Function;

    public function WOBuyCave() {
        super();
        createTempBG(300, 300, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x += 150;
        _btnExit.y -= 150;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        btn = new CSprite();
        var im:Image = new Image(g.interfaceAtlas.getTexture('btn1'));
        btn.addChild(im);
        btn.x = -btn.width/2;
        btn.y = 125;
        priceTxt = new TextField(217, 30, '', "Arial", 18, Color.WHITE);
        priceTxt.y = 10;
        btn.addChild(priceTxt);
        _source.addChild(btn);
        btn.endClickCallback = onClickBuy;

        txt = new TextField(300, 30, "Купите пещеру", "Arial", 18, Color.WHITE);
        txt.x = -150;
        txt.y = -20;
        _source.addChild(txt);
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    public function showItWithParams(_data:Object, f:Function):void {
        priceTxt.text = String(_data.cost);
        _callback = f;
        showIt();
    }

    private function onClickBuy():void {
        if (_callback != null) {
            _callback.apply();
        }
        hideIt();
    }
}
}
