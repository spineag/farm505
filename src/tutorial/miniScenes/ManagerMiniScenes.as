/**
 * Created by user on 12/5/16.
 */
package tutorial.miniScenes {
import build.WorldObject;
import build.market.Market;
import build.orders.Order;
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.Vars;
import particle.tuts.DustRectangle;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import tutorial.AirTextBubble;
import tutorial.CutScene;
import utils.SimpleArrow;
import utils.Utils;

import windows.WindowsManager;
import windows.market.WOMarket;
import windows.orderWindow.WOOrder;
import windows.shop.WOShop;

public class ManagerMiniScenes {
    public static const REASON_NEW_LEVEL:int = 1;  // use after getting new level
    public static const AFTER_PREV_MINISCENE:int = 2;  // use after ending prev miniSCene
    public static const ON_GO_NEIGHBOR:int = 3;
    public static const GO_NEIGHBOR:int = 4;
    public static const BUY_BUILD:int = 5;

    private var g:Vars = Vars.getInstance();
    private var _properties:Array;
    private var _curMiniScenePropertie:Object;
    private var _cutScene:CutScene;
    private var _airBubble:AirTextBubble;
    private var _arrow:SimpleArrow;
    private var _dustRectangle:DustRectangle;
    private var _black:Sprite;
    private var _miniSceneResourceIDs:Array;
    private var _miniSceneBuildings:Array;
    private var _miniSceneCallback:Function;
    public var isMiniScene:Boolean = false;
    private var _onShowWindowCallback:Function;
    private var _onHideWindowCallback:Function;

    public function ManagerMiniScenes() {
        _properties = (new MiniSceneProps()).properties;
        _miniSceneBuildings = [];
        _miniSceneResourceIDs = [];
    }

    public function isReason(reason:int):Boolean {
        if (_curMiniScenePropertie) {
            return _curMiniScenePropertie.reason == reason;
        } else return false;
    }

    public function deleteArrowAndDust():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function checkMiniCutSceneCallbackOnShowWindow():void {
        if (_onShowWindowCallback != null) {
            _onShowWindowCallback.apply();
        }
    }

    public function checkMiniCutSceneCallbackOnHideWindow():void {
        if (_onHideWindowCallback != null) {
            _onHideWindowCallback.apply();
        }
    }

    public function isMiniSceneResource(id:int):Boolean {
        return _miniSceneResourceIDs.indexOf(id) > -1;
    }

    public function checkMiniSceneCallback():void {
        if (_miniSceneCallback != null) {
            _miniSceneCallback.apply();
        }
    }

    public function isMiniSceneBuilding(wo:WorldObject):Boolean {
        if(_miniSceneBuildings.length)  return _miniSceneBuildings.indexOf(wo) > -1;
        else return false;
    }

    private function addBlack():void {
        if (!_black) {
            var q:Quad = new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK);
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

    private function saveUserMiniScenesData():void {
        g.directServer.updateUserMiniScenesData();
    }

    public function updateMiniScenesLengthOnGameStart():void {
        var countActions:int = _properties.length;
        var l:int;
        var needUpdate:Boolean = false;
        if (g.user.miniScenes.length < countActions) {
            l = countActions - g.user.miniScenes.length;
            while (l>0) {
                needUpdate = true;
                g.user.miniScenes.push(0);
                l--;
            }
        }
        checkForAvailableLevels(needUpdate);
    }

    private function checkForAvailableLevels(needUpdate:Boolean = false):void {
        var countActions:int = _properties.length;
        var l:int;
        for (l=0; l<countActions; l++) {
            if (_properties[l].level < g.user.level) {
                g.user.miniScenes[l] = 1;
                needUpdate = true;
            }
        }
        if (needUpdate) saveUserMiniScenesData();
    }

    public function checkAvailableMiniScenesOnNewLevel():void {
        if (!g.useNewTuts) return;
        if (g.user.level > 3) {
            checkForAvailableLevels();
            if (isMiniScene) {
                isMiniScene = false;
                removeBlack();
                if (_cutScene) _cutScene.hideIt(deleteCutScene);
                deleteArrowAndDust();
                if (_airBubble) _airBubble.hideIt();
                _airBubble = null;
                _miniSceneBuildings = [];
                _miniSceneCallback = null;
                _miniSceneResourceIDs = [];
                _onHideWindowCallback = null;
                _onHideWindowCallback = null;
            }
        } else if (g.user.level == 3) {
            checkForAvailableLevels();
            if (g.isAway) return;
            var countActions:int = _properties.length;
            var l:int;
            for (l = 0; l < countActions; l++) {
                if (g.user.miniScenes[l] == 0) { // if == 1 - its mean, that miniScene was showed
                    if (_properties[l].level == g.user.level) {
                        _curMiniScenePropertie = _properties[l];
                        forReleaseMini();
                        return;
                    }
                }
            }
        }
    }

    private function forReleaseMini():void {
        if (!g.useNewTuts) return;
        if (!_curMiniScenePropertie) return;
        switch (_curMiniScenePropertie.id) {
            case 1: openOrderBuilding(); break;
            case 2: firstOrderBuyer(); break;
            case 3: buildBulo4na(); break;
            case 4: letsGoToNeighbor(); break;
//            case 5: atNeighbor(); break;
//            case 6: atNeighborBuyInstrument(); break;
//            default: Cc.error('unknown id for miniScene');
        }
    }

    private function openOrderBuilding():void {
        if (g.isAway) return;
        if (!g.allData.factory['tutorialCatBig']) {
            g.loadAnimation.load('animations_json/x1/cat_tutorial_big', 'tutorialCatBig', openOrderBuilding);
            return;
        }
        isMiniScene = true;
        _miniSceneBuildings = g.townArea.getCityObjectsByType(BuildType.ORDER);
        
        
        
        
        
        
        
        if ((_miniSceneBuildings[0] as Order).stateBuild == WorldObject.STATE_UNACTIVE) {
            if (!_cutScene) _cutScene = new CutScene();
            addBlack();
            _cutScene.showIt(_curMiniScenePropertie.text, 'Далее', order_1);
        } else {
            order_10();
        }
    }

    private function order_1():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        g.cont.moveCenterToPos(_miniSceneBuildings[0].posX - 3, _miniSceneBuildings[0].posY - 3);
        _miniSceneCallback = order_10;
    }

    private function order_10():void {
        _miniSceneCallback = null;
        g.managerOrder.addOrderForMiniScenes(firstOrderBuyer);
        g.user.miniScenes[0] = 1;
        saveUserMiniScenesData();
        isMiniScene = false;
    }

    private function firstOrderBuyer():void {
        if (!g.allData.factory['tutorialCatBig']) {
            g.loadAnimation.load('animations_json/x1/cat_tutorial_big', 'tutorialCatBig', firstOrderBuyer);
            return;
        }
        if (!g.managerOrder.countOrders) {
            g.managerOrder.addOrderForMiniScenes(firstOrderBuyer);
            return;
        }
        isMiniScene = true;
        _curMiniScenePropertie = _properties[1];
        if (!_miniSceneBuildings.length) {
            _miniSceneBuildings = g.townArea.getCityObjectsByType(BuildType.ORDER);
        }
        g.cont.moveCenterToPos(_miniSceneBuildings[0].posX - 3, _miniSceneBuildings[0].posY - 3);
        (_miniSceneBuildings[0] as Order).showArrow();
        if (!_cutScene) _cutScene = new CutScene();
        addBlack();
        _cutScene.showIt(_curMiniScenePropertie.text, 'Далее', buyer_1);
    }

    private function buyer_1():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        _miniSceneCallback = buyer_2;
    }

    private function buyer_2():void {
        _miniSceneCallback = null;
        _onShowWindowCallback = buyer_3;
    }

    private function buyer_3():void {
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
            (g.windowsManager.currentWindow as WOOrder).setTextForCustomer('Здравствуйте! Хочу купить несколько яиц.');
            var ob:Object = (g.windowsManager.currentWindow as WOOrder).getSellBtnProperties();
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height - 20, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
            _arrow.scaleIt(.5);
            _arrow.animateAtPosition(ob.x, ob.y + 25);
            _miniSceneCallback = buyer_4;
        } else {
            Cc.error('wo_order is not opened');
        }
    }

    private function buyer_4():void {
        _miniSceneCallback = null;
        deleteArrowAndDust();
        _onHideWindowCallback = buyer_5;
    }

    private function buyer_5():void {
        _onHideWindowCallback = null;
        buyer_15();
    }

    private function buyer_15():void {
        isMiniScene = false;
        g.user.miniScenes[1] = 1;
        saveUserMiniScenesData();
        _curMiniScenePropertie = _properties[2];
        buildBulo4na();
    }

    private function buildBulo4na():void {
        if (!g.allData.factory['tutorialCatBig']) {
            g.loadAnimation.load('animations_json/x1/cat_tutorial_big', 'tutorialCatBig', buildBulo4na);
            return;
        }
        isMiniScene = true;
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curMiniScenePropertie.text, 'Далее', bulo4na_1);
        addBlack();
    }

    private function bulo4na_1():void {
        removeBlack();
        _cutScene.hideIt(deleteCutScene);
        _miniSceneResourceIDs = [1];
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _onShowWindowCallback = bulo4na_2;
    }

    private function bulo4na_2():void {
        deleteArrowAndDust();
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_miniSceneResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);   // change for arrow at shopItem
        } else {
            Cc.error('miniScene:: wo_SHOP is not opened');
        }
    }

    public function onPasteFabrica(buildId:int):void {
        deleteArrowAndDust();
        if (!g.useNewTuts) return;
        if (_miniSceneResourceIDs.indexOf(buildId) == -1) return;
        _miniSceneResourceIDs = [];
        if (g.user.miniScenes[2] == 0) {
            g.user.miniScenes[2] = 1;
            saveUserMiniScenesData();
            _curMiniScenePropertie = _properties[3];
            isMiniScene = false;
            letsGoToNeighbor();
        }
    }

    private function letsGoToNeighbor():void {
        if (!g.allData.factory['tutorialCatBig']) {
            g.loadAnimation.load('animations_json/x1/cat_tutorial_big', 'tutorialCatBig', letsGoToNeighbor);
            return;
        }
        isMiniScene = true;
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curMiniScenePropertie.text, 'Далее', letGo_1);
        addBlack();
    }

    private function letGo_1():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        var ob:Object = g.friendPanel.getNeighborItemProperties();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(ob.x + ob.width/2, ob.y);
        g.user.miniScenes[3] = 1;
        _miniSceneCallback = letGo_2;
        saveUserMiniScenesData();
    }

    private function letGo_2():void {
        deleteArrowAndDust();
        isMiniScene = false;
    }

//    g.directServer.getUserNeighborMarket(null);    ?????

    public function onGoAwayToNeighbor():void {
        if (g.user.miniScenes[4] == 0 && g.isAway) atNeighbor();
    }

    private function atNeighbor():void {
        if (!g.useNewTuts) return;
        if (!g.allData.factory['tutorialCatBig']) {
            g.loadAnimation.load('animations_json/x1/cat_tutorial_big', 'tutorialCatBig', atNeighbor);
            return;
        }
        isMiniScene = true;
        if (g.user.miniScenes[4] == 0) {
            _curMiniScenePropertie = _properties[4];
            if (!_cutScene) _cutScene = new CutScene();
            _cutScene.showIt(_curMiniScenePropertie.text, 'Далее', atN_1);
            addBlack();
        }
    }

    private function atN_1():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        _miniSceneBuildings = g.townArea.getAwayCityObjectsById(44);
        (_miniSceneBuildings[0] as WorldObject).showArrow();
        g.cont.moveCenterToXY((_miniSceneBuildings[0] as Market).source.x-100, (_miniSceneBuildings[0] as Market).source.y, false, 1.5);
        g.user.miniScenes[4] = 1;
        isMiniScene = false;
        saveUserMiniScenesData();
    }

    public function atNeighborBuyInstrument():void {
        if (!g.isAway) return;
        if (!g.useNewTuts) return;
        if (!g.allData.factory['tutorialCatBig']) {
            g.loadAnimation.load('animations_json/x1/cat_tutorial_big', 'tutorialCatBig', atNeighborBuyInstrument);
            return;
        }
        if (g.user.miniScenes[5] == 0) {
            isMiniScene = true;
            _curMiniScenePropertie = _properties[5];
            if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_MARKET) {
                _airBubble = new AirTextBubble();
                _airBubble.showIt(_curMiniScenePropertie.text, g.cont.popupCont, g.managerResize.stageWidth/2 - 150, g.managerResize.stageHeight/2);
                var ob:Object = (g.windowsManager.currentWindow as WOMarket).getItemProperties(1);
                _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
                _arrow.scaleIt(.5);
                _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height);
                _miniSceneCallback = ins_1;
            } else {
                Cc.error('wo_market is not opened');
            }
        }
    }

    public function ins_1():void {
        if (_airBubble) _airBubble.hideIt();
        _airBubble = null;
        g.user.miniScenes[5] = 1;
        isMiniScene = false;
        saveUserMiniScenesData();
       deleteArrowAndDust();
        isMiniScene = false;
        _miniSceneCallback = null;
    }
}
}
