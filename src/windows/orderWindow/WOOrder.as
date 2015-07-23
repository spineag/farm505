/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WOOrder extends Window{
    private var _contBtn:CSprite;
    private var _imageBtn:Image;
    private var _imageXp:Image;
    private var _imageCoin:Image;
    private var _imageDelete:Image;
    private var _txtBtn:TextField;
    private var _txtOrder:TextField;
    private var _contImage:CSprite;

    public function WOOrder() {
        super ();
        _contImage = new CSprite();
        _contBtn = new CSprite();

        createTempBG(300, 300, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 150;
        _btnExit.y -= 150;

        _imageCoin = new Image(g.interfaceAtlas.getTexture("coin"));
        _imageCoin.y = -100;
        MCScaler.scale(_imageCoin,30,30);
        _imageXp = new Image(g.interfaceAtlas.getTexture("star"));
        _imageXp.x = 50;
        _imageXp.y = -100;
        MCScaler.scale(_imageXp,30,30);
        _imageDelete = new Image(g.interfaceAtlas.getTexture("vedro_icon"));
        _imageDelete.x = 100;
        _imageDelete.y = -100;
        MCScaler.scale(_imageDelete,30,30);
        _txtOrder = new TextField(100,100,"Стол заказов","Arial",14,Color.BLACK);
        _txtBtn = new TextField(100,100,"Оформить заказ","Arial",14,Color.BLACK);
        _txtBtn.x = 60;
        _txtBtn.y = 75;
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn4"));
        _imageBtn.x = 60;
        _imageBtn.y = 90;
        _source.addChild(_imageBtn);
        _source.addChild(_contBtn);
        _source.addChild(_txtBtn);
        _source.addChild(_imageXp);
        _source.addChild(_imageDelete);
        _source.addChild(_imageCoin);
    }

    public function showItMenu():void {
        showIt();
        createList();
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    private function createList():void {
        var obj:Object;
        var id:String;
        var arr:Array;
        var im:WOOrderItem;
        arr = [];
        obj = g.dataResource.objectResources;
        for (id in obj) {
            if (g.user.level >= obj[id].blockByLevel) {
                arr.push(obj[id]);
            }
        }
        im = new WOOrderItem(obj[id]);
        _source.addChild(im.source);
//        for (var i:int = 0; i < arr.length; i++) {
//            im = new WOOrderItem(arr[i]);
//            im.source.x = int(i / 2) * (100);
//            im.source.y = i % 2 * (110);
//            _arrCells.push(im);
//            _contImage.addChild(im.source);
//        }
    }
}
}
