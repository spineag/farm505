/**
 * Created by user on 10/22/15.
 */
package windows.buyForHardCurrency {
import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOBuyForHardCurrency extends Window{
    private var _contBtnYes:CSprite;
    private var _contBtnNo:CSprite;
    private var _txtYes:TextField;
    private var _txtNo:TextField;
    private var _id:int;
    private var _count:int;
    private var _woBG:WindowBackground;
    private var _txtCost:TextField;

    public function WOBuyForHardCurrency() {
        super();
        _woWidth = 400;
        _woHeight = 300;
//        createTempBG();
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        var yes:WOButtonTexture = new WOButtonTexture(70, 40, WOButtonTexture.BLUE);
        var no:WOButtonTexture = new WOButtonTexture(70, 40, WOButtonTexture.BLUE);
        _txtYes = new TextField(50,50,"Да",g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        _txtYes.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtYes.y = -5;
        _txtNo = new TextField(50,50,"Нет",g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        _txtNo.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtNo.y = -5;
        _contBtnNo = new CSprite();
        _contBtnYes = new CSprite();
        _contBtnYes.endClickCallback = onYes;
        _contBtnNo.endClickCallback = onNo;
        _contBtnYes.x += 70;
        _contBtnYes.y += 70;
        _contBtnNo.x -= 150;
        _contBtnNo.y += 70;
        _contBtnNo.addChild(no);
        _contBtnYes.addChild(yes);
        _contBtnYes.addChild(_txtYes);
        _contBtnNo.addChild(_txtNo);
        _source.addChild(_contBtnYes);
        _source.addChild(_contBtnNo);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        _source.removeChild(_txtCost);
    }

    public function showItWO(id:int,count:int):void {
        _id = id;
        _count = count;
//        _txtCost= new TextField(250,50,"Подтвердить покупку за " + String(count * g.dataResource.objectResources[id].priceHard) +" ?","Arial",14,Color.BLACK);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(im,25,25);
//        _source.addChild(_txtCost);
        _source.addChild(im);
//        _txtCost.x -= 150;
//        _txtCost.y -= 20;
        im.x = 80;
        im.y -= 20;
        showIt();

    }

    private function onYes():void {
        g.userInventory.addResource(_id,_count);
        hideIt();
        g.userInventory.addMoney(1,-_count * g.dataResource.objectResources[_id].priceHard);
        _source.removeChild(_txtCost);
    }

    private function onNo():void {
        hideIt();
        _source.removeChild(_txtCost);
    }
}
}
