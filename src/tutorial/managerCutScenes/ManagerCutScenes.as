/**
 * Created by user on 4/28/16.
 */
package tutorial.managerCutScenes {
import build.WorldObject;
import build.decor.Decor;
import build.market.Market;
import build.paper.Paper;
import build.train.Train;
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;
import manager.Vars;
import mouse.ToolsModifier;
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import tutorial.AirTextBubble;
import tutorial.CutScene;
import particle.tuts.DustRectangle;
import utils.SimpleArrow;
import heroes.TutorialCat;
import windows.WindowsManager;
import windows.buyPlant.WOBuyPlant;
import windows.market.MarketItem;
import windows.market.WOMarket;
import windows.shop.WOShop;
import windows.train.WOTrain;

public class ManagerCutScenes {
    public static const CAT_BIG:String = 'big';         // use class CatScene
    public static const CAT_SMALL:String = 'small';     // use class TutorialCat
    public static const CAT_AIR:String = 'air';         // use class AirTextBubble

    public static const REASON_NEW_LEVEL:int = 1;  // use after getting new level
    public static const REASON_OPEN_TRAIN:int = 2;  // use if user open Train, cap
    public static const REASON_OPEN_WO_PLANT:int = 3;  // реализуем, когда юзер впервые открыл окно покупки растений, когда уже появилась вторая вкладка
    public static const REASON_ADD_TO_PAPPER:int = 4;  

    public static const ID_ACTION_SHOW_MARKET:int = 0;
    public static const ID_ACTION_SHOW_PAPPER:int = 1;
    public static const ID_ACTION_BUY_DECOR:int = 2;
    public static const ID_ACTION_TO_INVENTORY_DECOR:int = 3;
    public static const ID_ACTION_FROM_INVENTORY_DECOR:int = 4;
    public static const ID_ACTION_TRAIN_AVAILABLE:int = 5;
    public static const ID_ACTION_OPEN_TRAIN:int = 6;

    private var g:Vars = Vars.getInstance();
    private var _properties:Array;
    private var _curCutScenePropertie:Object;
    private var _cat:TutorialCat;
    private var _cutScene:CutScene;
    private var _airBubble:AirTextBubble;
    private var _arrow:SimpleArrow;
    private var _dustRectangle:DustRectangle;
    private var _black:Sprite;
    private var _cutSceneResourceIDs:Array;
    private var _cutSceneBuildings:Array;
    private var _cutSceneCallback:Function;
    private var _cutSceneStep:int;
    public var isCutScene:Boolean = false;
    private var _temp:*;

    public function ManagerCutScenes() {
        _properties = (new CutSceneProperties(this)).properties;
    }

    private function saveUserCutScenesData():void {
        if (g.managerQuest) g.managerQuest.hideQuestsIcons(false);
        g.directServer.updateUserCutScenesData();
    }

    public function checkAvailableCutScenes():void {
        if (g.isAway) return;
        var countActions:int = _properties.length;
        var l:int;
        if (g.user.cutScenes.length < countActions) {
            l = countActions - g.user.cutScenes.length;
            while (l>0) {
                g.user.cutScenes.push(0);
                l--;
            }
        }
        for (l=0; l<countActions; l++) {
            if (g.user.cutScenes[l] == 0) { // if == 1 - its mean, that cutScene was showed
                if (_properties[l].reason == REASON_NEW_LEVEL) {
                    if (_properties[l].level == g.user.level) {
                        _curCutScenePropertie = _properties[l];
                        checkTypeFunctions();
                        return;
                    } else {
                        continue;
                    }
                }
            }
        }
    }

    public function checkCutScene(reason:int):void {
        if (g.isAway) return;
        if (g.user.level < 5) return;
        var i:int;
        var countActions:int = _properties.length;
        var l:int;
        if (g.user.cutScenes.length < countActions) {
            l = countActions - g.user.cutScenes.length;
            while (l>0) {
                g.user.cutScenes.push(0);
                l--;
            }
        }
        switch (reason) {
            case REASON_NEW_LEVEL:
                for (i=0; i<_properties.length; i++) {
                    if (_properties[i].reason == REASON_NEW_LEVEL && g.user.level == _properties[i].level && g.user.cutScenes[_properties[i].id_action] == 0) {
                        _curCutScenePropertie = _properties[i];
                        checkTypeFunctions();
                        return;
                    }
                }
                break;
            case REASON_OPEN_TRAIN:
                for (i=0; i<_properties.length; i++) {
                    if (_properties[i].reason == REASON_OPEN_TRAIN && g.user.cutScenes[_properties[i].id_action] == 0) {
                        _curCutScenePropertie = _properties[i];
                        checkTypeFunctions();
                        return;
                    }
                }
                break;
        }
    }

    public function isType(id:int):Boolean {
        return id == _curCutScenePropertie.id_action;
    }
    
    public function checkCutSceneForAddToPapper(it:MarketItem):void {
        if (!_properties || !_properties[8] || _properties[8].level > g.user.level || g.user.cutScenes[8]) return;
        _curCutScenePropertie = _properties[8];
        var f:Function = function():void {
            releaseAddToPapper(it);
        };
        createDelay(.7, f);
    }

    private function checkTypeFunctions():void {
        g.toolsModifier.modifierType == ToolsModifier.NONE;
        try {
            switch (_curCutScenePropertie.id_action) {
                case ID_ACTION_SHOW_MARKET:
                    if (g.managerQuest) g.managerQuest.hideQuestsIcons(true);
                    releaseMarket();
                    break;
                case ID_ACTION_SHOW_PAPPER:
                    if (g.managerQuest) g.managerQuest.hideQuestsIcons(true);
                    releasePapper();
                    break;
                case ID_ACTION_BUY_DECOR:
                    if (g.managerQuest) g.managerQuest.hideQuestsIcons(true);
                    releaseDecor();
                    break;
                case ID_ACTION_TO_INVENTORY_DECOR:
                    if (g.managerQuest) g.managerQuest.hideQuestsIcons(true);
                    releaseToInventoryDecor();
                    break;
                case ID_ACTION_FROM_INVENTORY_DECOR:
                    releaseFromInventoryDecor();
                    break;
                case ID_ACTION_TRAIN_AVAILABLE:
                    if (g.managerQuest) g.managerQuest.hideQuestsIcons(true);
                    releaseAvailableTrain();
                    break;
                case ID_ACTION_OPEN_TRAIN:
                    if (g.managerQuest) g.managerQuest.hideQuestsIcons(true);
                    releaseOpenTrain();
                    break;
            }
        } catch (e:Error) {
            Cc.error('error during cutScene for _curCutScenePropertie.id_action=' + _curCutScenePropertie.id_action);
            endCutScene();
        }
    }

    private function releaseMarket():void {
        if (g.managerTips) g.managerTips.setUnvisible(true);
        _cutSceneStep = 1;
        isCutScene = true;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _cutSceneBuildings = g.townArea.getCityObjectsByType(BuildType.MARKET);
        addCatToPos(20, 22);
        g.managerCats.goCatToPoint(_cat, new Point(44, 0), market_1);
        g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 50, _cutSceneBuildings[0].source.y + 50, false, 3);
    }

    private function market_1():void {
        _cutSceneStep = 2;
        g.optionPanel.makeScaling(1);
        _cat.flipIt(false);
        _cat.showBubble(_curCutScenePropertie.text);
        (_cutSceneBuildings[0] as Market).showArrow();
        _airBubble = new AirTextBubble();
        _cutSceneCallback = market_2;
    }

    private function market_2():void {
        _cutSceneStep = 3;
        _cutSceneCallback = null;
        _cat.hideBubble();
        (_cutSceneBuildings[0] as Market).hideArrow();
        _airBubble.showIt(_curCutScenePropertie.text2, g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 150, Starling.current.nativeStage.stageHeight/2, market_3);
        _airBubble.showBtnParticles();
        _airBubble.showBtnArrow();
    }

    private function market_3():void {
        _cutSceneStep = 4;
        _airBubble.hideIt();
        _airBubble.deleteIt();
        _airBubble = null;
        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
        g.user.cutScenes[0] = 1;
        saveUserCutScenesData();
        checkCutScene(REASON_NEW_LEVEL);
    }

    private function releasePapper():void {
        if (g.managerTips) g.managerTips.setUnvisible(true);
        _cutSceneStep = 1;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        isCutScene = true;
        _cutSceneBuildings = g.townArea.getCityObjectsByType(BuildType.PAPER);
        if (_cat) {
            g.managerCats.goCatToPoint(_cat, new Point(41, 0), papper_1);
            g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 50, _cutSceneBuildings[0].source.y + 50, false, 1);
        } else {
            addCatToPos(20, 22);
            g.managerCats.goCatToPoint(_cat, new Point(41, 0), papper_1);
            g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 50, _cutSceneBuildings[0].source.y + 50, false, 3);
        }
    }

    private function papper_1():void {
        _cutSceneStep = 2;
        g.optionPanel.makeScaling(1);
        _cat.flipIt(false);
        _cat.showBubble(_curCutScenePropertie.text);
        (_cutSceneBuildings[0] as Paper).showArrow();
        _cutSceneCallback = papper_2;
    }

    private function papper_2():void {
        _cutSceneStep = 3;
        _cat.hideBubble();
        (_cutSceneBuildings[0] as Paper).hideArrow();
        papper_3();
    }

    private function papper_3():void {
        _cutSceneStep = 4;
        _cutSceneCallback = null;
        g.user.cutScenes[1] = 1;
        saveUserCutScenesData();
        if (_cat) {
            _cat.removeFromMap();
            _cat.deleteIt();
            _cat = null;
        }
        if (g.managerTips) g.managerTips.setUnvisible(false);
        isCutScene = false;
    }

    private function releaseDecor():void {
        _cutSceneStep = 1;
        Cc.ch('info', 'try cutScene: releaseDecor');
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        isCutScene = true;
        _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text);
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        if (!ob) {
            Cc.error('CutScene releaseDecor: no ob');
            endCutScene();
            return;
        }
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _cutSceneCallback = decor_1;
    }

    private function decor_1():void {
        _cutSceneStep = 2;
        g.bottomPanel.deleteArrow();
        _cutScene.hideIt(deleteCutScene);
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        _cutSceneCallback = decor_2;
    }

    private function decor_2():void {
        _cutSceneStep = 3;
        _cutSceneResourceIDs = [28];
        (g.windowsManager.currentWindow as WOShop).openOnResource(_cutSceneResourceIDs[0]);
        var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_cutSceneResourceIDs[0], true);
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        _cutSceneCallback = decor_3;
    }

    private function decor_3():void {
        _cutSceneStep = 4;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _cutSceneCallback = decor_4;
    }

    private function decor_4():void {
        _cutSceneStep = 5;
        _cutSceneCallback = null;
        g.user.cutScenes[2] = 1;
        saveUserCutScenesData();
        checkCutScene(REASON_NEW_LEVEL);
    }

    private function releaseToInventoryDecor():void {
        _cutSceneStep = 1;
        Cc.ch('info', 'try cutScene: releaseToInventoryDecor');
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        isCutScene = true;
        _cutSceneResourceIDs = [28];
        _cutSceneBuildings = g.townArea.getCityObjectsById(_cutSceneResourceIDs[0]);
        if (!_cutSceneBuildings.length) {
            Cc.error('no decor for CutScene on map');
            endCutScene();
            return;
        }
        _cutSceneBuildings.length = 1;
        g.bottomPanel.showToolsForCutScene();
        createDelay(.7, toInventory_1);
    }

    private function toInventory_1():void {
        _cutSceneStep = 2;
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text);
        var ob:Object = g.toolsPanel.getRepositoryBoxProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        g.toolsPanel.cutSceneCallback = toInventory_2;
    }

    private function toInventory_2():void {
        _cutSceneStep = 3;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _cutScene.hideIt(deleteCutScene);
        g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 150, _cutSceneBuildings[0].source.y - 20, false, .5);
        (_cutSceneBuildings[0] as Decor).showArrow();
        _cutSceneCallback = toInventory_3;
    }

    private function toInventory_3():void {
        _cutSceneStep = 4;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        (_cutSceneBuildings[0] as Decor).hideArrow();
        _cutSceneBuildings = [];
        g.toolsPanel.hideRepository();
        _cutSceneCallback = null;
        g.user.cutScenes[3] = 1;
        saveUserCutScenesData();
        createDelay(.7, toInventory_4);
    }

    private function toInventory_4():void {
        checkCutScene(REASON_NEW_LEVEL);
    }

    private function releaseFromInventoryDecor():void {
        _cutSceneStep = 1;
        Cc.ch('info', 'try cutScene: releaseFromInventoryDecor');
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _cutSceneResourceIDs = [28];
        if (!g.userInventory.getDecorInventory(_cutSceneResourceIDs[0])) {
            Cc.error('no such decor in inventory for cutScene');
            endCutScene();
            return;
        }
        isCutScene = true;
        if (g.toolsPanel.isShowed) {
            fromInventory_1();
        } else {
            g.bottomPanel.showToolsForCutScene();
            createDelay(.7, fromInventory_1);
        }
    }

    private function fromInventory_1():void {
        _cutSceneStep = 2;
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text);
        var ob:Object = g.toolsPanel.getRepositoryBoxProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        g.toolsPanel.cutSceneCallback = fromInventory_2;
    }

    private function fromInventory_2():void {
        _cutSceneStep = 3;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _cutScene.hideIt(deleteCutScene);
        createDelay(.5, fromInventory_3);
    }

    private function fromInventory_3():void {
        _cutSceneStep = 4;
        var ob:Object = g.toolsPanel.getRepositoryBoxFirstItemProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.7);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        _cutSceneCallback = fromInventory_4;
    }

    private function fromInventory_4():void {
        _cutSceneStep = 5;
        g.toolsPanel.hideRepository();
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _cutSceneCallback = fromInventory_5;
    }

    private function fromInventory_5():void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        _cutSceneBuildings = [];
        _cutSceneResourceIDs = [];
        _cutSceneCallback = null;
        g.user.cutScenes[4] = 1;
        saveUserCutScenesData();
        isCutScene = false;
    }

    private function releaseAvailableTrain():void {
        _cutSceneStep = 1;
        Cc.ch('info', 'try cutScene: releaseAvailableTrain');
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        g.hideAllHints();
        isCutScene = true;
        _cutSceneResourceIDs = [49];
        _cutSceneBuildings = g.townArea.getCityObjectsById(_cutSceneResourceIDs[0]);
        if (!_cutSceneBuildings.length) {
            Cc.error('no train build for CutScene');
            endCutScene();
            return;
        }
        g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 220, _cutSceneBuildings[0].source.y - 80, false, 1);
        createDelay(1, availableTrain_1);
    }

    private function availableTrain_1():void {
        _cutSceneStep = 2;
        g.optionPanel.makeScaling(1);
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text);
        (_cutSceneBuildings[0] as Train).showArrow();
        _cutSceneCallback = availableTrain_2;
    }

    private function availableTrain_2():void {
        _cutSceneCallback = null;
        _cutScene.hideIt(deleteCutScene);
        (_cutSceneBuildings[0] as Train).hideArrow();
        _cutSceneBuildings = [];
        g.user.cutScenes[5] = 1;
        saveUserCutScenesData();
        isCutScene = false;
    }

    private function releaseOpenTrain():void {
        _cutSceneStep = 1;
        Cc.ch('info', 'try cutScene: releaseOpenTrain');
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        g.hideAllHints();
        isCutScene = true;
        _cutSceneResourceIDs = [49];
        _cutSceneBuildings = g.townArea.getCityObjectsById(_cutSceneResourceIDs[0]);
        if (!_cutSceneBuildings.length) {
            Cc.error('no train build for CutScene');
            endCutScene();
            return;
        }
        g.user.cutScenes[6] = 1;
        saveUserCutScenesData();
        if (g.windowsManager.currentWindow != null) {
            if (g.windowsManager.currentWindow.windowType != WindowsManager.WO_TRAIN) {
                g.windowsManager.closeAllWindows();
            } else {
                openTrain_2();
                return;
            }
        }
        g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 220, _cutSceneBuildings[0].source.y - 80, false, .7);
        createDelay(.7, openTrain_1);
    }

    private function openTrain_1():void {
        _cutSceneStep = 2;
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text);
        (_cutSceneBuildings[0] as Train).showArrow();
        _cutSceneCallback = openTrain_2;
    }

    private function openTrain_2():void {
        _cutSceneStep = 3;
        (_cutSceneBuildings[0] as Train).hideArrow();
        _cutSceneBuildings = [];
        _cutSceneCallback = null;
        if (_cutScene) _cutScene.hideIt(deleteCutScene);
        createDelay(.5, openTrain_2a);
    }

    private function openTrain_2a():void {
        _cutSceneStep = 4;
        _airBubble = new AirTextBubble();
        _airBubble.showIt(_curCutScenePropertie.text2, g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 150, Starling.current.nativeStage.stageHeight/2, openTrain_3);
        _airBubble.showBtnParticles();
        var ob:Object = (g.windowsManager.currentWindow as WOTrain).getBoundsProperties('firstItem');
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
    }

    private function openTrain_3():void {
        _cutSceneStep = 5;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_airBubble) {
            _airBubble.hideIt();
            _airBubble.deleteIt();
            _airBubble = null;
        }

        _airBubble = new AirTextBubble();
        _airBubble.showIt(_curCutScenePropertie.text3, g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 300, Starling.current.nativeStage.stageHeight/2 - 100, openTrain_4);
        _airBubble.showBtnParticles();
        var ob:Object = (g.windowsManager.currentWindow as WOTrain).getBoundsProperties('loadBtn');
        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, g.cont.popupCont);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(ob.x + ob.width, ob.y + ob.height/2);
    }

    private function openTrain_4():void {
        _cutSceneStep = 6;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_airBubble) {
            _airBubble.hideIt();
            _airBubble.deleteIt();
            _airBubble = null;
        }

        _airBubble = new AirTextBubble();
        _airBubble.showIt(_curCutScenePropertie.text4, g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 330, Starling.current.nativeStage.stageHeight/2 - 200, openTrain_5);
        _airBubble.showBtnParticles();
        var ob:Object = (g.windowsManager.currentWindow as WOTrain).getBoundsProperties('priseCont');
        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, g.cont.popupCont);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(ob.x + ob.width, ob.y + ob.height/2);
    }

    private function openTrain_5():void {
        _cutSceneStep = 7;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_airBubble) {
            _airBubble.hideIt();
            _airBubble.deleteIt();
            _airBubble = null;
        }

        _airBubble = new AirTextBubble();
        _airBubble.showIt(_curCutScenePropertie.text5, g.cont.popupCont, Starling.current.nativeStage.stageWidth/2 - 300, Starling.current.nativeStage.stageHeight/2 + 100, openTrain_6);
        _airBubble.showBtnParticles();
        var ob:Object = (g.windowsManager.currentWindow as WOTrain).getBoundsProperties('mainLoadBtn');
        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, g.cont.popupCont);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(ob.x + ob.width, ob.y + ob.height/2);
    }

    private function openTrain_6():void {
        _cutSceneStep = 8;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_airBubble) {
            _airBubble.hideIt();
            _airBubble.deleteIt();
            _airBubble = null;
        }
        g.windowsManager.hideWindow(WindowsManager.WO_TRAIN);

        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curCutScenePropertie.text6, 'Далее', openTrain_7);
        var ob:Object = g.couponePanel.getContPropertie();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, g.cont.popupCont);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(ob.x + ob.width, ob.y + ob.height/2);
    }

    private function openTrain_7():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _cutScene.hideIt(deleteCutScene);
        isCutScene = false;
    }

    public function isWOPlantCutSceneAvailable():void {
        if (!_properties || !_properties[7] || _properties[7].level > g.user.level || g.user.cutScenes[7]) return;
        _curCutScenePropertie = _properties[7];
        createDelay(.7, releaseWOPlant);
    }


    private function releaseWOPlant():void {
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_BUY_PLANT) {
            isCutScene = true;
            var ob:Object = (g.windowsManager.currentWindow as WOBuyPlant).getBoundsProperties('secondTab');
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.5);
            _arrow.animateAtPosition(ob.x, ob.y);
            _airBubble = new AirTextBubble();
            _airBubble.showIt(_curCutScenePropertie.text, g.cont.popupCont, ob.x + 70, ob.y);
            _cutSceneCallback = onWoPlant;
        } else {
            isCutScene = false;
        }
    }

    private function onWoPlant():void {
        _cutSceneCallback = null;
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_airBubble) {
            _airBubble.hideIt();
            _airBubble.deleteIt();
            _airBubble = null;
        }
        g.user.cutScenes[7] = 1;
        isCutScene = false;
        saveUserCutScenesData();
    }

    private function releaseAddToPapper(it:MarketItem):void {
        _cutSceneStep = 1;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_MARKET) {
            _temp = it;
            isCutScene = true;
            var ob:Object = it.getBoundsProperties('papperIcon');
            _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, g.cont.popupCont);
            _arrow.scaleIt(.5);
            _arrow.animateAtPosition(ob.x + 30, ob.y + ob.height/2);
            _airBubble = new AirTextBubble();
            _airBubble.showIt(_curCutScenePropertie.text, g.cont.popupCont, ob.x + 10, ob.y + 70);
            _cutSceneCallback = onAddToPapper;
        } else {
            isCutScene = false;
        }
    }

    private function onAddToPapper():void {
        _cutSceneCallback = null;
        _cutSceneStep = 2;
        _temp = null;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_airBubble) {
            _airBubble.hideIt();
            _airBubble.deleteIt();
            _airBubble = null;
        }
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_MARKET) {
            isCutScene = true;
//            var ob:Object = (g.windowsManager.currentWindow as WOMarket).getTimerProperties();
//            _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
//            _arrow.scaleIt(.5);
//            _arrow.animateAtPosition(ob.x -10, ob.y + ob.height/2);
            _airBubble = new AirTextBubble();
            _airBubble.showIt(_curCutScenePropertie.text2, g.cont.popupCont, Starling.current.nativeStage.stageWidth/2-100, Starling.current.nativeStage.stageHeight/2-50, onAddToPapper2);
        }
    }
    
    private function onAddToPapper2():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_airBubble) {
            _airBubble.hideIt();
            _airBubble.deleteIt();
            _airBubble = null;
        }
        isCutScene = false;
        g.user.cutScenes[8] = 1;
        saveUserCutScenesData();
    }

    public function get curCutSceneProperties():Object {
        return _curCutScenePropertie;
    }


    public function isCutSceneResource(id:int):Boolean {
        return _cutSceneResourceIDs.indexOf(id) > -1;
    }

    public function checkCutSceneCallback():void {
        if (_cutSceneCallback != null) {
            _cutSceneCallback.apply();
        }
    }

    private function addCatToPos(_x:int, _y:int):void {
        if (!_cat) _cat = new TutorialCat();
        _cat.setPosition(new Point(_x, _y));
        _cat.addToMap();
    }

    private function playCatIdle():void {
        if (_cat) _cat.playDirectLabel('idle', false, null);
    }

    private function addBlack():void {
        if (!_black) {
            var q:Quad = new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Color.BLACK);
            _black = new Sprite();
            _black.addChild(q);
            _black.alpha = .3;
            g.cont.popupCont.addChildAt(_black, 0);
        }
    }

    private function removeBlack():void {
        if (_black) {
            if (g.cont.popupCont.contains(_black)) g.cont.popupCont.removeChild(_black);
            _black.dispose();
            _black = null;
        }
    }

    private function deleteCutScene():void {
        if (_cutScene) {
            _cutScene.deleteIt();
            _cutScene = null;
        }
    }

    public function isCutSceneBuilding(wo:WorldObject):Boolean {
        if(_cutSceneBuildings)  return _cutSceneBuildings.indexOf(wo) > -1;
        else return false;
    }

    private function createDelay(delay:Number, f:Function):void {
        var func:Function = function():void {
            timer.removeEventListener(TimerEvent.TIMER, func);
            timer = null;
            if (f != null) {
                f.apply();
            }
        };
        var timer:Timer = new Timer(delay*1000, 1);
        timer.addEventListener(TimerEvent.TIMER, func);
        timer.start();
    }

    public function onResize():void {
        try {
            if (!isCutScene || !_curCutScenePropertie) return;
            // add try catch
            if (_curCutScenePropertie.reason == REASON_ADD_TO_PAPPER) {
                if (_cutSceneStep == 1) {
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    if (_airBubble) {
                        _airBubble.hideIt();
                        _airBubble.deleteIt();
                        _airBubble = null;
                    }
                    if (_temp && _temp is MarketItem) {
                        releaseAddToPapper(_temp as MarketItem);
                    } else {
                        isCutScene = false;
                    }
                } else if (_cutSceneStep == 2) {
                    if (_arrow) {
                        _arrow.deleteIt();
                        _arrow = null;
                    }
                    if (_airBubble) {
                        _airBubble.hideIt();
                        _airBubble.deleteIt();
                        _airBubble = null;
                    }
                    onAddToPapper();
                }
            } else if (_curCutScenePropertie.reason == REASON_OPEN_WO_PLANT) {
                if (_arrow) {
                    _arrow.deleteIt();
                    _arrow = null;
                }
                if (_airBubble) {
                    _airBubble.hideIt();
                    _airBubble.deleteIt();
                    _airBubble = null;
                }
                releaseWOPlant();
            } else {
                var ob:Object;
                switch (_curCutScenePropertie.id_action) {
                    case ID_ACTION_SHOW_MARKET:
                        if (_cutSceneStep == 1 || _cutSceneStep == 2) {
                            g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 50, _cutSceneBuildings[0].source.y + 50);
                        } else if (_cutSceneStep == 3) {
                            if (_airBubble) {
                                _airBubble.hideIt();
                                _airBubble.deleteIt();
                                _airBubble = null;
                            }
                        }
                        market_2();
                        break;
                    case ID_ACTION_SHOW_PAPPER:
                        if (_cutSceneBuildings[0]) g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 50, _cutSceneBuildings[0].source.y + 50);
                        break;
                    case ID_ACTION_BUY_DECOR:
                        if (_cutSceneStep == 1) {
                            ob = g.bottomPanel.getShopButtonProperties();
                            if (!ob) {
                                Cc.error('CutScene releaseDecor: no ob');
                                endCutScene();
                                return;
                            }
                            if (_dustRectangle) {
                                _dustRectangle.deleteIt();
                                _dustRectangle = null;
                            }
                            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                        } else if (_cutSceneStep == 3) {
                            if (_arrow) {
                                _arrow.deleteIt();
                                _arrow = null;
                            }
                            if (_dustRectangle) {
                                _dustRectangle.deleteIt();
                                _dustRectangle = null;
                            }
                            ob = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_cutSceneResourceIDs[0], true);
                            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                            _arrow.scaleIt(.7);
                            _arrow.animateAtPosition(ob.x + ob.width / 2, ob.y);
                        }
                        break;
                    case ID_ACTION_TO_INVENTORY_DECOR:
                        if (_cutSceneStep == 2) {
                            if (_arrow) {
                                _arrow.deleteIt();
                                _arrow = null;
                            }
                            if (_dustRectangle) {
                                _dustRectangle.deleteIt();
                                _dustRectangle = null;
                            }
                            ob = g.toolsPanel.getRepositoryBoxProperties();
                            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                            _arrow.scaleIt(.7);
                            _arrow.animateAtPosition(ob.x + ob.width / 2, ob.y);
                        } else if (_cutSceneStep == 3) {
                            g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 150, _cutSceneBuildings[0].source.y - 20);
                        }
                        break;
                    case ID_ACTION_FROM_INVENTORY_DECOR:
                        if (_cutSceneStep == 2) {
                            if (_arrow) {
                                _arrow.deleteIt();
                                _arrow = null;
                            }
                            if (_dustRectangle) {
                                _dustRectangle.deleteIt();
                                _dustRectangle = null;
                            }
                            ob = g.toolsPanel.getRepositoryBoxProperties();
                            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                            _arrow.scaleIt(.7);
                            _arrow.animateAtPosition(ob.x + ob.width / 2, ob.y);
                        } else if (_cutSceneStep == 4) {
                            if (_arrow) {
                                _arrow.deleteIt();
                                _arrow = null;
                            }
                            if (_dustRectangle) {
                                _dustRectangle.deleteIt();
                                _dustRectangle = null;
                            }
                            ob = g.toolsPanel.getRepositoryBoxFirstItemProperties();
                            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
                            _arrow.scaleIt(.7);
                            _arrow.animateAtPosition(ob.x + ob.width / 2, ob.y);
                        }
                        break;
                    case ID_ACTION_TRAIN_AVAILABLE:
                        g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 220, _cutSceneBuildings[0].source.y - 80);
                        break;
                    case ID_ACTION_OPEN_TRAIN:
                        g.cont.moveCenterToXY(_cutSceneBuildings[0].source.x - 220, _cutSceneBuildings[0].source.y - 80);
                        if (_cutSceneStep == 4) {
                            if (_arrow) {
                                _arrow.deleteIt();
                                _arrow = null;
                            }
                            if (_airBubble) {
                                _airBubble.hideIt();
                                _airBubble.deleteIt();
                                _airBubble = null;
                            }
                            openTrain_2a();
                        } else if (_cutSceneStep == 5) {
                            openTrain_3();
                        } else if (_cutSceneStep == 6) {
                            openTrain_4();
                        } else if (_cutSceneStep == 7) {
                            openTrain_5();
                        } else if (_cutSceneStep == 8) {
                            openTrain_6();
                        }
                        break;
                }
            }
        } catch (e:Error) {
            endCutScene();
            Cc.error('error during cutScene resize');
        }
    }

    private function endCutScene():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_airBubble) {
            _airBubble.hideIt();
            _airBubble.deleteIt();
            _airBubble = null;
        }
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        deleteCutScene();
        removeBlack();
        if (_cat) {
            _cat.removeFromMap();
            _cat.deleteIt();
            _cat = null;
        }
        isCutScene = false;
        if (g.managerTips) g.managerTips.setUnvisible(false);
    }

}
}
