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

    public function WOBuyForHardCurrency() {
        super();
        _woWidth = 460;
        _woHeight = 308;
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
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("currency_buy_window"));
        _source.addChild(im);
        im.x = -50;
        im.y = -60;
        txt = new TextField(300,50,"Подтвердить покупку за рубины?",g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -100;
        _source.addChild(txt);
        txt = new TextField(300,30,"ПОДТВЕРЖДЕНИЕ ПОКУПКИ!",g.allData.fonts['BloggerBold'],22,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -115;
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
    }

    public function showItWO(id:int,count:int):void {
        _id = id;
        _count = count - g.userInventory.getCountResourceById(id);
        showIt();
    }

    private function onYes():void {
        if (g.user.hardCurrency < _count * g.dataResource.objectResources[_id].priceHard) {
            hideIt();
            return;
        }
        g.userInventory.addMoney(1,-_count * g.dataResource.objectResources[_id].priceHard);
        g.userInventory.addResource(_id,_count);
        hideIt();
    }

    private function onNo():void {
        hideIt();
    }
}
}
