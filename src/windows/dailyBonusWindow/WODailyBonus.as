/**
 * Created by user on 7/23/15.
 */
package windows.dailyBonusWindow {
import data.BuildType;

import resourceItem.ResourceItem;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WODailyBonus extends Window{

    private var _contBtn:CSprite;
    private var _contImage:CSprite;
    private var _imageHard:Image;
    private var _txtItem:TextField;
    private var _imageBtn:Image;
    private var _txtBtn:TextField;
    private var _data:Object;
    public function WODailyBonus() {
        super();

        createTempBG(300,300 , Color.GRAY);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('btn_exit'), '', g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_click'), g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_hover'));
        _btnExit.x += 150;
        _btnExit.y -= 150;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _contBtn = new CSprite();
        _contImage = new CSprite();
        _contImage.y = -50;
        _source.addChild(_contBtn);
        _source.addChild(_contImage);
        _contBtn.endClickCallback = onClick;
        _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("diamont"));
        MCScaler.scale(_imageHard,25,25);
        _imageHard.x = 30;
        _imageHard.y = 75;
        callbackClickBG = onClickExit;
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        while (_contBtn.numChildren) {
            _contBtn.removeChildAt(0);
        }
        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
    }

    private function onClick():void {
        var hard:int;
        hard = 1;
        if (_txtBtn.text == "Забрать"){
            _txtBtn.text = String("Купить за " + hard) ;
            _contBtn.addChild(_imageHard);
            flyBonus();
        } else if (_txtBtn.text == String("Купить за " + hard)){
            if (int(_txtBtn.text) >= g.user.hardCurrency){
                g.woBuyCurrency.showItMenu(true);
                return;
            }
            _contBtn.removeChild(_imageHard);
            _imageHard.visible = true;
            createList();
            _txtBtn.text = "Забрать";
            g.userInventory.addMoney(1,-hard);
        }
    }

    public function showItMenu():void {
        _imageBtn = new Image(g.allData.atlas['interfaceAtlas'].getTexture("btn4"));
        _imageBtn.x = -30;
        _imageBtn.y = 60;
        _txtBtn = new TextField(50,50,"Забрать","Arial",12,Color.WHITE);
        _txtBtn.x = -10;
        _txtBtn.y = 60;
        _contBtn.addChild(_imageBtn);
        _contBtn.addChild(_txtBtn);
        showIt();
        createList();
    }

    private function createList():void {
        var obj:Object;
        var id:String;
        var r:int;
        var arr:Array;
        var im:WODailyBonusItem;
        arr = [];
        obj = g.dataResource.objectResources;
        for (id in obj) {
            if (g.user.level >= obj[id].blockByLevel) {
                arr.push(obj[id]);
            }
        }
        r = int(1+Math.random()*arr.length);
        _data = obj[r];
        im = new WODailyBonusItem(obj[r]);
        _contImage.addChild(im.source);
        _contImage.y = 0;
        _contImage.x = 0;
    }

    private function flyBonus():void {
        g.craftPanel.showIt(_data.placeBuild);
        var tween:Tween = new Tween(_contImage, 1);
        tween.moveTo(-170,-300 );
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            var item:ResourceItem = new ResourceItem();
            item.fillIt(_data);
            g.craftPanel.afterFly(item);
            while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        };
        g.starling.juggler.add(tween);
    }
}
}
