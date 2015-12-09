/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import data.BuildType;

import flash.geom.Rectangle;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;

import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOLevelUp extends Window{
    private var _txtNewLvl:TextField;
    private var _txtNewObject:TextField;
    private var _txtLevel:TextField;
    private var _txtContinue:TextField;
    private var _txtHard:TextField;
    private var _imageHard:Image;
    private var _contBtn:CSprite;
    private var _contImage:Sprite;
    private var _contClipRect:Sprite;
    private var _arrCells:Array;
    private var _leftArrow:CSprite;
    private var _rightArrow:CSprite;
    private var _shift:int;
    private var _woBG:WindowBackground;

    public function WOLevelUp() {
        super ();
        _woWidth = 551;
        _woHeight = 409;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var bg:Image;
        bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newlevel_window_fon'));
        bg.x = -_woWidth/2 + 7;
        bg.y = -_woHeight/2 + 15;
        _source.addChild(bg);
        createExitButton(onClickExit);

        var im:Image;
        _contBtn = new CSprite();
        _contClipRect = new Sprite();
        _contImage = new Sprite();
        _leftArrow = new CSprite();
        _rightArrow = new CSprite();
        _arrCells = [];
        _source.addChild(_contClipRect);
        _contClipRect.clipRect = new Rectangle(0,0,460,220);
        _contClipRect.x = -_woWidth/2 + 47;
        _contClipRect.y = 70;
        _contBtn.endClickCallback = onClickBtn;
        _txtNewLvl = new TextField(120,100,"НОВЫЙ УРОВЕНЬ", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtNewLvl.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtNewObject = new TextField(215,100,"ДОСТУПНЫ НОВЫЕ ОБЬЕКТЫ", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtNewObject.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtLevel = new TextField(300,100,"",g.allData.fonts['BloggerBold'],51,Color.WHITE);
        _txtLevel.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtContinue = new TextField(110,100,"РАССКАЗАТЬ", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtContinue.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtHard = new TextField(50,50,"+1", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtHard.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        var btn:WOButtonTexture = new WOButtonTexture(172, 45, WOButtonTexture.BLUE);
        _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(_imageHard,25,25);

        _leftArrow = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.x = im.width;
        _leftArrow.addChild(im);
        _leftArrow.x = -_woWidth/2 + 9;
        _leftArrow.y = 87;
        _source.addChild(_leftArrow);
        _leftArrow.endClickCallback = onLeftClick;


        _rightArrow = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.scaleX = -1;
        _rightArrow.addChild(im);
        _rightArrow.x = _woWidth/2 - 19;
        _rightArrow.y = 87;
        _source.addChild(_rightArrow);
        _rightArrow.endClickCallback = onRightClick;


        _contBtn.addChild(btn);
        _source.addChild(_txtNewLvl);
        _source.addChild(_txtLevel);
        _source.addChild(_txtNewObject);
        _contBtn.addChild(_imageHard);
        _contBtn.addChild(_txtHard);
        _contBtn.addChild(_txtContinue);
        _source.addChild(_contBtn);
        _contClipRect.addChild(_contImage);

        _txtNewLvl.x = -70;
        _txtNewLvl.y = -55;
        _txtNewObject.x = -100;
        _txtNewObject.y = 125;
        _txtLevel.x = -155;
        _txtLevel.y = -120;
        _txtContinue.x = -80;
        _txtContinue.y = 165;
        _txtHard.x = 5;
        _txtHard.y = 190;
        btn.x = -86;
        btn.y = 193;
        _imageHard.x = 40;
        _imageHard.y = 205;
        callbackClickBG = onClickExit;
    }

    public function showLevelUp():void {
        showIt();
        _txtLevel.text = String(g.user.level);
        createList();
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        clearIt();
    }

    private function onLeftClick():void {
        _shift -= 5;
        if (_shift < 0) _shift = 0;
        animList();
    }

    private function onRightClick():void {
        _shift += 5;
        if (_shift > int(_arrCells.length - 5)) _shift = int(_arrCells.length - 5);
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
        tween.moveTo(-_shift*90,0);
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
            im.source.x = int(i) * (90);
            _arrCells.push(im);
            _contImage.addChild(im.source);
        }
        if (_arrCells.length > 5) {
            _leftArrow.visible = true;
            _rightArrow.visible = true;
        }
    }

    private function onClickBtn():void {

    }
}
}
