/**
 * Created by user on 7/15/15.
 */
package windows.buyCoupone {
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.Window;

public class WOBuyCoupone extends Window{
    private var _txtMyCoupone:TextField;
    private var _txtCollectCoupone:TextField;
    private var _Green:WOBuyCouponeItem;
    private var _Blue:WOBuyCouponeItem;
    private var _Red:WOBuyCouponeItem;
    private var _Yellow:WOBuyCouponeItem;

    public function WOBuyCoupone() {
        _txtMyCoupone = new TextField(100,50,"Мои купоны","Arial",16,Color.BLUE);
        _txtMyCoupone.x = -50;
        _txtMyCoupone.y = -150;
        _txtCollectCoupone = new TextField(400,100,"Собирай купоны, выполняя заказы на доставку, отправляя пароход, и приобретайте на них особые обьекты","Arial",18,Color.WHITE);
        _txtCollectCoupone.x = -200;
        _txtCollectCoupone.y = -120;
        createTempBG(400, 300, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 200;
        _btnExit.y -= 150;
        _source.addChild(_txtMyCoupone);
        _source.addChild(_txtCollectCoupone);
    }

    public function showItWO():void {
        _Green = new WOBuyCouponeItem("green_coupone", g.user.greenCouponCount,15);
        _Green.source.x = -100;
        _Green.source.y = -20;
        _Blue = new WOBuyCouponeItem("blue_coupone", g.user.blueCouponCount,15);
        _Blue.source.x = -30;
        _Blue.source.y = -20;
        _Red = new WOBuyCouponeItem("red_coupone", g.user.redCouponCount,15);
        _Red.source.x = 30;
        _Red.source.y = -20;
        _Yellow = new WOBuyCouponeItem("yellow_coupone", g.user.yellowCouponCount,15);
        _Yellow.source.x = 100;
        _Yellow.source.y = -20;
        _source.addChild(_Green.source);
        _source.addChild(_Blue.source);
        _source.addChild(_Red.source);
        _source.addChild(_Yellow.source);
        showIt();
    }

//    public function hideItWO():void {
//        hideIt();
//    }

    private function onClickExit(e:Event):void {
        hideIt();
    }
}
}
