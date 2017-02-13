/**
 * Created by user on 1/30/17.
 */
package ui.party {
import data.BuildType;

import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;

import utils.CSprite;
import utils.CTextField;
import utils.TimeUtils;

import windows.WindowsManager;

public class PartyPanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();
    private var _txtData:CTextField;

    public function PartyPanel() {
        _source = new CSprite();
        var im:Image = new Image(g.allData.atlas['partyAtlas'].getTexture('valentine_pink_icon'));
        _source.addChild(im);

        _txtData= new CTextField(100,60,'');
        _txtData.setFormat(CTextField.BOLD18, 18, 0xd30102);
        _source.addChild(_txtData);
        _txtData.y = 55;

        g.cont.interfaceCont.addChild(_source);
        _source.y = 130;
        _source.x = g.managerResize.stageWidth - 108;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
        g.gameDispatcher.addToTimer(startTimer);
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 130;
        _source.x = g.managerResize.stageWidth - 108;
    }

    private function startTimer():void {
        if (g.userTimer.partyTimer > 0) if (_txtData)_txtData.text = TimeUtils.convertSecondsForHint(g.userTimer.partyTimer);
        else {
            g.gameDispatcher.removeFromTimer(startTimer);
            if (!Boolean(g.managerParty.userParty.showWindow)) timeEnd();
        }
    }

    private function timeEnd():void {
        if (g.userInventory.getCountResourceById(168) <= 0) return;
        if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
        visiblePartyPanel(false);
        if (_txtData) {
            _source.removeChild(_txtData);
            _txtData.deleteIt();
            _txtData = null;
        }
        g.windowsManager.openWindow(WindowsManager.WO_PARTY_CLOSE,null);
        var st:String = 0 + '&' + 0 + '&' + 0 + '&'
                + 0 + '&' + 0;
        g.directServer.updateUserParty(st,0,1, null);
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i].plant && arr[i].plant.dataPlant.id == 168) {
                g.managerPlantRidge.removeCatFromRidge(arr[i].plant.dataPlant.id, arr[i]);
                g.managerPlantRidge.onCraft(arr[i].plant.idFromServer);
                arr[i].plant.clearIt();
            }
        }

        arr = [];
        arr = g.managerOrder.arrOrders;
        for (i = 0; i < arr.length; i++) {
            for (var k:int = 0; k < arr[i].resourceIds.length; k++) {
                if (arr[i].resourceIds[k] == 168) {
                    g.managerOrder.deleteOrderParty(arr[i].dbId, arr[i].placeNumber);
                    break;
                }
            }
        }

        arr = [];
        arr = g.managerBuyerNyashuk.arrNyashuk;
        if (arr.length > 0) {
            for (i = 0; i < arr.length; i++) {
                if (arr[i].dataNyashuk.resourceId == 168) {
                    g.managerBuyerNyashuk.onReleaseOrder(arr[i],false);
                    if (arr[i].dataNyashuk.buyerId == 1) g.userTimer.buyerNyashukBlue(1200);
                    else  g.userTimer.buyerNyashukRed(1200);
                    arr[i].dataNyashuk.timeToNext = int(new Date().getTime()/1000);
                    g.directServer.updateUserPapperBuy(arr[i].dataNyashuk.buyerId,0,0,0,0,0,0);
                }
            }
        }
    }

    private function onHover():void {
        g.hint.showIt('День Валентина','none', _source.x);
    }

    private function onOut():void {
        g.hint.hideIt();
    }

    public function visiblePartyPanel(b:Boolean):void {
        if (b) _source.visible = true;
        else _source.visible = false;
    }

    private function onClick():void {
        if (g.userTimer.partyTimer > 0) g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
    }
}
}
