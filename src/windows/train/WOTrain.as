/**
 * Created by user on 7/23/15.
 */
package windows.train {
import build.train.Train;
import data.BuildType;
import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFabricaRecipe;
import manager.ManagerFilters;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTrain extends WindowMain {
    public static var CELL_RED:int = 1;
    public static var CELL_GREEN:int = 2;
    public static var CELL_BLUE:int = 3;
    public static var CELL_GRAY:int = 4;

    private var _woBG:WindowBackground;
    private var _rightBlock:Sprite;
    private var _leftBlock:Sprite;
    private var _arrItems:Array;
    private var _btnSend:CButton;
    private var _btnLoad:CButton;
    private var _btnHelp:CButton;
    private var _txtHelp:CTextField;
    private var _activeItemIndex: int;
    private var _build:Train;
    private var _txt:CTextField;
    private var _txtCounter:CTextField;
    private var _txtLoad:CTextField;
    private var _counter:int;
    private var _idFree:int;
    private var _countFree:int;
    private var _txtCostItem:CTextField;
    private var _txtXpItem:CTextField;
    private var _txtCostAll:CTextField;
    private var _txtXpAll:CTextField;
    private var _txtSend:CTextField;
    private var _txtPrise:CTextField;
    private var _txtLoad2:CTextField;
    private var _txtC:CTextField;
    private var _txtNeed:CTextField;
    public var _imageItem:Image;
    private var _lock:int;
    private var _isBigCount:Boolean;
    private var _birka:Birka;
    private var _rightBlockBG:CartonBackground;
    private var _rightBlockCarton:CartonBackgroundIn;
    private var _rightBlockCarton2:CartonBackgroundIn;
    private var _leftBlockBG:CartonBackground;

    public function WOTrain() {
        super ();
        _windowType = WindowsManager.WO_TRAIN;
        _woWidth = 727;
        _woHeight = 529;
        _activeItemIndex = -1;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        createRightBlock();
        createLeftBlock();
        _arrItems = [];
        addItems();

        _btnSend = new CButton();
        _btnSend.addButtonTexture(120, 40, CButton.GREEN, true);
        _btnSend.x = _woWidth/2 - 180;
        _btnSend.y = 205;
        _txtSend = new CTextField(89,62,String(g.managerLanguage.allTexts[292]));
        _txtSend.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtSend.x = 5;
        _txtSend.y = -12;
        _btnSend.addChild(_txtSend);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_kor_ico'));
        im.y = -15;
        im.x = 88;
        _btnSend.addDisplayObject(im);
        _source.addChild(_btnSend);
        _btnSend.setEnabled = false;

        _txt = new CTextField(150, 40, '');
        _txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txt.x = 120;
        _txt.y = 110;
        _source.addChild(_txt);
        _txtCounter = new CTextField(150, 40, '');
        _txtCounter.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtCounter.x = 110;
        _txtCounter.y = 130;
        _source.addChild(_txtCounter);
        _callbackClickBG = hideIt;
        _birka = new Birka(String(g.managerLanguage.allTexts[293]), _source, _woWidth, _woHeight);
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerCutScenes.isCutScene) return;
        super.hideIt();
    }

    private function createRightBlock():void {
        var im:Image;
        _rightBlock = new Sprite();
        _rightBlock.y = -205;
        _rightBlock.x = 35;
        _source.addChild(_rightBlock);
        _rightBlockBG = new CartonBackground(287, 375);
        _rightBlockBG.filter = ManagerFilters.SHADOW;
        _rightBlock.addChild(_rightBlockBG);

        _txtLoad = new CTextField(240, 50, '');
        _txtLoad.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtLoad.x = 25;
        _txtLoad.y = 5;
        _rightBlock.addChild(_txtLoad);
        _rightBlockCarton = new CartonBackgroundIn(267, 68);
        _rightBlockCarton.y = 250;
        _rightBlockCarton.x = 10;
        _rightBlock.addChild(_rightBlockCarton);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        im.y = 325;
        im.x = 20;
        _rightBlock.addChild(im);
        if (!g.isAway) {
            _btnLoad = new CButton();
            _btnLoad.addButtonTexture(130, 36, CButton.YELLOW, true);
            _txtLoad2 = new CTextField(130, 36, String(g.managerLanguage.allTexts[294]));
            _txtLoad2.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_YELLOW_COLOR);
            _txtLoad2.y = -2;
            _btnLoad.addChild(_txtLoad2);
            _btnLoad.x = 200;
            _btnLoad.y = 150;
            _rightBlock.addChild(_btnLoad);
        }
        _txtPrise = new CTextField(240,50,String(g.managerLanguage.allTexts[295]));
        _txtPrise.setFormat(CTextField.BOLD18, 15, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtPrise.y = 240;
        _txtPrise.x = 23;
        _rightBlock.addChild(_txtPrise);

        _txtCostItem = new CTextField(50,40,'-3');
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN) _txtCostItem.setFormat(CTextField.BOLD18, 18, ManagerFilters.PINK_COLOR, Color.WHITE);
        else _txtCostItem.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCostItem.x = 236;
        _txtCostItem.y = 75;
        _txtCostItem.alignH = Align.LEFT;
        _txtXpItem = new CTextField(50,40,'-3');
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN) _txtXpItem.setFormat(CTextField.BOLD18, 18, Color.WHITE, Color.WHITE);
        else _txtXpItem.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtXpItem.x = 165;
        _txtXpItem.y = 75;
        _txtXpItem.alignH = Align.LEFT;
        _txtCostAll = new CTextField(50,40,'-5');
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN) _txtCostAll.setFormat(CTextField.BOLD18, 18, ManagerFilters.PINK_COLOR, Color.WHITE);
        else _txtCostAll.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCostAll.x = 160;
        _txtCostAll.y = 275;
        _txtCostAll.alignH = Align.LEFT;
        _txtXpAll = new CTextField(50,40,'-5');
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN) _txtXpAll.setFormat(CTextField.BOLD18, 18, ManagerFilters.PINK_COLOR, Color.WHITE);
        else _txtXpAll.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtXpAll.x = 75;
        _txtXpAll.y = 275;
        _txtXpAll.alignH = Align.LEFT;

        _rightBlock.addChild(_txtCostItem);
        _rightBlock.addChild(_txtXpItem);
        _rightBlock.addChild(_txtCostAll);
        _rightBlock.addChild(_txtXpAll);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        im.x = 45;
        im.y = 280;
//        MCScaler.scale(im,27,27);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        im.x = 125;
        im.y = 279;
//        MCScaler.scale(im,30,30);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_cup_ico'));
        im.x = 205;
        im.y = 283;
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        im.x = 130;
        im.y = 80;
//        MCScaler.scale(im,27,27);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        im.x = 200;
        im.y = 80;
//        MCScaler.scale(im,30,30);
        _rightBlock.addChild(im);
        _txtC = new CTextField(20,20,'1');
        _txtC.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtC.x = 225;
        _txtC.y = 283;
        _rightBlock.addChild(_txtC);

        _rightBlockCarton2 = new CartonBackgroundIn(90, 90);
        _rightBlockCarton2.x = 20;
        _rightBlockCarton2.y = 70;
        _rightBlock.addChild(_rightBlockCarton2);
    }

    private function createLeftBlock():void {
        _leftBlock = new Sprite();
        _leftBlockBG = new CartonBackground(324, 432);
        _leftBlockBG.filter = ManagerFilters.SHADOW;
        _leftBlock.addChild(_leftBlockBG);
        _leftBlock.y = -205;
        _leftBlock.x = -int(_woWidth/2) + 40;
        _source.addChild(_leftBlock);
        _txtNeed = new CTextField(200,30,String(g.managerLanguage.allTexts[296]));
        _txtNeed.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtNeed.y = 13;
        _txtNeed.x = 60;
        _leftBlock.addChild(_txtNeed);
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        var list:Array = params[0];
        _build = params[1];
        _counter = params[3];
            _txt.text = String(g.managerLanguage.allTexts[297]);
                _isBigCount = list.length > 9;
                var type:int;
                for (var i:int = 0; i < list.length; i++) {
                    if (_isBigCount) type = int(i / 4);
                    else type = int(i / 3);
                    _arrItems[i].fillIt(list[i], i, type + 1);
                    _arrItems[i].clickCallback = onItemClick;
                }
                if (!_isBigCount) {
                    _arrItems[9].fillIt(null, 9, CELL_GRAY);
                    _arrItems[10].fillIt(null, 10, CELL_GRAY);
                    _arrItems[11].fillIt(null, 11, CELL_GRAY);
                }
            _txtCostAll.text = String(_build.allCoinsCount);
            _txtXpAll.text = String(_build.allXPCount);
        var num:int = 0;
        if (!g.managerCutScenes.isCutScene) {
            for (i = 0; i < list.length; i++) {
                if (!list[i].isFull && g.userInventory.getCountResourceById(list[i].id) >= list[i].count) {
                    num = i;
                    break;
                } else num = 0;
            }
        }
        onItemClick(num);
        checkBtn();
        _txtCounter.text = TimeUtils.convertSecondsForHint(_counter);
        g.gameDispatcher.addToTimer(checkCounter);
        super.showIt();
    }
    
    private function checkCounter():void {
        _counter--;
        _txtCounter.text = TimeUtils.convertSecondsForHint(_counter);
    }

    private function addItems():void {
        var item:WOTrainItem;
        for (var i:int = 0; i < 12; i++) {
            item = new WOTrainItem();
            item.source.x = i%3 * 100 - 310;
            if(i >= 9) {
              item.source.y = 110;
            } else if (i >= 6) {
                item.source.y = 20;
            } else if (i >= 3) {
                item.source.y = -70;
            } else {
                item.source.y = -160;
            }
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function onItemClick(k:int):void {
        _activeItemIndex = k;
        if (_btnLoad) _btnLoad.visible = true;
//        _btnHelp.visible = true;
        for (var i:int = 0; i<_arrItems.length; i++) {
            _arrItems[i].activateIt(false);
        }
        _arrItems[_activeItemIndex].activateIt(true);
        if (_arrItems[k].isResourceLoaded) {
            if (_btnLoad) _btnLoad.visible = false;
//            _btnHelp.visible = false;
            if (_txtLoad) _txtLoad.text = String(g.managerLanguage.allTexts[298]);
        } else {
            if (_txtLoad) _txtLoad.text = String(g.managerLanguage.allTexts[299]);
            if (_arrItems[k].canFull()) {
                if (_btnLoad) _btnLoad.clickCallback = onResourceLoad;
            } else  {
                if (_btnLoad) _btnLoad.clickCallback = onClickBuy;
               _idFree = _arrItems[k].idFree;
               _countFree = _arrItems[k].countFree;
            }
        }

        _txtCostItem.text = String(_arrItems[_activeItemIndex].countCoins);
        _txtXpItem.text = String(_arrItems[_activeItemIndex].countXP);
        if (_imageItem) {
            _rightBlock.removeChild(_imageItem);
            _imageItem.filter = null;
            _imageItem.dispose();
            _imageItem = null;
        }
        _imageItem = _arrItems[_activeItemIndex].currentImage();
        MCScaler.scale(_imageItem, 80, 80);
        _imageItem.x = 65 - _imageItem.width/2;
        _imageItem.y = 115 - _imageItem.height/2;
        _rightBlock.addChild(_imageItem);
        if (g.user.isTester) {
            if (g.isAway) {
                if (_arrItems[k].needHelp && int(_arrItems[k].idWhoHelp) <= 0) {
                    if (!_btnHelp) {
                        _btnHelp = new CButton();
                        _btnHelp.addButtonTexture(240, 52, CButton.BLUE, true);
                        _btnHelp.x = 143;
                        _btnHelp.y = 210;
                        _rightBlock.addChild(_btnHelp);
                        _txtHelp = new CTextField(240, 52, String(g.managerLanguage.allTexts[300]));
                        _txtHelp.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        _btnHelp.addChild(_txtHelp);
                        _btnHelp.clickCallback = giftHelpClick;
                    }
                    return;
                } else {
                    if (_btnHelp) {
                        _rightBlock.removeChild(_btnHelp);
                        _btnHelp.deleteIt();
                        _btnHelp = null;
                    }
                    return;
                }
            }
            if (!_arrItems[k].needHelp) {
                if (!_btnHelp && !_arrItems[k].isResourceLoaded) {
                    _btnHelp = new CButton();
                    _btnHelp.addButtonTexture(240, 52, CButton.BLUE, true);
                    var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_rup_ico'));
                    im.y = -10;
                    im.touchable = false;
                    _btnHelp.addDisplayObject(im);
                    _btnHelp.x = 143;
                    _btnHelp.y = 210;
                    _rightBlock.addChild(_btnHelp);
                    _txtHelp = new CTextField(240, 52, String(g.managerLanguage.allTexts[301]));
                    _txtHelp.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                    _btnHelp.addChild(_txtHelp);
                    _txtHelp.x = 10;
                    _btnHelp.clickCallback = wantHelpClick;
                }
            } else {
                if (_btnHelp) {
                    _rightBlock.removeChild(_btnHelp);
                    _btnHelp.deleteIt();
                    _btnHelp = null;
                }
            }
        }
    }

    private function giftHelpClick(lastResource:Boolean = false):void {
        var obj:Object;
        if (lastResource) {
            if (_btnHelp) {
                _rightBlock.removeChild(_btnHelp);
                _btnHelp.deleteIt();
                _btnHelp = null;
            }
            g.directServer.updateTrainPackGetHelp(_arrItems[_activeItemIndex].trainDbId,String(g.user.userSocialId), null);
            if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN) new XPStar(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2,_arrItems[_activeItemIndex].countXP * g.managerParty.coefficient);
            else new XPStar(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2,_arrItems[_activeItemIndex].countXP);
            obj = {};
            obj.id = DataMoney.SOFT_CURRENCY;
            if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN) obj.count = _arrItems[_activeItemIndex].countCoins * g.managerParty.coefficient;
            else obj.count = _arrItems[_activeItemIndex].countCoins;
            new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, obj);
            g.userInventory.addResource(_arrItems[_activeItemIndex].idFree, - _arrItems[_activeItemIndex].countFree);
            _arrItems[_activeItemIndex].fullItHelp();
        } else {
            if (g.userInventory.getCountResourceById(_arrItems[_activeItemIndex].idFree) >= _arrItems[_activeItemIndex].countFree) {
                if (g.userInventory.getCountResourceById(_arrItems[_activeItemIndex].idFree) >= _arrItems[_activeItemIndex].countFree && g.allData.getResourceById(_arrItems[_activeItemIndex].idFree).buildType == BuildType.PLANT
                        && !g.userInventory.checkLastResource(_arrItems[_activeItemIndex].idFree)) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, giftHelpClick, g.allData.getResourceById(_arrItems[_activeItemIndex].idFree), 'trainHelp');
                    return;
                }
                if (_btnHelp) {
                    _rightBlock.removeChild(_btnHelp);
                    _btnHelp.deleteIt();
                    _btnHelp = null;
                }
                g.directServer.updateTrainPackGetHelp(_arrItems[_activeItemIndex].trainDbId,String(g.user.userSocialId), null);
                if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN) new XPStar(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2,_arrItems[_activeItemIndex].countXP * g.managerParty.coefficient);
                else new XPStar(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2,_arrItems[_activeItemIndex].countXP);
                obj = {};
                obj.id = DataMoney.SOFT_CURRENCY;
                obj.count = _arrItems[_activeItemIndex].countCoins;
                if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN) obj.count = _arrItems[_activeItemIndex].countCoins * g.managerParty.coefficient;
                else obj.count = _arrItems[_activeItemIndex].countCoins;
                new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, obj);
                g.userInventory.addResource(_arrItems[_activeItemIndex].idFree, - _arrItems[_activeItemIndex].countFree);
                _arrItems[_activeItemIndex].fullItHelp();
            }  else if (_arrItems[_activeItemIndex].countFree > g.userInventory.getCountResourceById(_arrItems[_activeItemIndex].idFree)) {
                g.windowsManager.cashWindow = this;
                super.hideIt();
                obj = {};
                obj.id = _arrItems[_activeItemIndex].idFree;
                obj.count = _arrItems[_activeItemIndex].countFree;
                g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, giftHelpClick, 'trainHelp', obj);
            }
        }
    }

    private function wantHelpClick():void {
        if (_btnHelp) {
            _rightBlock.removeChild(_btnHelp);
            _btnHelp.deleteIt();
            _btnHelp = null;
        }
        _build.needHelp(true, _activeItemIndex);
        _arrItems[_activeItemIndex].onClickHelpMePls();
        g.directServer.updateUserTrainPackNeedHelp(_arrItems[_activeItemIndex].trainDbId, null);
    }

    private function onResourceLoad(lastResource:Boolean = false):void {
        if (_activeItemIndex == -1) return;
        if (!lastResource && _arrItems[_activeItemIndex].countFree == g.userInventory.getCountResourceById(_arrItems[_activeItemIndex].idFree)
                && g.allData.getResourceById(_arrItems[_activeItemIndex].idFree).buildType == BuildType.PLANT && !g.userInventory.checkLastResource(_arrItems[_activeItemIndex].idFree)) {
            g.windowsManager.cashWindow = this;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onResourceLoad, {id: _arrItems[_activeItemIndex].idFree}, 'market');
            return;
        }
        if (_arrItems[_activeItemIndex].canFull) {
            _arrItems[_activeItemIndex].fullIt();
        }
        updateItems();
        _btnLoad.visible = false;
        checkBtn();
    }

    private function updateItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].updateIt();
        }
    }

    private function onClickBuy():void {
        if (g.managerCutScenes.isCutScene) return;
        var ob:Object = {};
        ob.data = g.allData.getResourceById(_idFree);
        ob.count = _countFree - g.userInventory.getCountResourceById(_idFree);
        g.windowsManager.cashWindow = this;
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onResourceLoad, 'train', ob);
    }

    private function checkBtn():void {
        if (g.isAway) {
            _btnSend.visible = false;
            return;
        }
        _btnSend.visible = true;
        _btnSend.clickCallback = null;
        var i:int;
        _lock = 0;
        for (i = 0; i<_arrItems.length; i++) {
            if (!_isBigCount && i == 9 || !_isBigCount && i == 10 || !_isBigCount && i == 11){
                _lock++;
            } else if (_arrItems[i].isResourceLoaded) {
                _lock++;
            }
        }
        if (_lock >= _arrItems.length || _lock == 0 || !_isBigCount && _lock <= 3) {
            _btnSend.setEnabled = true;
        } else {
            _btnSend.setEnabled = false;
            return;
        }
        var b:Boolean;
        for (i = 0; i<_arrItems.length; i++) {
            b = false;
            if (_arrItems[i].isResourceLoaded) {
                b = true;
            }
        }
        if (b) (_build as Train).trainFull = true;

        _btnSend.setEnabled = true;
        _btnSend.clickCallback = fullTrain;
    }

    private function fullTrain(b:Boolean = false):void {
        if (g.managerCutScenes.isCutScene) return;
        if (!b) {
            if (_lock == 0 || !_isBigCount && _lock <= 3) {
                super.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_TRAIN_SEND, fullTrain, _build);
                return;
            }
        }
        (_build as Train).fullTrain(b);
        super.hideIt();
    }

    public function clearItems():void {
        for (var i:int = 0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        g.gameDispatcher.removeFromTimer(checkCounter);
        for (var i:int=0; i<_arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }

         if (_txt) {
             _source.removeChild(_txt);
             _txt.deleteIt();
             _txt = null;
         }
        if (_txtCounter) {
            _source.removeChild(_txtCounter);
            _txtCounter.deleteIt();
            _txtCounter = null;
        }
        if (_txtLoad) {
            _rightBlock.removeChild(_txtLoad);
            _txtLoad.deleteIt();
            _txtLoad = null;
        }
        if (_txtCostItem) {
            _rightBlock.removeChild(_txtCostItem);
            _txtCostItem.deleteIt();
            _txtCostItem = null;
        }
        if (_txtXpItem) {
            _rightBlock.removeChild(_txtXpItem);
            _txtXpItem.deleteIt();
            _txtXpItem = null;
        }
        if (_txtCostAll) {
            _rightBlock.removeChild(_txtCostAll);
            _txtCostAll.deleteIt();
            _txtCostAll = null;
        }
        if (_txtXpAll) {
            _rightBlock.removeChild(_txtXpAll);
            _txtXpAll.deleteIt();
            _txtXpAll = null;
        }
        if (_txtSend) {
            _btnSend.removeChild(_txtSend);
            _txtSend.deleteIt();
            _txtSend = null;
        }
        if (_txtPrise) {
            _rightBlock.removeChild(_txtPrise);
            _txtPrise.deleteIt();
            _txtPrise = null;
        }
        if (_txtLoad2) {
            _btnLoad.removeChild(_txtLoad2);
            _txtLoad2.deleteIt();
            _txtLoad2 = null;
        }
        if (_txtC) {
            _rightBlock.removeChild(_txtC);
            _txtC.deleteIt();
            _txtC = null;
        }
        if (_txtNeed) {
            _leftBlock.removeChild(_txtNeed);
            _txtNeed.deleteIt();
            _txtNeed = null;
        }
        _rightBlock.removeChild(_rightBlockBG);
        _rightBlockBG.deleteIt();
        _rightBlockBG = null;
        _rightBlock.removeChild(_rightBlockCarton);
        _rightBlockCarton.deleteIt();
        _rightBlockCarton = null;
        _rightBlock.removeChild(_rightBlockCarton2);
        _rightBlockCarton2.deleteIt();
        _rightBlockCarton2 = null;
        _leftBlock.removeChild(_leftBlockBG);
        _leftBlockBG.deleteIt();
        _leftBlockBG = null;
        _arrItems.length = 0;
        _build = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_btnSend);
        _btnSend.deleteIt();
        _btnSend = null;
        if (_btnLoad) _rightBlock.removeChild(_btnLoad);
        if (_btnLoad) _btnLoad.deleteIt();
        if (_btnLoad) _btnLoad = null;
//        _rightBlock.removeChild(_btnHelp);
//        _btnHelp.deleteIt();
//        _btnHelp = null;
        _rightBlock = null;
        _leftBlock = null;
        _source.removeChild(_birka);
        _birka.deleteIt();
        _birka = null;
        super.deleteIt();
    }

    public function getBoundsProperties(type:String):Object {
        var obj:Object = {};
        var p:Point = new Point();
        switch (type) {
            case 'firstItem':
                p.x = _arrItems[0].source.x;
                p.y = _arrItems[0].source.y;
                p = _source.localToGlobal(p);
                obj.x = p.x;
                obj.y = p.y;
                obj.width = _arrItems[0].source.width;
                obj.height = _arrItems[0].source.height;
                break;
            case 'loadBtn':
                p.x = _btnLoad.x - _btnLoad.width/2;
                p.y = _btnLoad.y - _btnLoad.height/2;
                p = _rightBlock.localToGlobal(p);
                obj.x = p.x;
                obj.y = p.y - 3;
                obj.width = _btnLoad.width;
                obj.height = _btnLoad.height;
                break;
            case 'priseCont':
                p.x = _txtCostItem.x + _txtCostItem.width;
                p.y = _txtCostItem.y + _txtCostItem.height/2;
                p = _rightBlock.localToGlobal(p);
                obj.x = p.x - 50;
                obj.y = p.y - 2;
                obj.width = 1;
                obj.height = 1;
                break;
            case 'mainLoadBtn':
                p.x = _btnSend.x - _btnSend.width/2 + 10;
                p.y = _btnSend.y - _btnSend.height/2;
                p = _source.localToGlobal(p);
                obj.x = p.x;
                obj.y = p.y - 5;
                obj.width = _btnSend.width;
                obj.height = _btnSend.height;
                break;
        }
        return obj;
    }

}
}
