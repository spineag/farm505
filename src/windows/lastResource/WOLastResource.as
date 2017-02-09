/**
 * Created by user on 8/25/15.
 */
package windows.lastResource {
import additional.buyerNyashuk.BuyerNyashuk;

import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;

import manager.ManagerFilters;

import resourceItem.DropItem;

import starling.text.TextField;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOLastResource extends WindowMain {
    private var _btnYes:CButton;
    private var _btnNo:CButton;
    private var _callbackBuy:Function;
    private var _woBG:WindowBackground;
    private var _arrItems:Array;
    private var _dataResource:Object;
    private var _paramsFabrica:Object;
    private var _txtAhtung:CTextField;
    private var _txt:CTextField;
    private var _txtYes:CTextField;
    private var _txtNo:CTextField;
    private var _window:String;
    private var _nyashuk:BuyerNyashuk;

    public function WOLastResource() {
        super();
        _windowType = WindowsManager.WO_LAST_RESOURCE;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);

        _txtAhtung = new CTextField(150,50,"ВНИМАНИЕ!");
        _txtAhtung.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtAhtung.x = -75;
        _txtAhtung.y = -130;
        _source.addChild(_txtAhtung);
        _txt = new CTextField(420,60,"Вы подтверждаете использование этого ресурса? После этого у вас не останется семян для посадки!");
        _txt.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -210;
        _txt.y = -90;
        _source.addChild(_txt);
        _btnYes = new CButton();
        _txtYes = new CTextField(50, 50, "ДА");
        _txtYes.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtYes.x = 15;
        _txtYes.y = -5;
        _btnYes.addButtonTexture(80, 40, CButton.GREEN, true);
        _btnYes.addChild(_txtYes);
        _source.addChild(_btnYes);

        _btnNo = new CButton();
        _txtNo = new CTextField(50, 50, "НЕТ");
        _txtNo.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.YELLOW_COLOR);
        _txtNo.x = 15;
        _txtNo.y = -5;
        _btnNo.addButtonTexture(80, 40, CButton.YELLOW, true);
        _btnNo.addChild(_txtNo);
        _source.addChild(_btnNo);
        _btnNo.clickCallback = onClickNo;

        _btnYes.x = 100;
        _btnYes.y = 80;
        _btnNo.x = -100;
        _btnNo.y = 80;
        _callbackClickBG = hideIt;
        _arrItems = [];
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callbackBuy = callback;
        _dataResource = params[0];
        if (!_dataResource) {
            Cc.error('WOLastResource showItParams:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'lastResource');
            return;
        }
        var item:WOLastResourceItem;
        var i:int;
        _window = params[1];
        switch (params[1]) {
            case 'order':
                for (i=0; i < _dataResource.resourceIds.length; i++) {
                    if (_dataResource.resourceCounts[i] == g.userInventory.getCountResourceById(_dataResource.resourceIds[i]) && g.dataResource.objectResources[_dataResource.resourceIds[i]].buildType == BuildType.PLANT) {
                        item = new WOLastResourceItem();
                        item.fillWithResource(_dataResource.resourceIds[i]);
                        _source.addChild(item.source);
                        _arrItems.push(item);
                    }
                }
                switch (_arrItems.length) {
                    case 1:
                        _arrItems[0].source.x = - item.source.width/2;
                        _arrItems[0].source.y =  -20;
                        break;
                    case 2:
                        _arrItems[0].source.x = -200 + 117;
                        _arrItems[0].source.y =  -20;
                        _arrItems[1].source.x = -200 + 217;
                        _arrItems[1].source.y =  -20;
                        break;
                    case 3:
                        _arrItems[0].source.x = -200 + 77;
                        _arrItems[0].source.y =  -20;
                        _arrItems[1].source.x = -200 + 167;
                        _arrItems[1].source.y =  -20;
                        _arrItems[2].source.x = -200 + 257;
                        _arrItems[2].source.y =  -20;
                        break;
                    case 4:
                        _arrItems[0].source.x = -200 + 39;
                        _arrItems[0].source.y =  -20;
                        _arrItems[1].source.x = -200 + 124;
                        _arrItems[1].source.y =  -20;
                        _arrItems[2].source.x = -200 + 209;
                        _arrItems[2].source.y =  -20;
                        _arrItems[3].source.x = -200 + 294;
                        _arrItems[3].source.y =  -20;
                        break;
                    case 5:
                        _arrItems[0].source.x = -200 + 27;
                        _arrItems[0].source.y =  -20;
                        _arrItems[1].source.x = -200 + 97;
                        _arrItems[1].source.y =  -20;
                        _arrItems[2].source.x = -200 + 167;
                        _arrItems[2].source.y =  -20;
                        _arrItems[3].source.x = -200 + 237;
                        _arrItems[3].source.y =  -20;
                        _arrItems[4].source.x = -200 + 307;
                        _arrItems[4].source.y =  -20;
                        break;
                }
                _btnYes.clickCallback = onClickOrder;
                break;
            case 'market':
                item = new WOLastResourceItem();
                item.fillWithResource(_dataResource.id);
                item.source.x = -25;
                item.source.y = -20;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnYes.clickCallback = onClickMarket;
                break;
            case 'nyashuk':
                _nyashuk = params[2];
                item = new WOLastResourceItem();
                item.fillWithResource(_dataResource.resourceId);
                item.source.x = -25;
                item.source.y = -20;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnYes.clickCallback = onClickNyashuk;
                break;
            case 'fabrica':
                _paramsFabrica = params[2];
                for (i=0; i < _dataResource.ingridientsId.length; i++) {
                    if (g.dataResource.objectResources[_dataResource.ingridientsId[i]].buildType == BuildType.PLANT && _dataResource.ingridientsCount[i] == g.userInventory.getCountResourceById(_dataResource.ingridientsId[i])) {
                        item = new WOLastResourceItem();
                        item.fillWithResource(_dataResource.ingridientsId[i]);
                        _source.addChild(item.source);
                        _arrItems.push(item);
                    }
                }
                switch (_arrItems.length) {
                    case 1:
                        _arrItems[0].source.x = - item.source.width/2;
                        _arrItems[0].source.y =  -20;
                        break;
                    case 2:
                        _arrItems[0].source.x = -200 + 117;
                        _arrItems[0].source.y =  -20;
                        _arrItems[1].source.x = -200 + 217;
                        _arrItems[1].source.y =  -20;
                        break;
                    case 3:
                        _arrItems[0].source.x = -200 + 77;
                        _arrItems[0].source.y =  -20;
                        _arrItems[1].source.x = -200 + 167;
                        _arrItems[1].source.y =  -20;
                        _arrItems[2].source.x = -200 + 257;
                        _arrItems[2].source.y =  -20;
                        break;
                    case 4:
                        _arrItems[0].source.x = -200 + 39;
                        _arrItems[0].source.y =  -20;
                        _arrItems[1].source.x = -200 + 124;
                        _arrItems[1].source.y =  -20;
                        _arrItems[2].source.x = -200 + 209;
                        _arrItems[2].source.y =  -20;
                        _arrItems[3].source.x = -200 + 294;
                        _arrItems[3].source.y =  -20;
                        break;
                    case 5:
                        _arrItems[0].source.x = -200 + 27;
                        _arrItems[0].source.y =  -20;
                        _arrItems[1].source.x = -200 + 97;
                        _arrItems[1].source.y =  -20;
                        _arrItems[2].source.x = -200 + 167;
                        _arrItems[2].source.y =  -20;
                        _arrItems[3].source.x = -200 + 237;
                        _arrItems[3].source.y =  -20;
                        _arrItems[4].source.x = -200 + 307;
                        _arrItems[4].source.y =  -20;
                        break;
                }
                _btnYes.clickCallback = onClickFabric;

        }
        super.showIt();
    }

    private function onClickOrder():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[true, _dataResource]);
            _callbackBuy = null;
        }
        super.hideIt();
    }

    private function onClickMarket():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[true]);
            _callbackBuy = null;
        }
        super.hideIt();
    }

    private function onClickNyashuk():void {
        var ob:Object = {};
        ob.id = DataMoney.SOFT_CURRENCY;
        ob.count = _dataResource.cost;
        new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2,ob);
        _dataResource.visible = false;
        new XPStar(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2., 5);
        g.userInventory.addResource(_dataResource.resourceId,-_dataResource.resourceCount);
        g.directServer.updateUserPapperBuy(_dataResource.buyerId,0,0,0,0,0,0);
        if (_dataResource.buyerId == 1) g.userTimer.buyerNyashukBlue(1800);
        else  g.userTimer.buyerNyashukRed(1800);
        g.managerBuyerNyashuk.onReleaseOrder(_nyashuk,false);
        super.hideIt();
    }

    private function onClickFabric():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[_paramsFabrica.data, true]);
            _callbackBuy = null;
        }
        super.hideIt();
    }

    private function onClickNo():void {
        if (_window != 'market') {
            g.windowsManager.uncasheWindow();
            g.windowsManager.uncasheSecondWindow();
        }
        super.hideIt();
    }

    override protected function deleteIt():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_txtAhtung) {
            _source.removeChild(_txtAhtung);
            _txtAhtung.deleteIt();
            _txtAhtung = null;
        }
        if (_txtYes) {
            _btnYes.removeChild(_txtYes);
            _txtYes.deleteIt();
            _txtYes = null;
        }
        if (_txtNo) {
            _btnNo.removeChild(_txtNo);
            _txtNo.deleteIt();
            _txtNo = null;
        }
        _arrItems.length = 0;
        _source.removeChild(_btnNo);
        _btnNo.deleteIt();
        _btnNo = null;
        _source.removeChild(_btnYes);
        _btnYes.deleteIt();
        _btnYes = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _dataResource = null;
        _paramsFabrica = null;
        super.deleteIt();
    }
}
}
