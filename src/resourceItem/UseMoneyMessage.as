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

import utils.CTextField;

public class UseMoneyMessage {
    private var source:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _txt:CTextField;

    public function UseMoneyMessage(p:Point, typeMoney:int, count:int, delay:Number = 0) {
        source = new Sprite();
        source.touchable = false;
        var st:String = String(count) + ' ';
        if (typeMoney == DataMoney.HARD_CURRENCY) st += String(g.managerLanguage.allTexts[593]);
        else if (typeMoney == DataMoney.BLUE_COUPONE || typeMoney == DataMoney.GREEN_COUPONE || typeMoney == DataMoney.RED_COUPONE || typeMoney == DataMoney.YELLOW_COUPONE) st += String(g.managerLanguage.allTexts[594]);
        else st += String(g.managerLanguage.allTexts[595]);

        _txt = new CTextField(200,50, st);
        _txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txt.x = -100;
        _txt.y = -25;
        source.addChild(_txt);
        source.x = p.x;
        source.y = p.y;
        g.cont.animationsResourceCont.addChild(source);
        TweenMax.to(source, 2, {y:p.y - 50, onComplete:onComplete, delay: delay});
    }

    private function onComplete():void {
        g.cont.animationsResourceCont.removeChild(source);
        while (source.numChildren) source.removeChildAt(0);
        _txt.deleteIt();
        _txt = null;
        source.dispose();
        source = null;
    }
}
}
