/**
 * Created by user on 6/29/15.
 */
package windows.noResources {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import manager.ManagerFilters;
import utils.CButton;
import utils.MCScaler;
import windows.*;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import windows.WOComponents.WindowBackground;

public class WONoResources extends WindowMain {
    private var _btnBuy:CButton;
    private var _woBG:WindowBackground;
    private var _txtHardCost:TextField;
    private var _arrItems:Array;
    private var _count:int;
    private var _countCost:int;
    private var _callbackBuy:Function;
    private var _paramData:Object;

    public function WONoResources() {
        super();
        _windowType = WindowsManager.WO_NO_RESOURCES;
        _woWidth = 400;
        _woHeight = 340;
        _arrItems = [];
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        var txt:TextField = new TextField(300, 30, "НЕДОСТАТОЧНО РЕСУРСОВ!", g.allData.fonts['BloggerBold'], 22, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -130;
        _source.addChild(txt);
        txt = new TextField(350, 75, "Не хватает ингредиентов. Вы можете купить их за рубины и начать производство немедленно.", g.allData.fonts['BloggerMedium'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -175;
        txt.y = -100;
        _source.addChild(txt);

        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(210, 34, CButton.GREEN, true);
        _btnBuy.x = 0;
        _btnBuy.y = 110;
        _source.addChild(_btnBuy);
        _txtHardCost = new TextField(180, 34, "Купить ресурсы за 8888", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        _txtHardCost.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnBuy.addChild(_txtHardCost);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 25, 25);
        im.x = 180;
        im.y = 4;
        _btnBuy.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
    }

    override public function showItParams(callback:Function, params:Array):void {
        var item:WONoResourcesItem;
        _paramData = params[1];
        _callbackBuy = callback;
        switch (params[0]) {
            case 'animal':
                _count = g.dataResource.objectResources[_paramData.idResourceRaw].priceHard;
                _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.idResourceRaw, 1);
                item.source.x =  - item.source.width/2;
                item.source.y = 0;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnBuy.clickCallback = onClickAnimal;
                break;
            case 'menu':
//            public function showItMenu(data:Object, count:int, f:Function = null, r:Ridge = null, params:Object = null):void {
                _count = _paramData.count;
                createList(_paramData.data, _count);
                break;
            case 'money':
                _count = _paramData.count;
                _countCost = Math.ceil(_count / g.HARD_IN_SOFT);
                if (_paramData.currency == DataMoney.HARD_CURRENCY) {
                    Cc.error('hard currency can"t be in woNoResourceWindow');
                    g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woNoResource');
                    return;
                }
                _txtHardCost.text = 'Купить ресурсы ' + String(_count);
                item = new WONoResourcesItem();
                item.fillWithMoney(_count);
                item.source.x = - item.source.width/2;
                item.source.y = 0;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnBuy.clickCallback = onClickMoney;
                break;
            case 'order':
                _count = 0;
                for (var i:int=0; i<_paramData.resourceIds.length; i++) {
                    if (_paramData.resourceCounts[i] - g.userInventory.getCountResourceById(_paramData.resourceIds[i]) > 0) {
                        item = new WONoResourcesItem();
                        item.fillWithResource(_paramData.resourceIds[i], _paramData.resourceCounts[i] - g.userInventory.getCountResourceById(_paramData.resourceIds[i]));
                        _count += g.dataResource.objectResources[_paramData.resourceIds[i]].priceHard * (_paramData.resourceCounts[i] - g.userInventory.getCountResourceById(_paramData.resourceIds[i]));
                        _source.addChild(item.source);
                        _arrItems.push(item);
                    }
                }
                switch (_arrItems.length) {
                    case 1:
                        _arrItems[0].source.x = - item.source.width/2;
                        break;
                    case 2:
                        _arrItems[0].source.x = -200 + 117;
                        _arrItems[1].source.x = -200 + 217;
                        break;
                    case 3:
                        _arrItems[0].source.x = -200 + 77;
                        _arrItems[1].source.x = -200 + 167;
                        _arrItems[2].source.x = -200 + 257;
                        break;
                    case 4:
                        _arrItems[0].source.x = -200 + 39;
                        _arrItems[1].source.x = -200 + 124;
                        _arrItems[2].source.x = -200 + 209;
                        _arrItems[3].source.x = -200 + 294;
                        break;
                    case 5:
                        _arrItems[0].source.x = -200 + 27;
                        _arrItems[1].source.x = -200 + 97;
                        _arrItems[2].source.x = -200 + 167;
                        _arrItems[3].source.x = -200 + 237;
                        _arrItems[4].source.x = -200 + 307;
                        break;
                }
                _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
                _btnBuy.clickCallback = onClickOrder;
                break;
            case 'train':
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.data.id, _paramData.count);
                item.source.x =  - item.source.width/2;
                item.source.y = 0;
                _source.addChild(item.source);
                _arrItems.push(item);
                _count = int(_paramData.data.priceHard);
                _countCost = _count;
                _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
                _btnBuy.clickCallback = onClickTrain;
        }

        super.showIt();
    }

    private function createList(_data:Object, count:int):void {
        var im:WONoResourcesItem;
        var countRes:int = 0;
        var i:int;

        if (!_data) {
            Cc.error('WONoResource createList:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woNoResource');
            return;
        }
        if (_data.buildType == BuildType.INSTRUMENT) {
            im = new WONoResourcesItem();
            im.fillWithResource(_data.id, 1);
            im.source.x =  - im.source.width/2;
            im.source.y = 0;
            _source.addChild(im.source);
            _arrItems.push(im);
            _count = int(_data.priceHard);
            _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
            _btnBuy.clickCallback = onClickResource;
            return;
        }
        if (_data.buildType == BuildType.PLANT) {
            im = new WONoResourcesItem();
            im.fillWithResource(_data.id, 1);
            im.source.x =  - im.source.width/2;
            im.source.y = 0;
            _source.addChild(im.source);
            _arrItems.push(im);
            _count = int(_data.priceHard);
            _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
            _btnBuy.clickCallback = onClickResource;
            return;
        }

        if (_data.ingridientsId) {
            _count = 0;
            for (i = 0; i < _data.ingridientsId.length; i++) {
                countRes = g.userInventory.getCountResourceById(_data.ingridientsId[i]);
                if (countRes < _data.ingridientsCount[i]) {
                    im = new WONoResourcesItem();
                    im.fillWithResource(_data.ingridientsId[i], _data.ingridientsCount[i] - countRes);
                    _count += g.dataResource.objectResources[_data.ingridientsId[i]].priceHard * (_data.ingridientsCount[i] - countRes);
                    im.source.y = 0;
                    _source.addChild(im.source);
                    _arrItems.push(im);
                }
            }
            _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
            switch (_arrItems.length) {
                case 1:
                    _arrItems[0].source.x = - im.source.width/2;
                    break;
                case 2:
                    _arrItems[0].source.x = -200 + 117;
                    _arrItems[1].source.x = -200 + 217;
                    break;
                case 3:
                    _arrItems[0].source.x = -200 + 77;
                    _arrItems[1].source.x = -200 + 167;
                    _arrItems[2].source.x = -200 + 257;
                    break;
                case 4:
                    _arrItems[0].source.x = -200 + 39;
                    _arrItems[1].source.x = -200 + 124;
                    _arrItems[2].source.x = -200 + 209;
                    _arrItems[3].source.x = -200 + 294;
                    break;
                case 5:
                    _arrItems[0].source.x = -200 + 27;
                    _arrItems[1].source.x = -200 + 97;
                    _arrItems[2].source.x = -200 + 167;
                    _arrItems[3].source.x = -200 + 237;
                    _arrItems[4].source.x = -200 + 307;
                    break;
            }
            _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
        }
        _btnBuy.clickCallback = onClickResource;
    }


    private function onClickMoney():void {
        if (_count <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            g.windowsManager.uncasheWindow();
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, _count);
        hideIt();
        if (_callbackBuy != null) {
            _callbackBuy.apply(null);
            _callbackBuy = null;
        }
    }

    private function onClickAnimal():void {
        if (_count <= g.user.hardCurrency) {
            g.userInventory.addMoney(1, -_count);
        } else {
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addResource(_paramData.idResourceRaw,1);
        hideIt();
    }


    private function onClickResource():void {
        var countRes:int = 0;
        if (_count <= g.user.hardCurrency) {
            g.userInventory.addMoney(1, -_count);
        } else {
            hideIt();
            g.windowsManager.uncasheWindow();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        if (_paramData.buildType == BuildType.INSTRUMENT) {
            g.userInventory.addResource(_paramData.id,1);
            if (_callbackBuy != null) {
                _callbackBuy.apply(null);
                _callbackBuy = null;
            }
        } else if (_paramData.buildType == BuildType.PLANT) {
            g.userInventory.addResource(_paramData.id,1);
            if (_callbackBuy != null) {
                _callbackBuy.apply(null, [_paramData, _paramData.ridge]);
                _callbackBuy = null;
            }
        } else if (_paramData.ingridientsId) {
            for (var i:int = 0; i < _paramData.ingridientsId.length; i++) {
                countRes = g.userInventory.getCountResourceById(_paramData.ingridientsId[i]);
                if (countRes < _paramData.ingridientsCount[i]) {
                    g.userInventory.addResource(_paramData.ingridientsId[i], _paramData.ingridientsCount[i] - countRes);
                }
            }

            if (_callbackBuy != null) {
                _callbackBuy.apply(null, [_paramData, true]);
            }
        }
        hideIt();
    }

    private function onClickOrder():void {
        var number:int = 0;
        if (_count <= g.user.hardCurrency) {
            g.userInventory.addMoney(1, -_count);
        } else {
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        for (var i:int=0; i<_paramData.resourceIds.length; i++) {
            number = g.userInventory.getCountResourceById(_paramData.resourceIds[i]);
            if (number < _paramData.resourceCounts[i]) g.userInventory.addResource(_paramData.resourceIds[i], _paramData.resourceCounts[i] - number);
        }
        hideIt();
//        if (_callbackBuy != null) {
//            _callbackBuy.apply(null,[true, _dataResource]);
//            _callbackBuy = null;
//        }
    }

    private function onClickTrain():void {
        if (_count <= g.user.hardCurrency) {
            g.userInventory.addMoney(1, -_count);
        } else {
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addResource(_paramData.id,_countCost);
        hideIt();

//        if (_callbackBuy != null) {
//            _callbackBuy.apply(null,[true]);
//            _callbackBuy = null;
//        }
    }

    override protected function deleteIt():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;

        super.deleteIt();
    }

    private function onClickExit():void {
        g.windowsManager.uncasheWindow();
        hideIt();
    }
}
}