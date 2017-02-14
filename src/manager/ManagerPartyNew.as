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

import windows.WindowsManager;

public class ManagerPartyNew {
    private var g:Vars = Vars.getInstance();
    private var count:int = 0;
    public var dataParty:Object;
    public var userParty:Object;

    public function ManagerPartyNew() {
    }

    private function dropPartyResourceWhenEnd():void {
        var obj:Object;
        obj = {};
        for (var i:int = 0; i < g.managerParty.userParty.tookGift.length; i++) {
            if (!g.managerParty.userParty.tookGift[i] && g.managerParty.userParty.countResource >= g.managerParty.dataParty.countToGift[i] ) {
                if (g.managerParty.dataParty.typeGift[i] == BuildType.DECOR_ANIMATION) {
                    obj.count = 1;
                    obj.id =  g.managerParty.dataParty.idGift[i];
                    obj.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;
                } else if (g.managerParty.dataParty.typeGift[i] == BuildType.DECOR) {
                    obj.count = 1;
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
        var st:String = '0&0&0&0&0';
        g.directServer.updateUserParty(st, 0, 1, null);
        g.directServer.deletePartyInPapper(null);
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] && arr[i].plant && arr[i].plant.dataPlant.id == 168) {
                if (arr[i]) g.managerPlantRidge.removeCatFromRidge(arr[i].plant.dataPlant.id, arr[i]);
                if (arr[i]) g.managerPlantRidge.onCraft(arr[i].plant.idFromServer);
                if (arr[i]) arr[i].plant.clearIt();
            }
        }

        arr = [];
        arr = g.managerOrder.arrOrders;
        if (arr.length > 0) {
            for (i = 0; i < arr.length; i++) {
                for (var k:int = 0; k < arr[i].resourceIds.length; k++) {
                    if (arr[i] && arr[i].resourceIds[k] == 168) {
                        if (arr[i]) g.managerOrder.deleteOrderParty(arr[i].dbId, arr[i].placeNumber);
                        break;
                    }
                }
            }
        }
        arr = [];
        arr = g.managerBuyerNyashuk.arrNyashuk;
        if (arr.length > 0) {
            for (i = 0; i < arr.length; i++) {
                if (arr[i] &&  arr[i].dataNyashuk.resourceId == 168) {
                    g.directServer.updateUserPapperBuy(arr[i].dataNyashuk.buyerId, 0, 0, 0, 0, 0, 0);
                    g.managerBuyerNyashuk.onReleaseOrder(arr[i], false);
                    if (arr[i] && arr[i].dataNyashuk.buyerId == 1) g.userTimer.buyerNyashukBlue(1200);
                    else  g.userTimer.buyerNyashukRed(1200);
                    if (arr[i] )arr[i].dataNyashuk.timeToNext = int(new Date().getTime() / 1000);
                }
            }
        }

        arr = [];
        arr = g.managerBuyerNyashuk.arrNyashuk;
        if (arr.length > 0) {
            for (i = 0; i < arr.length; i++) {
                if (arr[i] &&  arr[i].dataNyashuk.resourceId == 168) {
                    g.directServer.updateUserPapperBuy(arr[i].dataNyashuk.buyerId, 0, 0, 0, 0, 0, 0);
                    g.managerBuyerNyashuk.onReleaseOrder(arr[i], false);
                    if (arr[i] && arr[i].dataNyashuk.buyerId == 1) g.userTimer.buyerNyashukBlue(1200);
                    else  g.userTimer.buyerNyashukRed(1200);
                    if (arr[i] )arr[i].dataNyashuk.timeToNext = int(new Date().getTime() / 1000);
                }
            }
        }

        g.userTimer.timerAtPapper = 0;
    }
    public function endPartyWindow():void {
        if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
        if (g.userInventory.getCountResourceById(168) > 0) g.windowsManager.openWindow(WindowsManager.WO_PARTY_CLOSE, null);
        else {
            dropPartyResourceWhenEnd();
            endParty();
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
        g.allData.atlas['partyAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')]);
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')] as PBitmap).deleteIt();
        g.party();
        delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')];
        delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')];
    }

}
}
