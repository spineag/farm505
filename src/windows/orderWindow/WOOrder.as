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
    private var _contItem:CSprite;
    private var _contBtn:CSprite;
    private var _contImage:Sprite;
//    private var _imageXp:Image;
//    private var _imageCoin:Image;
//    private var _imageDelete:Image;
    private var _imageBtn:Image;
    private var _txtBtn:TextField;
    public function WOOrder() {
        super ();
        _contImage = new Sprite();
        _contItem = new CSprite();
        _contBtn = new CSprite();
        createTempBG(500, 400, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 250;
        _btnExit.y -= 200;
//        _imageCoin = new Image(g.interfaceAtlas.getTexture("coin"));
//        _imageCoin.y = -100;
//        MCScaler.scale(_imageCoin,30,30);
//        _imageXp = new Image(g.interfaceAtlas.getTexture("star"));
//        _imageXp.x = 50;
//        _imageXp.y = -100;
//        MCScaler.scale(_imageXp,30,30);
//        _imageDelete = new Image(g.interfaceAtlas.getTexture("vedro_icon"));
//        _imageDelete.x = 100;
//        _imageDelete.y = -100;
//        MCScaler.scale(_imageDelete,30,30);
        _txtBtn = new TextField(100,100,"Оформить заказ","Arial",14,Color.BLACK);
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn4"));
        _imageBtn.x = 150;
        _imageBtn.y = 130;
//        _source.addChild(_imageXp);
//        _source.addChild(_imageDelete);
//        _source.addChild(_imageCoin);
        _contBtn.endClickCallback = onClickBtn;
        _contItem.endClickCallback = onClickItem;
        _source.addChild(_contItem);
        _source.addChild(_contImage);
        _contBtn.addChild(_imageBtn);
        _source.addChild(_contBtn);
    }

    public function showItMenu():void {
        showIt();
        createList();
    }

    private function onClickItem():void {
        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        createItem();
    }

    private function onClickBtn():void {
        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    private function createItem():void {
        var obj:Object;
        var id:String;
        var arr:Array;
        var r:int;
        arr = [];
        obj = g.dataResource.objectResources;
        for (id in obj) {
            if (g.user.level >= obj[id].blockByLevel) {
                arr.push(obj[id]);
            }
        }
        for (var i:int = 0; i < int(1 + Math.random() * 4); i++) {
            r = int(1 + Math.random() * arr.length);
            var item:WOOrderList;
            item = new WOOrderList(obj[r]);
            item.source.x = (i * 60);
            if(item.source)_contImage.addChild(item.source);
        }
    }

    private function createList():void {
        var im:WOOrderItem;
        im = new WOOrderItem();
        im.source.x = -240;
        im.source.y = -150;
        _contItem.addChild(im.source);

        var im1:WOOrderItem;
        im1 = new WOOrderItem();
        im1.source.x = -120;
        im1.source.y = -150;
        _contItem.addChild(im1.source);
//
//        var im2:WOOrderItem;
//        im2 = new WOOrderItem();
//        im2.source.y = -150;
//        _cont.addChild(im2.source);
    }
}
}
