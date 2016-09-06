/**
 * Created by user on 7/15/15.
 */
package windows.buyCoupone {
import data.DataMoney;
import manager.ManagerFilters;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;

public class WOBuyCoupone extends WindowMain{
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
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        var txt:CTextField = new CTextField(400,100,'Собирай ваучеры, выполняя заказы, загружая корзину, и приобретайте на них особые товары');
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -200;
        txt.y = -130;
        _source.addChild(txt);
    }

    override public function showItParams(callback:Function, params:Array):void {
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

    override protected function deleteIt():void {
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_Green.source);
        _source.removeChild(_Red.source);
        _source.removeChild(_Blue.source);
        _source.removeChild(_Yellow.source);
        _Green.deleteIt();
        _Blue.deleteIt();
        _Yellow.deleteIt();
        _Red.deleteIt();
        _Green = null;
        _Blue = null;
        _Yellow = null;
        _Red = null;
        super.deleteIt();
    }
}
}
