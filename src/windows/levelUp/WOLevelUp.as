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

import utils.CButton;

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
    private var _contBtn:CButton;
    private var _contImage:Sprite;
    private var _contClipRect:Sprite;
    private var _arrCells:Array;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _shift:int;
    private var _woBG:WindowBackground;

    public function WOLevelUp() {
        super ();
        closeOnBgClick = false;
        _woWidth = 551;
        _woHeight = 409;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var bg:Image;
        bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newlevel_window_fon'));
        bg.x = -_woWidth/2 + 10;
        bg.y = -_woHeight/2 + 15;
        _source.addChild(bg);
        createExitButton(onClickExit);

        var im:Image;
        _contClipRect = new Sprite();
        _contImage = new Sprite();
        _arrCells = [];
        _source.addChild(_contClipRect);
        _contClipRect.clipRect = new Rectangle(0,0,440,280);
        _contClipRect.x = -_woWidth/2 + 55;
        _contClipRect.y = 55;
        _txtNewLvl = new TextField(120,100,"НОВЫЙ УРОВЕНЬ", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtNewLvl.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtNewObject = new TextField(215,100,"ДОСТУПНЫ НОВЫЕ ОБЪЕКТЫ", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtNewObject.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtLevel = new TextField(300,100,"",g.allData.fonts['BloggerBold'],51,Color.WHITE);
        _txtLevel.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtContinue = new TextField(110,100,"РАССКАЗАТЬ", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtContinue.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtHard = new TextField(50,50,"+1", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtHard.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _contBtn = new CButton();
        _contBtn.addButtonTexture(172, 45, CButton.BLUE, true);
        _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        MCScaler.scale(_imageHard,25,25);

        _txtContinue.y = -25;
        _txtHard.x = 100;
        _imageHard.x = 135;
        _imageHard.y = 12;
        _contBtn.addChild(_imageHard);
        _contBtn.addChild(_txtHard);
        _contBtn.addChild(_txtContinue);
        _contBtn.y = _woHeight/2;
        _contBtn.clickCallback = onClickExit;

        _leftArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        MCScaler.scale(im,61,26);
        im.x = im.width;
        _leftArrow.addDisplayObject(im);
        _leftArrow.setPivots();
        _leftArrow.x = -_woWidth/2 - 9 + _leftArrow.width/2;
        _leftArrow.y = 75 + _leftArrow.height/2;
        _source.addChild(_leftArrow);
        _leftArrow.clickCallback = onLeftClick;


        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        MCScaler.scale(im,61,26);
        im.scaleX *= -1;
        _rightArrow.addDisplayObject(im);
        _rightArrow.setPivots();
        _rightArrow.x = _woWidth/2 - 20 + _rightArrow.width/2;
        _rightArrow.y = 75 + _rightArrow.height/2;
        _source.addChild(_rightArrow);
        _rightArrow.clickCallback = onRightClick;


        _source.addChild(_txtNewLvl);
        _source.addChild(_txtLevel);
        _source.addChild(_txtNewObject);

        _contClipRect.addChild(_contImage);
        _source.addChild(_contBtn);

        _txtNewLvl.x = -67;
        _txtNewLvl.y = -55;
        _txtNewObject.x = -108;
        _txtNewObject.y = 110;
        _txtLevel.x = -152;
        _txtLevel.y = -120;
        callbackClickBG = null;
    }

    public function showLevelUp():void {

        showIt();
        _txtLevel.text = String(g.user.level);
        createList();
        _source.y -= 40;
        _black.y += 40;
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
        clearIt();
        _leftArrow.visible = false;
        _leftArrow.setEnabled = true;
        _rightArrow.visible = false;
        _rightArrow.setEnabled = true;
    }

    private function onLeftClick():void {
        _shift -= 5;
        if (_shift < 0) _shift = 0;
        animList();
        checkBtns();
    }

    private function onRightClick():void {
        _shift += 5;
        if (_shift > int(_arrCells.length - 5)) _shift = int(_arrCells.length - 5);
        animList();
        checkBtns();
    }

    private function checkBtns():void {
        if (_arrCells.length > 5) {
            if (_shift <= 0) {
                _leftArrow.setEnabled = false;
            } else {
                _leftArrow.setEnabled = true;
            }
            if (_shift + 5 >= _arrCells.length) {
                _rightArrow.setEnabled = false;
            } else {
                _rightArrow.setEnabled = true;
            }
        }
    }

    private function clearIt():void {
        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
        _shift = 0;
        checkBtns();
        animList();
        for (var i:int=0; i<_arrCells.length; i++) {
            _arrCells[i].clearIt();
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
        var objDataLevel:Object;
        var id:String;
        var arr:Array;
        var im:WOLevelUpItem;
        var i:int;
        _leftArrow.visible = false;
        _rightArrow.visible = false;
        arr = [];
        obj = g.dataResource.objectResources;
        for (id in obj) {
            if (obj[id].buildType == BuildType.TEST || obj[id].buildType == BuildType.INSTRUMENT) continue;
            if (g.user.level == obj[id].blockByLevel) {
                arr.push(obj[id]);
            }
        }
        obj = g.dataBuilding.objectBuilding;
        for (id in obj) {
            if (obj[id].buildType == BuildType.TREE || obj[id].buildType == BuildType.FARM) {
                if (g.user.level == obj[id].blockByLevel[0]) {
                    arr.push(obj[id]);
                }
            } else if (g.user.level == obj[id].blockByLevel) {
                if (obj[id].buildType == BuildType.TEST) continue;
                arr.push(obj[id]);
            }
        }
        if (g.dataLevel.objectLevels[g.user.level].countHard > 0) {
            objDataLevel = {};
            objDataLevel.hard = true;
            objDataLevel.countHard = g.dataLevel.objectLevels[g.user.level].countHard;
            arr.push(objDataLevel);
        }
        if (g.dataLevel.objectLevels[g.user.level].countSoft > 0) {
            objDataLevel = {};
            objDataLevel.coins = true;
            objDataLevel.countSoft = g.dataLevel.objectLevels[g.user.level].countSoft;
            arr.push(objDataLevel);
        }

        if (g.dataLevel.objectLevels[g.user.level].decorId[0] > 0) {
            for (i = 0; i < g.dataLevel.objectLevels[g.user.level].decorId.length; i++) {
                objDataLevel = {};
                objDataLevel.decorData = true;
                objDataLevel.id = g.dataLevel.objectLevels[g.user.level].decorId[i];
                objDataLevel.count = g.dataLevel.objectLevels[g.user.level].countDecor[i];
                arr.push(objDataLevel);
            }
        }

        if (g.dataLevel.objectLevels[g.user.level].resourceId[0] > 0) {
            for (i = 0; i < g.dataLevel.objectLevels[g.user.level].resourceId.length; i++) {
                objDataLevel = {};
                objDataLevel.resourceData = true;
                objDataLevel.id = g.dataLevel.objectLevels[g.user.level].resourceId[i];
                objDataLevel.count = g.dataLevel.objectLevels[g.user.level].countResource[i];
                arr.push(objDataLevel);
            }
        }
        for (i = 0; i < arr.length; i++) {
            im = new WOLevelUpItem(arr[i],true, true, 3);
            im.source.x = int(i) * (90);
            _arrCells.push(im);
            _contImage.addChild(im.source);
        }
        if (_arrCells.length == 1) {
            _contImage.x = 200;
        } else if (_arrCells.length == 2) {
            _contImage.x = 160;
        } else if (_arrCells.length == 3) {
            _contImage.x = 100;
        } else if (_arrCells.length == 4) {
            _contImage.x = 50;
        }
        if (_arrCells.length > 5) {
            _leftArrow.visible = true;
            _leftArrow.setEnabled = false;
            _rightArrow.visible = true;
        }
    }

}
}
