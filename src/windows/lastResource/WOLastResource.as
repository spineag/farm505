/**
 * Created by user on 8/25/15.
 */
package windows.lastResource {
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import starling.text.TextField;
import starling.utils.Color;
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

    public function WOLastResource() {
        super();
        _windowType = WindowsManager.WO_LAST_RESOURCE;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);

        var txt:CTextField;
        txt = new CTextField(150,50,"ВНИМАНИЕ!");
        txt.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        txt.x = -75;
        txt.y = -130;
        _source.addChild(txt);
        txt = new CTextField(420,60,"Вы подтверждаете использование этого ресурса? После этого у вас не останется семян для посадки!");
        txt.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        txt.x = -210;
        txt.y = -90;
        _source.addChild(txt);
        _btnYes = new CButton();
        txt = new CTextField(50, 50, "ДА");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_GREEN_COLOR);
        txt.x = 15;
        txt.y = -5;
        _btnYes.addButtonTexture(80, 40, CButton.GREEN, true);
        _btnYes.addChild(txt);
        _source.addChild(_btnYes);

        _btnNo = new CButton();
        txt = new CTextField(50, 50, "НЕТ");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_YELLOW_COLOR);
        txt.x = 15;
        txt.y = -5;
        _btnNo.addButtonTexture(80, 40, CButton.YELLOW, true);
        _btnNo.addChild(txt);
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

    private function onClickFabric():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[_paramsFabrica.data, true]);
            _callbackBuy = null;
        }
        super.hideIt();
    }

    private function onClickNo():void {
        g.windowsManager.uncasheWindow();
        g.windowsManager.uncasheSecondWindow();
        super.hideIt();
    }

    override protected function deleteIt():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
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
