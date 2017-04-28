/**
 * Created by user on 10/27/15.
 */
package ui.catPanel {
import data.BuildType;

import manager.ManagerFilters;
import manager.Vars;

import resourceItem.DropItem;

import social.SocialNetworkSwitch;

import starling.display.Image;

import temp.DropResourceVariaty;

import utils.CSprite;
import utils.CTextField;
import windows.WOComponents.HorizontalPlawka;
import windows.WindowsManager;

public class CatPanel {
    private var _source:CSprite;
    private var _txtCount:CTextField;
    private var _txtZero:CTextField;
    public var catBuing:Boolean;

    private var g:Vars = Vars.getInstance();

    public function CatPanel() {
        _source = new CSprite();
        _source.nameIt = 'catPanel';
        var pl:HorizontalPlawka = new HorizontalPlawka(null, g.allData.atlas['interfaceAtlas'].getTexture('xp_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('xp_back_left'), 100);
        _source.addChild(pl);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('circle'));
        im.x = -im.width/2;
        im.y = -10;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        im.x = -19;
        im.y = -5;
        _source.addChild(im);
        _txtCount = new CTextField(77, 40, '55');
        _txtCount.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR);
        _txtZero = new CTextField(40, 40, '23');
        _txtZero.setFormat(CTextField.BOLD24, 22, ManagerFilters.ORANGE_COLOR);
        _source.addChild(_txtCount);
        _source.addChild(_txtZero);

        onResize();
        g.cont.interfaceCont.addChild(_source);
        checkCat();
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
    }

    public function checkCat():void {
        if (g.managerCats.countFreeCats <= 0) {
            _txtZero.text = '0';
            _txtCount.text = String("/" + g.managerCats.curCountCats);
            _txtCount.x = 28;
            _txtZero.x = 55 - _txtCount.textBounds.width;
            _txtZero.visible = true;
        } else {
            _txtCount.text = String(g.managerCats.countFreeCats + "/" + g.managerCats.curCountCats);
            _txtZero.visible = false;
            _txtCount.x = 20;
        }
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 77;
        _source.x = g.managerResize.stageWidth - 108;
    }

    private function onHover():void {
        g.hint.showIt(String(g.managerLanguage.allTexts[482]) + g.managerCats.countFreeCats + String(g.managerLanguage.allTexts[483]) + g.managerCats.curCountCats,'xp',_source.x);
    }

    private function onOut():void {
        g.hint.hideIt();
    }

    public function visibleCatPanel(b:Boolean):void {
        if (b) _source.visible = true;
        else _source.visible = false;
    }

    private function onClick():void {
//        check();
//        if (g.user.isMegaTester) g.windowsManager.openWindow(WindowsManager.WO_ACHIEVEMENT,null);
//        g.directServer.getDataAchievement(null);
//        g.directServer.getUserParty(null);
//        var ob:Object = {};
//        ob.timeToStart = 1;
//        ob.timeToEnd = 1489556993;
//        ob.levelToStart = 5;
//        ob.idResource = 15;
//        ob.typeBuilding = BuildType.ORDER;
//        ob.coefficient = 5;
//        ob.typeParty = 4;
//        ob.name = 'Блинный путь';
//        ob.description = 'Накорми пришельцев и получи награду';
//        ob.idGift = [];
//        ob.idGift[0] = 2;
//        ob.idGift[1] = 1;
//        ob.idGift[2] = 212;
//        ob.idGift[3] = 229;
//        ob.idGift[4] = 225;
//        ob.countGift = [];
//        ob.countGift[0] = 10;
//        ob.countGift[1] = 5000;
//        ob.countGift[2] = 1;
//        ob.countGift[3] = 1;
//        ob.countGift[4] = 1;
//        ob.countToGift = [];
//        ob.countToGift[0] = 5;
//        ob.countToGift[1] = 15;
//        ob.countToGift[2] = 25;
//        ob.countToGift[3] = 35;
//        ob.countToGift[4] = 55;
//        ob.typeGift = [];
//        ob.typeGift[0] = 2;
//        ob.typeGift[1] = 1;
//        ob.typeGift[2] = 30;
//        ob.typeGift[3] = 4;
//        ob.typeGift[4] = 4;
//        g.managerParty.dataParty = ob;
//        g.userTimer.partyToEnd(1200);
//        g.managerParty.atlasLoad();
//        g.managerParty.eventOn = true;

//        if ((g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID)) {
//            if (g.user.userSocialId == '252433337505') {
//                g.user.level++;
//                g.windowsManager.openWindow(WindowsManager.WO_LEVEL_UP, null);
//            }
//        } else {
//            if (g.user.userSocialId == '14663166' || g.user.userSocialId == '201166703' || g.user.userSocialId == '168207096' || g.user.userSocialId == '202427318' || g.user.userSocialId == '191561520') {
//                g.user.level++;
//                g.windowsManager.openWindow(WindowsManager.WO_LEVEL_UP, null);
//            }
//        }
//        g.directServer.addUserXP(1,null);
//        var _dataBuild:Object = g.dataBuilding.objectBuilding[9];
//        g.windowsManager.openWindow(WindowsManager.POST_OPEN_FABRIC,null,_dataBuild);
//        g.windowsManager.openWindow(WindowsManager.POST_OPEN_CAVE,null);
    }

    private function check():void {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FABRICA);
//        var i:int = 0;
//        var j:int = 0;
//        var time:int = 0;
//        var ob:Object;
//        var arrResource:Array = g.userInventory.getResourceforTypetoOrder(BuildType.RESOURCE);
//        var resource:Boolean = false;
//        if (arrResource == null || arrResource.length <= 0) {
//            if (g.user.level == 5) time = 60;
//            else if (g.user.level == 6) time = 80;
//            else time = 120;
//            for (i = 0; i < arr.length; i++) {
//                if (arr[i].arrList.length > 0) {
//                    for (j = 0; j < arr[i].arrList.length; j++) {
//                        if (arr[i].arrList[j].resourceID != 21 && arr[i].arrList[j].resourceID != 25 && arr[i].arrList[j].resourceID != 27 && arr[i].arrList[j].resourceID != 29 && arr[i].arrList[j].leftTime <= time) {
//                            trace ('Ресурс готовится на фабрике но при этом подходит по времени для ордера');
//                            ob = {};
//                            ob.id = arr[i].arrList[j].resourceID;
//                            ob.count = 1;
//                            resource = true;
//                            break;
//                        }
//                    }
//                }
//            }
//            if (!resource) {
//                arr = [];
//                arr = g.townArea.getCityObjectsByType(BuildType.FARM);
//                var countAnimalWhoAccept:int = 0;
//                for (i = 0; i < arr.length; i++) {
//                    if (arr[i].arrAnimals.length > 0) {
//                        for (j = 0; j < arr[i].arrAnimals.length; j++) {
//                            if (arr[i].arrAnimals[j].state > 1 && arr[i].arrAnimals[j].timeToEnd <= time) {
//                                countAnimalWhoAccept ++;
//                            }
//                        }
//                        if (countAnimalWhoAccept > 1) {
//                            ob = {};
//                            ob.id = arr[i].arrAnimals[j].idResource;
//                            ob.count = countAnimalWhoAccept;
//                            trace ('Ресурс готовится на ферме но при этом подходит по времени для ордера');
//                            resource = true;
//                            break;
//                        }
//                    }
//                }
//            }
//        } else {
//            arrResource.sortOn("count", Array.DESCENDING | Array.NUMERIC);
//            resource = true;
//            ob ={};
//            ob.id = arrResource[0].id;
//            ob.count = arrResource[0].count;
//            trace ('Есть ресурсы на складе' + arrResource[0].count);
//        }
//        if (!resource) {
//            arrResource = [];
//            arrResource = g.userInventory.getResourceforTypetoOrder(BuildType.PLANT);
//            arr = [];
//            arr = g.townArea.getCityObjectsByType(BuildType.RIDGE);
//            if (arrResource == null || arrResource.length <= 0) {
//                for (i = 0; i < arr.length; i++) {
//                    if (arr[i].stateRidge >= 3) {
//                        ob = {};
//                        ob.id = arr[i].plant.dataPlant.id;
//                        ob.count = 1;
//                        if (arrResource != null || arrResource.length > 0) {
//                            for (j = 0; j < arrResource.length; j++) {
//                                if (arrResource[j].id == ob.id) {
//                                    arrResource[j].count ++;
//                                    resource = true;
//                                    break;
//                                }
//                            }
//                        }
//                        if (!resource) arrResource.push(ob);
//                    }
//                }
//                arrResource.sortOn("count", Array.DESCENDING | Array.NUMERIC);
//                ob = {};
//                ob.id = arrResource[0].id;
//                ob.count = arrResource[0].count;
//                trace('ищет самое большое количество ростений которые растут на грядке и отдает его');
//            } else {
//                arrResource.sortOn("count", Array.DESCENDING | Array.NUMERIC);
//                ob = {};
//                ob.id = arrResource[0].id;
//                ob.count = arrResource[0].count;
//                trace('ищет самое большое количество ростений в амбаре');
//            }
//        }
        trace ('asdsd');
    }
}
}
