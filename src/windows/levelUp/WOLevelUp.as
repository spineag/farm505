/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import data.BuildType;
import data.DataMoney;

import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.geom.Rectangle;
import manager.ManagerFilters;
import manager.ManagerWallPost;
import media.SoundConst;

import social.SocialNetworkSwitch;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import tutorial.TutorialAction;
import tutorial.managerCutScenes.ManagerCutScenes;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOLevelUp extends WindowMain {
    private var _txtNewLvl:CTextField;
    private var _txtNewObject:CTextField;
    private var _txtLevel:CTextField;
    private var _txtContinue:CTextField;
    private var _txtHard:CTextField;
    private var _imageHard:Image;
    private var _contBtn:CButton;
    private var _contImage:Sprite;
    private var _count:int;
    private var _contClipRect:Sprite;
    private var _arrCells:Array;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _arrItems:Array;
    private var _shift:int;
    private var _woBG:WindowBackground;
    private var _armature:Armature;

    public function WOLevelUp() {
        super ();
        SOUND_OPEN = SoundConst.LEVEL_COMPLETED;
        _windowType = WindowsManager.WO_LEVEL_UP;
        _woWidth = 551;
        _woHeight = 409;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
//        var st:String = g.dataPath.getGraphicsPath();
//        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/new_level.png',onLoad);
        if (g.allData.factory['new_level']) onLoad();
        else g.loadAnimation.load('animations_json/new_level', 'new_level', onLoad);
//        var bg:Image;
//        bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newlevel_window_fon'));
//        bg.x = -_woWidth/2 + 10;
//        bg.y = -_woHeight/2 + 15;
//        _source.addChild(bg);
//        createExitButton(hideIt);
//        _callbackClickBG = hideIt;
//        _count = 1;
//        var im:Image;
//        _contClipRect = new Sprite();
//        _contImage = new Sprite();
//        _arrCells = [];
//        _arrItems = [];
//        _source.addChild(_contClipRect);
//        _contClipRect.mask = new Quad(440,280);
//        _contClipRect.x = -_woWidth/2 + 55;
//        _contClipRect.y = 55;
//        _txtNewLvl = new CTextField(200,100,"НОВЫЙ УРОВЕНЬ");
//        _txtNewLvl.setFormat(CTextField.BOLD18, 16, Color.WHITE);
//        _txtNewLvl.leading = -3;
//        _txtNewObject = new CTextField(400,100,"ДОСТУПНЫ НОВЫЕ ОБЪЕКТЫ");
//        _txtNewObject.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
//        _txtLevel = new CTextField(300,100,"");
//        _txtLevel.setFormat(CTextField.BOLD72, 51, Color.WHITE, ManagerFilters.BROWN_COLOR);
//        _txtContinue = new CTextField(110,100,"РАССКАЗАТЬ");
//        _txtContinue.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
//        _txtContinue.x = 3;
//        _txtHard = new CTextField(50,50,' +'+String(_count));
//        _txtHard.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
//        if (g.user.level <= 5) {
//            _contBtn = new CButton();
//            _contBtn.addButtonTexture(172, 45, CButton.GREEN, true);
//            _txtContinue.text = 'ПРОДОЛЖИТЬ';
//            _txtContinue.y = -26;
//            _txtContinue.x = 36;
//            _contBtn.addChild(_txtContinue);
//            _contBtn.y = _woHeight / 2;
//            _contBtn.clickCallback = onClickNext;
//            _source.addChild(_contBtn);
//        } else {
//            _contBtn = new CButton();
//            _contBtn.addButtonTexture(172, 45, CButton.BLUE, true);
//            _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins_small"));
//            MCScaler.scale(_imageHard, 25, 25);
//
//            _txtContinue.y = -26;
//            _txtHard.x = 93;
//            _imageHard.x = 135;
//            _imageHard.y = 12;
//            _contBtn.addChild(_imageHard);
//            _contBtn.addChild(_txtHard);
//            _contBtn.addChild(_txtContinue);
//            _contBtn.y = _woHeight / 2;
//            _contBtn.clickCallback = onClickShare;
//            _source.addChild(_contBtn);
//
//        }
//        _leftArrow = new CButton();
//        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
//        MCScaler.scale(im,61,26);
//        im.x = im.width;
//        _leftArrow.addDisplayObject(im);
//        _leftArrow.setPivots();
//        _leftArrow.x = -_woWidth/2 - 9 + _leftArrow.width/2;
//        _leftArrow.y = 75 + _leftArrow.height/2;
//        _source.addChild(_leftArrow);
//        _leftArrow.clickCallback = onLeftClick;
//
//        _rightArrow = new CButton();
//        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
//        MCScaler.scale(im,61,26);
//        im.scaleX *= -1;
//        _rightArrow.addDisplayObject(im);
//        _rightArrow.setPivots();
//        _rightArrow.x = _woWidth/2 - 20 + _rightArrow.width/2;
//        _rightArrow.y = 75 + _rightArrow.height/2;
//        _source.addChild(_rightArrow);
//        _rightArrow.clickCallback = onRightClick;
//
//        _source.addChild(_txtNewLvl);
//        _source.addChild(_txtLevel);
//        _source.addChild(_txtNewObject);
//
//        _contClipRect.addChild(_contImage);
//
//        _txtNewLvl.x = -100;
//        _txtNewLvl.y = -55;
//        _txtNewObject.x = -200;
//        _txtNewObject.y = 110;
//        _txtLevel.x = -152;
//        _txtLevel.y = -118;
//        _callbackClickBG = null;
    }

    private function onLoad():void {
        _armature = g.allData.factory['new_level'].buildArmature("cat");
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armature);
        (_armature.display as StarlingArmatureDisplay).y = -15;
//        var st:String = g.dataPath.getGraphicsPath();
//        bitmap = g.pBitmaps[st + 'qui/new_level.png'].create() as Bitmap;
//        photoFromTexture(Texture.fromBitmap(bitmap));
        photoFromTexture();
    }

    private function photoFromTexture():void {
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _count = 1;
        var im:Image;
        _contClipRect = new Sprite();
        _contImage = new Sprite();
        _arrCells = [];
        _arrItems = [];
        _source.addChild(_contClipRect);
        _contClipRect.mask = new Quad(440,280);
        _contClipRect.x = -_woWidth/2 + 55;
        _contClipRect.y = 55;

        _txtNewLvl = new CTextField(200,100,"НОВЫЙ УРОВЕНЬ");
        _txtNewLvl.setFormat(CTextField.BOLD18, 16, Color.WHITE);
        _txtNewLvl.leading = -3;
        var sp:Sprite = new Sprite();
        var b:Slot = _armature.getSlot('text');
        if (b) {
            b.displayList = null;
            b.display = sp;
        }
        _txtNewObject = new CTextField(400,100,"ДОСТУПНЫ НОВЫЕ ОБЪЕКТЫ");
        _txtNewObject.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtLevel = new CTextField(300,100,"");
        _txtLevel.setFormat(CTextField.BOLD72, 51, Color.WHITE, ManagerFilters.BROWN_COLOR);
        b = _armature.getSlot('number');
        if (b) {
            b.displayList = null;
            b.display = sp;
        }
        _txtContinue = new CTextField(110,100,"РАССКАЗАТЬ");
        _txtContinue.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtContinue.x = 3;
        _txtHard = new CTextField(50,50,' +'+String(_count));
        _txtHard.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        if (g.user.level <= 5 || (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID && g.user.level > 30)) {
            _contBtn = new CButton();
            _contBtn.addButtonTexture(172, 45, CButton.GREEN, true);
            _txtContinue.text = 'ПРОДОЛЖИТЬ';
            _txtContinue.y = -26;
            _txtContinue.x = 36;
            _contBtn.addChild(_txtContinue);
            _contBtn.y = _woHeight / 2;
            _contBtn.clickCallback = onClickNext;
            _source.addChild(_contBtn);
        } else {
            _contBtn = new CButton();
            _contBtn.addButtonTexture(172, 45, CButton.BLUE, true);
            _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins_small"));
            MCScaler.scale(_imageHard, 25, 25);

            _txtContinue.y = -26;
            _txtHard.x = 93;
            _imageHard.x = 135;
            _imageHard.y = 12;
            _contBtn.addChild(_imageHard);
            _contBtn.addChild(_txtHard);
            _contBtn.addChild(_txtContinue);
            _contBtn.y = _woHeight / 2;
            _contBtn.clickCallback = onClickShare;
            _source.addChild(_contBtn);

        }
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

        _txtNewLvl.x = -104;
        _txtNewLvl.y = -50;
        _txtNewObject.x = -200;
        _txtNewObject.y = 110;
        _txtLevel.x = -154;
        _txtLevel.y = -108;
        _callbackClickBG = null;
        _armature.animation.gotoAndPlayByFrame('idle');


        if (g.user.level >= 17) g.couponePanel.openPanel(true);
        _txtLevel.text = String(g.user.level);
        createList();
        onWoShowCallback = onShow;
//        super.showIt();
        _source.y -= 40;

        super.showIt();
    }


    override public function showItParams(callback:Function, params:Array):void {
//        if (g.user.level >= 17) g.couponePanel.openPanel(true);
//        _txtLevel.text = String(g.user.level);
//        createList();
//        onWoShowCallback = onShow;
////        super.showIt();
//        _source.y -= 40;
    }
    
    private function onShow():void {
        _txtContinue.updateIt();
        _txtHard.updateIt();
        _txtLevel.updateIt();
        _txtNewLvl.updateIt();
        _txtNewObject.updateIt();
        for (var i:int=0; i<_arrCells.length; i++) {
            _arrCells[i].updateTextField();
        }
    }

    private function onClickNext():void {
        hideIt();
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
            if (obj[id].buildType == BuildType.INSTRUMENT) continue;
            if (g.user.level == obj[id].blockByLevel) {
                arr.push(obj[id]);
            }
        }
        obj = g.dataBuilding.objectBuilding;
        for (id in obj) {
            if (obj[id].buildType != BuildType.CHEST) {
                if (obj[id].buildType == BuildType.TREE || obj[id].buildType == BuildType.FARM || obj[id].buildType == BuildType.FABRICA) {
                    for (i = 0; i < obj[id].blockByLevel.length; i++) {
                        if (g.user.level == obj[id].blockByLevel[i]) {
                            arr.push(obj[id]);
                            if (obj[id].buildType == BuildType.TREE) g.user.plantNotification++;
                            if (obj[id].buildType == BuildType.FARM) g.user.villageNotification++;
                            if (obj[id].buildType == BuildType.FABRICA) g.user.fabricaNotification++;
                        }
                    }
                } else if (g.user.level == obj[id].blockByLevel && obj[id].visibleAction) {
                    if (obj[id].buildType != BuildType.CAVE && obj[id].buildType != BuildType.TRAIN && obj[id].buildType != BuildType.PAPER && obj[id].buildType != BuildType.DAILY_BONUS
                            && obj[id].buildType != BuildType.ORDER && obj[id].buildType != BuildType.MARKET) {
                        g.user.decorNotification++;
                    }
                    arr.push(obj[id]);
                }
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
        if (g.dataLevel.objectLevels[g.user.level].catCount > 0) {
            objDataLevel = {};
            objDataLevel.catCount = true;
            objDataLevel.id = -1;
            objDataLevel.count = g.dataLevel.objectLevels[g.user.level].catCount;
            arr.push(objDataLevel);
            g.user.villageNotification++
        }
        if (g.dataLevel.objectLevels[g.user.level].ridgeCount > 0) {
            objDataLevel = {};
            objDataLevel.ridgeCount = true;
//            objDataLevel.id = -2;
            objDataLevel.count = g.dataLevel.objectLevels[g.user.level].ridgeCount;
            arr.push(objDataLevel);
            g.user.villageNotification++
        }
        for (i = 0; i < arr.length; i++) {
            if (arr[i].buildType == BuildType.FARM) {
                obj = g.dataAnimal.objectAnimal;
                for (id in obj) {
                    if (obj[id].buildId == arr[i].id){
                       arr.push(obj[id]);
                    }
                }
            }
            _arrItems.push(arr[i]);
            if (_arrItems[i].buildType == BuildType.RESOURCE || _arrItems[i].buildType == BuildType.PLANT) {
                g.user.fabricItemNotification.push(_arrItems[i]);
            }
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
        } else if (_arrCells.length == 5) {
            _contImage.x = 3;
        }
        if (g.user.level >= 3) g.bottomPanel.notification();
        else {
            g.user.villageNotification = 0;
            g.user.decorNotification = 0;
            g.user.fabricaNotification = 0;
            g.user.plantNotification = 0;
            g.user.allNotification = 0;
        }
        g.directServer.updateUserNotification(null);
        if (_arrCells.length > 5) {
            _contImage.x = 3;
            _leftArrow.visible = true;
            _leftArrow.setEnabled = false;
            _rightArrow.visible = true;
        }
    }

    private function onClickShare():void {
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
        g.managerWallPost.openWindow(ManagerWallPost.NEW_LEVEL,null,_count,DataMoney.HARD_CURRENCY);
        hideIt();
    }

    override protected function deleteIt():void {
        g.levelUpHint.hideIt();
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.LEVEL_UP) {
            g.managerTutorial.checkTutorialCallback();
        }
        g.managerCutScenes.checkCutScene(ManagerCutScenes.REASON_NEW_LEVEL);
        if (g.user.level == 3 || g.user.level == 4) g.managerMiniScenes.checkAvailableMiniScenesOnNewLevel();

        if (g.user.level == 5) g.managerQuest.addUI();
        if (_txtNewLvl) {
            _source.removeChild(_txtNewLvl);
            _txtNewLvl.deleteIt();
            _txtNewLvl = null;
        }
        if (_txtNewObject) {
            _source.removeChild(_txtNewObject);
            _txtNewObject.deleteIt();
            _txtNewObject = null;
        }
        if (_txtLevel) {
            _source.removeChild(_txtLevel);
            _txtLevel.deleteIt();
            _txtLevel = null;
        }
        if (_txtContinue) {
            _contBtn.removeChild(_txtContinue);
            _txtContinue.deleteIt();
            _txtContinue = null;
        }
        if (_txtHard) {
            _contBtn.removeChild(_txtHard);
            _txtHard.deleteIt();
            _txtHard = null;
        }

        for (var i:int=0; i<_arrCells.length; i++) {
            _arrCells[i].deleteIt();
        }
        _arrCells.length = 0;
        if (_armature) {
            _source.removeChild(_armature.display as Sprite);
            _armature = null;
        }
        if (_contBtn) {
            _source.removeChild(_contBtn);
            _contBtn.deleteIt();
            _contBtn = null;
        }
        if (_leftArrow) {
            _source.removeChild(_leftArrow);
            _leftArrow.deleteIt();
            _leftArrow = null;
        }
        if (_rightArrow) {
            _source.removeChild(_rightArrow);
            _rightArrow.deleteIt();
            _rightArrow = null;
        }
        if (_woBG) {
            _source.removeChild(_woBG);
            _woBG.deleteIt();
            _woBG = null;
        }
        super.deleteIt();
    }

}
}
