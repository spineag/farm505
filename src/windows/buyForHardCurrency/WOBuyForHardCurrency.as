/**
 * Created by user on 10/22/15.
 */
package windows.buyForHardCurrency {
import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOBuyForHardCurrency extends Window{
    private var _contBtnYes:CButton;
    private var _contBtnNo:CButton;
    private var _id:int;
    private var _count:int;
    private var _woBG:WindowBackground;
//    private var _txtCost:TextField;

    public function WOBuyForHardCurrency() {
        super();
        _woWidth = 460;
        _woHeight = 308;
//        createTempBG();
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _contBtnNo = new CButton();
        _contBtnNo.addButtonTexture(80, 40, CButton.YELLOW, true);
        _contBtnYes = new CButton();
        _contBtnYes.addButtonTexture(80, 40, CButton.GREEN, true);
        var txt:TextField;
        txt = new TextField(50,50,"Да",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        txt.x = 15;
        txt.y = -5;
        _contBtnYes.addChild(txt);
        txt = new TextField(50,50,"Нет",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
        txt.x = 15;
        txt.y = -5;
        _contBtnNo.addChild(txt);
//        _txtCost = new TextField(280,50,'',g.allData.fonts['BloggerBold'], 18, Color.WHITE);
//        _txtCost.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
//        _txtCost.x = -150;
//        _txtCost.y = -32;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("currency_buy_window"));
        _source.addChild(im);
        im.x = -50;
        im.y = -60;
        txt = new TextField(300,50,"Подтвердить покупку за рубины?",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE_BIG;
        txt.x = -150;
        txt.y = -100;
        _source.addChild(txt);
        txt = new TextField(300,100,"ПОДТВЕРЖДЕНИЕ ПОКУПКИ!",g.allData.fonts['BloggerBold'],20,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -150;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _source.addChild(txt);
        _contBtnYes.clickCallback = onYes;
        _contBtnNo.clickCallback = onNo;
        _contBtnYes.x = 100;
        _contBtnYes.y = 80;
        _contBtnNo.x = -100;
        _contBtnNo.y = 80;

        _source.addChild(_contBtnYes);
        _source.addChild(_contBtnNo);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
//        _source.removeChild(_txtCost);
    }

    public function showItWO(id:int,count:int):void {
        _id = id;
        _count = count - g.userInventory.getCountResourceById(id);

//        _txtCost.text = "Подтвердить покупку за " + String(count * g.dataResource.objectResources[id].priceHard);
//        _source.addChild(_txtCost);
        showIt();

    }

    private function onYes():void {
        if (g.user.hardCurrency < _count * g.dataResource.objectResources[_id].priceHard) {
//            _source.removeChild(_txtCost);
            hideIt();
            return;
        }
        g.userInventory.addMoney(1,-_count * g.dataResource.objectResources[_id].priceHard);
        g.userInventory.addResource(_id,_count);
//        _source.removeChild(_txtCost);
        hideIt();
    }

    private function onNo():void {
        hideIt();
//        _source.removeChild(_txtCost);
    }
}
}
