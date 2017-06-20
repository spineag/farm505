/**
 * Created by user on 2/2/17.
 */
package manager {
import data.BuildType;
import data.DataMoney;

import flash.display.Bitmap;

import loaders.PBitmap;

import resourceItem.DropItem;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

import temp.DropResourceVariaty;

import ui.party.PartyPanel;

import utils.Utils;

import windows.WindowsManager;

public class ManagerPartyNew {
    public static const TYPE_EVENT:int = 1;
    public static const TYPE_RATING:int = 2;
    public static const TYPE_LAST:int = 3;

    private var g:Vars = Vars.getInstance();
    private var count:int = 0;
    public var dataParty:Object;
    public var dataPartyDontUse:Object;
    public var userParty:Object;
    public var eventOn:Boolean;
    public var arrBestPlayers:Array;
    public var playerPosition:int;

    public function ManagerPartyNew() {
        arrBestPlayers = [];
        eventOn = false;
    }

    private function dropPartyResourceWhenEnd():void {
        var obj:Object;
        obj = {};
        for (var i:int = 0; i < g.managerParty.userParty.tookGift.length; i++) {
            if (!g.managerParty.userParty.tookGift[i] && g.managerParty.userParty.countResource >= g.managerParty.dataParty.countToGift[i] ) {
                if (g.managerParty.dataParty.typeGift[i] == BuildType.DECOR_ANIMATION) {
                    obj.count = g.managerParty.dataParty.countGift[i];
                    obj.id =  g.managerParty.dataParty.idGift[i];
                    obj.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;
                } else if (g.managerParty.dataParty.typeGift[i] == BuildType.DECOR) {
                    obj.count = g.managerParty.dataParty.countGift[i];
                    obj.id =  g.managerParty.dataParty.idGift[i];
                    obj.type = DropResourceVariaty.DROP_TYPE_DECOR;
                } else {
                    if (g.managerParty.dataParty.idGift[i] == 1 && g.managerParty.dataParty.typeGift[i] == 1) {
                        obj.id = DataMoney.SOFT_CURRENCY;
                        obj.type = DropResourceVariaty.DROP_TYPE_MONEY;
                    }
                    else if (g.managerParty.dataParty.idGift[i] == 2 && g.managerParty.dataParty.typeGift[i] == 2) {
                        obj.id = DataMoney.HARD_CURRENCY;
                        obj.type = DropResourceVariaty.DROP_TYPE_MONEY;
                    }
                    else {
                        obj.id = g.managerParty.dataParty.idGift[i];
                        obj.type = DropResourceVariaty.DROP_TYPE_RESOURSE;
                    }
                    obj.count = g.managerParty.dataParty.countGift[i];
                }
                new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, obj);
            }
        }
    }

    public function endParty():void {
        var obj:Object;
        obj = {};
        for (var i:int = 0; i < userParty.tookGift.length; i++) {
            if (!userParty.tookGift[i] && userParty.countResource >= countToGift[i] ) {
                if (typeGift[i] == BuildType.DECOR_ANIMATION) {
                    obj.count = countGift[i];
                    obj.id =  idGift[i];
                    obj.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;
                } else if (typeGift[i] == BuildType.DECOR) {
                    obj.count = countGift[i];
                    obj.id =  g.managerParty.idGift[i];
                    obj.type = DropResourceVariaty.DROP_TYPE_DECOR;
                } else {
                    if (idGift[i] == 1 && typeGift[i] == 1) {
                        obj.id = DataMoney.SOFT_CURRENCY;
                        obj.type = DropResourceVariaty.DROP_TYPE_MONEY;
                    }
                    else if (idGift[i] == 2 && typeGift[i] == 2) {
                        obj.id = DataMoney.HARD_CURRENCY;
                        obj.type = DropResourceVariaty.DROP_TYPE_MONEY;
                    }
                    else {
                        obj.id = idGift[i];
                        obj.type = DropResourceVariaty.DROP_TYPE_RESOURSE;
                    }
                    obj.count = countGift[i];
                }
                new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, obj);
            }
        }
        if (playerPosition <= 5) {
            obj.count = 1;
            obj.id = dataParty.idDecorBest;
            if (g.allData.getBuildingById(dataParty.idDecorBest).buildType == BuildType.DECOR) obj.type = DropResourceVariaty.DROP_TYPE_DECOR;
            else obj.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;
            new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, obj);
        }
    }

    public function endPartyWindow():void {
        if (!g.allData.atlas['partyAtlas']) atlasLoad();
        else if ((g.userTimer.partyToEndTimer <= 0 && !eventOn) && (dataParty.typeParty == 3 || dataParty.typeParty == 4)) {
            if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
            if (g.managerParty.userParty.countResource >= dataParty.countToGift[0]) {
                g.windowsManager.openWindow(WindowsManager.WO_PARTY, null, TYPE_LAST);
                endParty();
                g.directServer.updateUserParty('1&1&1&1&1', userParty.countResource, 1, null);
            }
        }
    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    public function atlasLoad():void {
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas'), onLoad);
        g.load.loadXML(g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas'), onLoad);
    }

    private function createAtlases():void {
        if (g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')] && g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')]) {
            g.allData.atlas['partyAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')]);
            (g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')] as PBitmap).deleteIt();
            if (g.userTimer.partyToEndTimer > 0) g.partyPanel = new PartyPanel();
            if (!g.windowsManager.currentWindow && g.userTimer.partyToEndTimer > 0) {
                g.windowsManager.openWindow(WindowsManager.WO_PARTY, null);
            } else if ((g.userTimer.partyToEndTimer <= 0 && !eventOn) && (dataParty.typeParty == 3 || dataParty.typeParty == 4)) {
                if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
                if (g.managerParty.userParty.countResource >= dataParty.countToGift[0]) {
                    g.windowsManager.openWindow(WindowsManager.WO_PARTY, null, TYPE_LAST);
                    endParty();
                    g.directServer.updateUserParty('1&1&1&1&1', userParty.countResource, 1, null);
                }
            }

            delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')];
            delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')];
            g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas'));
            g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas'));
        }
    }

    public function get  timeToStart():int {return dataParty.timeToStart;}
    public function get  timeToEnd():int {return dataParty.timeToEnd;}
    public function get  levelToStart():int {return dataParty.levelToStart;}
    public function get  idResource():int {return dataParty.idResource;}
    public function get  typeBuilding():int {return dataParty.typeBuilding;}
    public function get  coefficient():int {return dataParty.coefficient;}
    public function get  typeParty():int {return dataParty.typeParty;}
    public function get  name():String {return dataParty.name;}
    public function get  description():String {return dataParty.description;}
    public function get  idGift():Array {return dataParty.idGift;}
    public function get  countGift():Array {return dataParty.countGift;}
    public function get  countToGift():Array {return dataParty.countToGift;}
    public function get  typeGift():Array {return dataParty.typeGift;}
    public function get  idDecorBest():int {return dataParty.idDecorBest;}
    public function get  filterOn():int {return dataParty.filterOn;}
}
}
