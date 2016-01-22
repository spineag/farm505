/**
 * Created by user on 7/15/15.
 */
package windows.buyCoupone {
import data.DataMoney;

import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOBuyCoupone extends Window{
    private var _Green:WOBuyCouponeItem;
    private var _Blue:WOBuyCouponeItem;
    private var _Red:WOBuyCouponeItem;
    private var _Yellow:WOBuyCouponeItem;
    private var _woBG:WindowBackground;

    public function WOBuyCoupone() {
        _woWidth = 500;
        _woHeight = 330;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        var txt:TextField = new TextField(400,100,'Собирай ваучеры, выполняя заказы, загружая корзину, и приобретайте на них особые товары', g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -200;
        txt.y = -130;
        _source.addChild(txt);
    }

    public function showItWO():void {
        _Green = new WOBuyCouponeItem("green_coupone", g.user.greenCouponCount,15,DataMoney.GREEN_COUPONE);
        _Green.source.x = -215;
        _Green.source.y = -20;
        _source.addChild(_Green.source);
        _Blue = new WOBuyCouponeItem("blue_coupone", g.user.blueCouponCount,30,DataMoney.BLUE_COUPONE);
        _Blue.source.x = -105;
        _Blue.source.y = -20;
        _source.addChild(_Blue.source);
        _Yellow = new WOBuyCouponeItem("yellow_coupone", g.user.yellowCouponCount,45,DataMoney.YELLOW_COUPONE);
        _Yellow.source.x = 5;
        _Yellow.source.y = -20;
        _source.addChild(_Yellow.source);
        _Red = new WOBuyCouponeItem("red_coupone", g.user.redCouponCount,60,DataMoney.RED_COUPONE);
        _Red.source.x = 115;
        _Red.source.y = -20;
        _source.addChild(_Red.source);
        showIt();
    }

//    public function hideItWO():void {
//        hideIt();
//    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }
}
}
