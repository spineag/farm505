/**
 * Created by user on 2/1/16.
 */
package resourceItem {
import com.greensock.TweenMax;

import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

public class UseMoneyMessage {
    private var source:Sprite;
    private var g:Vars = Vars.getInstance();

    public function UseMoneyMessage(p:Point, typeMoney:int, count:int, delay:Number = 0) {
        source = new Sprite();
        source.touchable = false;
        var st:String = String(count) + ' ';
        if (typeMoney == DataMoney.HARD_CURRENCY) st += 'рубинов';
        else if (typeMoney == DataMoney.BLUE_COUPONE || typeMoney == DataMoney.GREEN_COUPONE || typeMoney == DataMoney.RED_COUPONE || typeMoney == DataMoney.YELLOW_COUPONE) st += 'ваучеров';
        else st += 'монет';

        var txt:TextField = new TextField(150,50, st, g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = -75;
        txt.y = -25;
        source.addChild(txt);
        source.flatten();
        source.x = p.x;
        source.y = p.y;
        g.cont.animationsResourceCont.addChild(source);
        TweenMax.to(source, 2, {y:p.y - 50, onComplete:onComplete, delay: delay});
    }

    private function onComplete():void {
        g.cont.animationsResourceCont.removeChild(source);
        source.unflatten();
        while (source.numChildren) source.removeChildAt(0);
        source.dispose();
        source = null;
    }
}
}
