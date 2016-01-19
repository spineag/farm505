/**
 * Created by user on 7/15/15.
 */
package windows.buyCoupone {
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
        _woHeight = 400;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        var txt:TextField = new TextField(400,100,'Собирай ваучеры, выполняя заказы на доставку, отправляя пароход, и приобретайте на них особые объекты', g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -200;
        txt.y = -120;
        _source.addChild(txt);
    }

    public function showItWO():void {
        _Green = new WOBuyCouponeItem("green_coupone", g.user.greenCouponCount,15);
        _Green.source.x = -215;
        _Green.source.y = -15;
        _source.addChild(_Green.source);
        _Blue = new WOBuyCouponeItem("blue_coupone", g.user.blueCouponCount,15);
        _Blue.source.x = -105;
        _Blue.source.y = -15;
        _source.addChild(_Blue.source);
        _Red = new WOBuyCouponeItem("red_coupone", g.user.redCouponCount,15);
        _Red.source.x = 5;
        _Red.source.y = -15;
        _source.addChild(_Red.source);
        _Yellow = new WOBuyCouponeItem("yellow_coupone", g.user.yellowCouponCount,15);
        _Yellow.source.x = 115;
        _Yellow.source.y = -15;
        _source.addChild(_Yellow.source);
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
