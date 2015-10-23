/**
 * Created by user on 10/22/15.
 */
package windows.buyForHardCurrency {
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WOBuyForHardCurrency extends Window{
    private var _contBtnYes:CSprite;
    private var _contBtnNo:CSprite;
    private var _imageYes:Image;
    private var _imageNo:Image;
    private var _txtYes:TextField;
    private var _txtNo:TextField;
    private var _id:int;
    private var _count:int;
    private var _txtCost:TextField;

    public function WOBuyForHardCurrency() {
        super();
        createTempBG(400, 300, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 200;
        _btnExit.y -= 150;
        _imageYes = new Image(g.interfaceAtlas.getTexture("btn2"));
        _imageNo = new Image(g.interfaceAtlas.getTexture("btn2"));
        _txtYes = new TextField(50,50,"Да","Arial",14,Color.BLACK);
        _txtYes.y = -20;
        _txtNo = new TextField(50,50,"Нет","Arial",14,Color.BLACK);
        _txtNo.y = -20;
        _imageYes.width = _imageYes.width/2;
        _imageNo.width = _imageNo.width/2;
        _contBtnNo = new CSprite();
        _contBtnYes = new CSprite();
        _contBtnYes.endClickCallback = onYes;
        _contBtnNo.endClickCallback = onNo;
        _contBtnYes.x += 100;
        _contBtnYes.y += 100;
        _contBtnNo.x -= 150;
        _contBtnNo.y += 100;
        _contBtnNo.addChild(_imageNo);
        _contBtnYes.addChild(_imageYes);
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
        _txtCost= new TextField(250,50,"Подтвердить покупку за " + String(count * g.dataResource.objectResources[id].priceHard) +" ?","Arial",14,Color.BLACK);
        var im:Image = new Image(g.interfaceAtlas.getTexture("diamont"));
        MCScaler.scale(im,25,25);
        _source.addChild(_txtCost);
        _source.addChild(im);
        _txtCost.x -= 150;
        _txtCost.y -= 20;
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
