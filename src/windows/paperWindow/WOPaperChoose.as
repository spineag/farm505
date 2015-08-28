/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import data.BuildType;

import manager.Vars;

import resourceItem.CraftItem;
import resourceItem.ResourceItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

import windows.Window;
import windows.ambar.AmbarProgress;

public class WOPaperChoose extends Window{
    private var _contImage:CSprite;

    private var _imageBg:Image;
    private var _imageItemBg:Image;
    private var _imageItem:Image;
    private var _imageCoin:Image;

    private var _txtCost:TextField;
    private var _txtCount:TextField;
    private var _txtSale:TextField;

    private var _data:Object;
    private var _progress:AmbarProgress;
    private var _resourceItem:ResourceItem;

    public function WOPaperChoose(ob:Object) {
        super();
        _data = ob;
        _contImage = new CSprite();
        _contImage.endClickCallback = onClick;
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x = 240;
        _btnExit.y = -210;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        showIt();
        if (ob.buildType == BuildType.INSTRUMENT) {
            _imageItem = new Image(g.instrumentAtlas.getTexture(ob.imageShop));

        } else if (ob.buildType == BuildType.PLANT || ob.buildType == BuildType.RESOURCE) {
            if (ob.url == "plantAtlas") {
                _imageItem = new Image(g.plantAtlas.getTexture(ob.imageShop));
            } else {
                _imageItem = new Image(g.resourceAtlas.getTexture(ob.imageShop));
            }
        }
        MCScaler.scale(_imageItem,50,50);
        _imageItem.x = 60;
        _imageItem.y = 100;
        _imageBg = new Image(g.interfaceAtlas.getTexture("wo_ambar"));
        _imageItemBg = new Image(g.interfaceAtlas.getTexture("tempItemBG"));
        _imageItemBg.x = 30;
        _imageItemBg.y = 80;
        _imageCoin = new Image(g.interfaceAtlas.getTexture("coin"));
        _imageCoin.x = 60;
        _imageCoin.y = 150;
        MCScaler.scale(_imageCoin,25,25);
        _txtCost = new TextField(50,50,"100","Arial",14,Color.BLACK);
        _txtCost.x = 75;
        _txtCost.y = 140;
        _txtSale = new TextField(60,50,"","Arial",14,Color.BLACK);
        _txtSale.x = 40;
        _txtSale.y = 90;
        _txtCount = new TextField(50,50,"5","Arial",14,Color.BLACK);
        _txtCount.x = 60;
        _txtCount.y = 120;

        source.addChild(_imageBg);
        _contImage.addChild(_imageItemBg);
        _contImage.addChild(_imageItem);
        _contImage.addChild(_imageCoin);
        _contImage.addChild(_txtCost);
        _contImage.addChild(_txtCount);
        _contImage.addChild(_txtSale);
        source.addChild(_contImage);
        source.x = g.stageWidth/2;
        source.y = g.stageHeight/2;
        source.x = 250;
        source.y = 50;
    }

    private function onClickExit():void {
        hideIt();
        while (source.numChildren) {
            source.removeChildAt(0);
        }
    }

    private function onClick():void {
        g.userInventory.addResource(_data.id,int(_txtCount.text));
        if (g.userInventory.currentCountInAmbar >= g.user.ambarMaxCount) {
            g.userInventory.addResource(_data.id,-int(_txtCount.text));
            g.flyMessage.showIt(source,"Амбар заполнен");
            return;
        }
        if(_txtSale.text == "продано") return;
        _txtSale.text = "продано";
        g.userInventory.addResource(_data.id,int(_txtCount.text));
        g.userInventory.addMoney(2,-int(_txtCost.text));
        _resourceItem = new ResourceItem();
        _resourceItem.fillIt(_data);
//        var item:CraftItem = new CraftItem(0,0,_resourceItem,source,1);
//        _progress = new AmbarProgress();
//        if (_data.BuildType == BuildType.PLACE_AMBAR) {
//            _progress.setProgress(g.userInventory.currentCountInAmbar/g.user.ambarMaxCount,true);
//        } else {
//            _progress.setProgress(g.userInventory.currentCountInSklad/g.user.skladMaxCount,false);
//        }
//        source.addChild(_progress.source);
    }
}
}
