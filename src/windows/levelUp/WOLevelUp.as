/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import data.BuildType;

import flash.geom.Rectangle;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WOLevelUp extends Window{
    private var _txtCongratulations:TextField;
    private var _txtLevel:TextField;
    private var _txtContinue:TextField;
    private var _txtHard:TextField;
    private var _imageBtn:Image;
    private var _imageHard:Image;
    private var _contBtn:CSprite;
    private var _contImage:Sprite;
    private var _contClipRect:Sprite;
    private var _arrCells:Array;
    private var _leftArrow:CSprite;
    private var _rightArrow:CSprite;
    private var _shift:int;


    public function WOLevelUp() {
        super ();
        var im:Image;
        createTempBG(500, 500, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 250;
        _btnExit.y -= 250;
        _contBtn = new CSprite();
        _contClipRect = new Sprite();
        _contImage = new Sprite();
        _leftArrow = new CSprite();
        _rightArrow = new CSprite();
        _arrCells = [];
        _source.addChild(_contClipRect);
        _contClipRect.clipRect = new Rectangle(0,0,300,220);
        _contClipRect.x = -150;
        _contClipRect.y = -100;
        _contBtn.endClickCallback = onClick;
        _txtCongratulations = new TextField(120,100,"Поздравляю","Arial",18,Color.WHITE);
        _txtLevel = new TextField(300,100,"","Arial",18,Color.WHITE);
        _txtContinue = new TextField(100,100,"Рассказать","Arial",18,Color.WHITE);
        _txtHard = new TextField(50,50,"+1","Arial",18,Color.WHITE);
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn1"));
        _imageHard = new Image(g.interfaceAtlas.getTexture("diamont"));
        MCScaler.scale(_imageHard,25,25);

        _leftArrow = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('shop_arrow'));
        im.scaleX = -1;
        im.x = im.width;
        _leftArrow.addChild(im);
        _leftArrow.x = -200;
        _leftArrow.y = -50;
        _source.addChild(_leftArrow);
        _leftArrow.endClickCallback = onLeftClick;


        _rightArrow = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('shop_arrow'));
        _rightArrow.addChild(im);
        _rightArrow.x = 180;
        _rightArrow.y = -50;
        _source.addChild(_rightArrow);
        _rightArrow.endClickCallback = onRightClick;


        _contBtn.addChild(_imageBtn);
        _source.addChild(_txtCongratulations);
        _source.addChild(_txtLevel);
        _contBtn.addChild(_imageHard);
        _contBtn.addChild(_txtHard);
        _contBtn.addChild(_txtContinue);
        _source.addChild(_contBtn);
        _contClipRect.addChild(_contImage);

        _txtCongratulations.x = -50;
        _txtCongratulations.y = -250;
        _txtLevel.x = -145;
        _txtLevel.y = -200;
        _txtContinue.x = -80;
        _txtContinue.y = 200;
        _txtHard.x = 40;
        _txtHard.y = 225;
        _imageHard.x = 80;
        _imageHard.y = 238;
        _imageBtn.x = -100;
        _imageBtn.y = 225;

    }

    public function showLevelUp():void {
        g.hideAllHints();
        showIt();
        _txtLevel.text = "Вы достигли " + g.user.level + " уровень";
        createList();
    }

    public function onClick():void {
        hideIt();
        clearIt();
    }

    private function onClickExit(e:Event):void {
        hideIt();
        clearIt();
    }

    private function onLeftClick():void {
        _shift -= 3;
        if (_shift < 0) _shift = 0;
        animList();

    }

    private function onRightClick():void {
        _shift += 3;
        if (_shift > int(_arrCells.length/2+.5) -3) _shift = int(_arrCells.length/2+.5) -3 ;
        animList();
    }

    private function clearIt():void {
        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        _arrCells.length = 0;
    }

    private function animList():void {
        var tween:Tween = new Tween(_contImage, .5);
        tween.moveTo(-_shift*100,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
    }

    private function createList():void {
        var obj:Object;
        var id:String;
        var arr:Array;
        var im:WOLevelUpItem;
        _leftArrow.visible = false;
        _rightArrow.visible = false;
        arr = [];
        obj = g.dataResource.objectResources;
        for (id in obj) {
            if (obj.buildType == BuildType.TEST || obj.buildType == BuildType.INSTRUMENT) continue;
            if (g.user.level == obj[id].blockByLevel) {
                arr.push(obj[id]);
            }
        }
        obj = g.dataBuilding.objectBuilding;
        for (id in obj) {
            if (g.user.level == obj[id].blockByLevel) {
                if (obj.buildType == BuildType.TEST || obj.buildType == BuildType.AMBAR || obj.buildType == BuildType.SKLAD || obj.buildType == BuildType.WILD) continue;
                arr.push(obj[id]);
            }
        }

        for (var i:int = 0; i < arr.length; i++) {
            im = new WOLevelUpItem(arr[i], "new");
            im.source.x = int(i / 2) * (100);
            im.source.y = i % 2 * (110);
            _arrCells.push(im);
            _contImage.addChild(im.source);
        }
        if (_arrCells.length >= 6) {
            _leftArrow.visible = true;
            _rightArrow.visible = true;
        }
    }
}
}
