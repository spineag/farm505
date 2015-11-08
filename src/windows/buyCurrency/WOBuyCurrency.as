/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.CartonBackground;

import windows.Window;
import windows.WindowBackground;

public class WOBuyCurrency extends Window{
    private var _tabSoft:CSprite;
    private var _tabHard:CSprite;
    private var _imageBtnSoft:Image;
    private var _imageBtnHard:Image;
    public var _contSoft:Sprite;
    public var _contHard:Sprite;
    private var _txtSoft:TextField;
    private var _txtHard:TextField;
    private var _woBG:WindowBackground;
    private var _cartonBG:CartonBackground;

    public function WOBuyCurrency() {
        _woBG = new WindowBackground(700, 560);
        _source.addChild(_woBG);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('btn_exit'), '', g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_click'), g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_hover'));
        _btnExit.x += 350;
        _btnExit.y -= 280;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        createTabs();

        _cartonBG = new CartonBackground(618, 398);
        _cartonBG.x = -350 + 44;
        _cartonBG.y = -280 + 114;
        _source.addChild(_cartonBG);

        _contSoft = new Sprite();
        _contHard = new Sprite();
        _txtSoft = new TextField(100,50,"Монеты","Arial",18,Color.BLACK);
        _txtSoft.x = 50;
        _txtSoft.y = -200;
        _txtHard = new TextField(100,50,"Изумруды","Arial",18,Color.BLACK);
        _txtHard.x = -150;
        _txtHard.y = -200;
        _imageBtnSoft = new Image(g.allData.atlas['interfaceAtlas'].getTexture("shop_tab"));
        _imageBtnSoft.x = 50;
        _imageBtnSoft.y = -200;
        _imageBtnHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("shop_tab"));
        _imageBtnHard.x = -150;
        _imageBtnHard.y = -200;
//        _contBtnSoft.endClickCallback = onClickSoft;
//        _contBtnHard.endClickCallback = onClickHard;
//        _contBtnHard.addChild(_imageBtnHard);
//        _contBtnHard.addChild(_txtHard);
//        _contBtnSoft.addChild(_imageBtnSoft);
//        _contBtnSoft.addChild(_txtSoft);
//        _source.addChild(_contBtnHard);
//        _source.addChild(_contBtnSoft);
    }

    private function createTabs():void {
        _tabHard = new CSprite();
        var carton:CartonBackground = new CartonBackground(255, 80);
        _tabHard.addChild(carton);

        _tabSoft = new CSprite();
    }

    private function onClickHard():void {
        _contHard.visible = true;
        _contSoft.visible = false;
    }

    private function onClickSoft():void {
        _contHard.visible = false;
        _contSoft.visible = true;
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    public function showItMenu():void {
        createSoftList();
        createHardList();
        showIt();
    }

    private function createSoftList():void {
        var item1:WOBuyCurrencyItem;
        var item2:WOBuyCurrencyItem;
        var item3:WOBuyCurrencyItem;
        var item4:WOBuyCurrencyItem;
        var item5:WOBuyCurrencyItem;
        var item6:WOBuyCurrencyItem;

        item1 = new WOBuyCurrencyItem("coin","220","","1 голос");
        item1.source.x = -200;
        item1.source.y = -100;
        item2 = new WOBuyCurrencyItem("coin","1100","выгода 20%","4 голоса");
        item2.source.x = -50;
        item2.source.y = -100;
        item3 = new WOBuyCurrencyItem("coin","2500","выгода 25%","9 голосов");
        item3.source.x = 100;
        item3.source.y = -100;
        item4 = new WOBuyCurrencyItem("coin","7000","выгода 30%","24 голосов");
        item4.source.x = -200;
        item4.source.y = 50;
        item5 = new WOBuyCurrencyItem("coin","22000","выгода 40%","69 голосов");
        item5.source.x = -50;
        item5.source.y = 50;
        item6 = new WOBuyCurrencyItem("coin","50000","выгода 50%","149 голосов");
        item6.source.x = 100;
        item6.source.y = 50;
        _contSoft.addChild(item1.source);
        _contSoft.addChild(item2.source);
        _contSoft.addChild(item3.source);
        _contSoft.addChild(item4.source);
        _contSoft.addChild(item5.source);
        _contSoft.addChild(item6.source);
        _source.addChild(_contSoft);
    }

    private function createHardList():void {
        var item1:WOBuyCurrencyItem;
        var item2:WOBuyCurrencyItem;
        var item3:WOBuyCurrencyItem;
        var item4:WOBuyCurrencyItem;
        var item5:WOBuyCurrencyItem;
        var item6:WOBuyCurrencyItem;

        item1 = new WOBuyCurrencyItem("diamont","15","","2 голоса");
        item1.source.x = -200;
        item1.source.y = -100;
        item2 = new WOBuyCurrencyItem("diamont","45","выгода 20%","5 голосов");
        item2.source.x = -50;
        item2.source.y = -100;
        item3 = new WOBuyCurrencyItem("diamont","95","выгода 25%","10 голосов");
        item3.source.x = 100;
        item3.source.y = -100;
        item4 = new WOBuyCurrencyItem("diamont","185","выгода 30%","19 голосов");
        item4.source.x = -200;
        item4.source.y = 50;
        item5 = new WOBuyCurrencyItem("diamont","515","выгода 40%","49 голосов");
        item5.source.x = -50;
        item5.source.y = 50;
        item6 = new WOBuyCurrencyItem("diamont","1115","выгода 50%","99 голосов");
        item6.source.x = 100;
        item6.source.y = 50;
        _contHard.addChild(item1.source);
        _contHard.addChild(item2.source);
        _contHard.addChild(item3.source);
        _contHard.addChild(item4.source);
        _contHard.addChild(item5.source);
        _contHard.addChild(item6.source);
        _source.addChild(_contHard);
    }
}
}
