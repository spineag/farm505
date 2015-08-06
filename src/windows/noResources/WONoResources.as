/**
 * Created by user on 6/29/15.
 */
package windows.noResources {


import data.BuildType;
import data.DataMoney;

import utils.CSprite;
import utils.MCScaler;

import windows.*;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

public class WONoResources extends Window {
    private var _contBtn:CSprite;
    private var _contImage:Sprite;

    private var _txtHardCost:TextField;
    private var _txtBuyBtn:TextField;
    private var _txtNoResource:TextField;
    private var _txtPanel:TextField;
    private var _txtCount:TextField;

    private var _imageItem:Image;
    private var _imageHard:Image;
    private var _imageBtn:Image;
    private var _arrCells:Array;

    public function WONoResources() {
        super();
        _contBtn = new CSprite();
        _contImage = new Sprite();
        _arrCells = [];
        _contBtn.endClickCallback = onClick;
        createTempBG(400,300 , Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x += 200;
        _btnExit.y -= 150;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _txtHardCost = new TextField(100,100,"","Arial",18,Color.WHITE);
        _txtBuyBtn = new TextField(100,100,"докупить ресурсы","Arial",14,Color.WHITE);
        _txtNoResource = new TextField(300,100,"НЕДОСТАТОЧНО РЕСУРСОВ","Arial",18,Color.WHITE);
        _txtPanel = new TextField(350,200,"Не хватает ингредиентов. Вы можете купить их за изумруды и начать производство немедленно.","Arial",18,Color.WHITE);
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn1"));
        _imageHard = new Image(g.interfaceAtlas.getTexture("diamont"));
        _txtCount = new TextField(50,50,"","Arial",12,Color.WHITE);
        MCScaler.scale(_imageHard, 20, 20);
        _contBtn.addChild(_imageBtn);
        _source.addChild(_txtPanel);
        _source.addChild(_txtNoResource);
        _contBtn.addChild(_txtBuyBtn);
        _contBtn.addChild(_imageHard);
        _source.addChild(_contBtn);
        _source.addChild(_contImage);

        _imageBtn.x -= 50;
        _imageBtn.y +=80;
        _imageBtn.width = 90;
        _imageHard.y += 90;
        _txtNoResource.x -= 150;
        _txtNoResource.y -= 150;
        _txtPanel.x -= 180;
        _txtPanel.y -= 150;
        _txtHardCost.x -= 70;
        _txtHardCost.y += 50;
        _txtBuyBtn.x += 30;
        _txtBuyBtn.y += 50;
        _txtCount.y += 40;
    }

    private function onClickExit(e:Event):void {
        hideIt();
        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        _contImage.removeChild(_imageItem);
        _contImage.removeChild(_txtCount);
        _arrCells.length = 0;
    }

    public function showItMoney(data:Object, count:int):void {
        createListMoney(data,count);
        showIt();
    }

    public function showItMenu(data:Object, count:int):void {
        createList(data,count);
        showIt();
    }

    private function createListMoney(_data:Object, count:int):void {
        if (_data.currency == DataMoney.HARD_CURRENCY){
            _imageItem = new Image(g.interfaceAtlas.getTexture("diamont"));
            _txtCount.text = String(count);
            _contImage.addChild(_imageItem);
            _contImage.addChild(_txtCount);
        }else if (_data.currency == DataMoney.SOFT_CURRENCY){
            _imageItem = new Image(g.interfaceAtlas.getTexture("coin"));
            _txtCount.text = String(count);
            _contImage.addChild(_imageItem);
            _contImage.addChild(_txtCount);
        }
    }

    private function createList(_data:Object, count:int):void {
        var im:WONoResourcesItem;
        var countRes:int = 0;
        var i:int;

        if(_data.buildType == BuildType.ANIMAL) {
            countRes = g.userInventory.getCountResourceById(_data.idResourceRaw);
            if (countRes < count) {
                g.woNoResources.showItMenu(_data, count - countRes);
            }
        }

        for (i=0; i < _data.ingridientsId.length; i++) {
            countRes =  g.userInventory.getCountResourceById(_data.ingridientsId[i]);
            if (countRes < _data.ingridientsCount[i]) {
                im = new WONoResourcesItem(_data.ingridientsId[i], _data.ingridientsCount[i] - countRes);
                _arrCells.push(im);
                _contImage.addChild(im.source);
            }
        }
        for (i=0; i<_arrCells.length; i++) {
            _arrCells[i].source.x = int(i * 55);
        }

        if (_data.priceHard) _txtHardCost.text = String(_data.priceHard * count);
        _txtHardCost.text = "2";
        _contBtn.addChild(_txtHardCost);
    }

    private function onClick():void {
        hideIt();
        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        _arrCells.length = 0;
    }
}
}
