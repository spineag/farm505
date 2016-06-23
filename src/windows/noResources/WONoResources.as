/**
 * Created by user on 6/29/15.
 */
package windows.noResources {
import analytic.AnalyticManager;

import com.greensock.TweenMax;
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
    private var _countOfResources:int;
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
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
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
                if (g.dataResource.objectResources[_paramData.idResourceRaw].buildType == BuildType.PLANT)_countOfResources = 2;
                else _countOfResources = 1;
                _countCost = g.dataResource.objectResources[_paramData.idResourceRaw].priceHard * _countOfResources;
                _txtHardCost.text = 'Купить ресурсы за ' + String(_countCost);
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.idResourceRaw, _countOfResources);
                item.source.x =  - item.source.width/2;
                item.source.y = 0;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnBuy.clickCallback = onClickAnimal;
                break;
            case 'menu':
                _countOfResources = _paramData.count;
                createList(_paramData.data);
                _btnBuy.clickCallback = onClickResource;
                break;
            case 'money':
                _countOfResources = _paramData.count;
                _countCost = Math.ceil(_countOfResources / g.HARD_IN_SOFT);
                if (_paramData.currency == DataMoney.HARD_CURRENCY) {
                    Cc.error('hard currency can"t be in woNoResourceWindow');
                    g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woNoResource');
                    return;
                }
                _txtHardCost.text = 'Купить ресурсы ' + String(_countCost);
                item = new WONoResourcesItem();
                item.fillWithMoney(_countOfResources);
                item.source.x = - item.source.width/2;
                item.source.y = 0;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnBuy.clickCallback = onClickMoney;
                break;
            case 'order':
                var countR:int;
                _countCost = 0;
                for (var i:int=0; i<_paramData.resourceIds.length; i++) {
                    countR = _paramData.resourceCounts[i] - g.userInventory.getCountResourceById(_paramData.resourceIds[i]);
                    if (countR > 0) {
                        item = new WONoResourcesItem();
                        item.fillWithResource(_paramData.resourceIds[i], countR);
                        _countCost += g.dataResource.objectResources[_paramData.resourceIds[i]].priceHard * countR;
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
                _txtHardCost.text = 'Купить ресурсы за ' + String(_countCost);
                _btnBuy.clickCallback = onClickOrder;
                break;
            case 'papper':
                _countOfResources = _paramData.count;
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.data.id, _paramData.count);
                item.source.x =  - item.source.width/2;
                item.source.y = 0;
                _source.addChild(item.source);
                _arrItems.push(item);
                _countCost = _paramData.count * int(_paramData.data.priceHard);
                _txtHardCost.text = 'Купить ресурсы за ' + String(_countCost);
                _btnBuy.clickCallback = onClickPapper;
                break;
            case 'train':
                _countOfResources = _paramData.count;
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.data.id, _paramData.count);
                item.source.x =  - item.source.width/2;
                item.source.y = 0;
                _source.addChild(item.source);
                _arrItems.push(item);
                _countCost = _paramData.count * int(_paramData.data.priceHard);
                _txtHardCost.text = 'Купить ресурсы за ' + String(_countCost);
                _btnBuy.clickCallback = onClickTrain;
        }

        super.showIt();
    }

    private function createList(_data:Object):void {
        var im:WONoResourcesItem;
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
            _countCost = int(_data.priceHard)*_countOfResources;
            _txtHardCost.text = 'Купить ресурсы за ' + String(_countCost);
        } else if (_data.buildType == BuildType.PLANT) {
            im = new WONoResourcesItem();
            im.fillWithResource(_data.id, _countOfResources);
            im.source.x =  - im.source.width/2;
            im.source.y = 0;
            _source.addChild(im.source);
            _arrItems.push(im);
            _countCost = int(_data.priceHard) * _countOfResources;
            _txtHardCost.text = 'Купить ресурсы за ' + String(_countCost);
        } else if (_data.ingridientsId) {
            var countR:int;
            _countCost = 0;
            for (i = 0; i < _data.ingridientsId.length; i++) {
                countR = g.userInventory.getCountResourceById(_data.ingridientsId[i]);
                if (countR < _data.ingridientsCount[i]) {
                    im = new WONoResourcesItem();
                    im.fillWithResource(_data.ingridientsId[i], _data.ingridientsCount[i] - countR);
                    _countCost += g.dataResource.objectResources[_data.ingridientsId[i]].priceHard * (_data.ingridientsCount[i] - countR);
                    im.source.y = 0;
                    _source.addChild(im.source);
                    _arrItems.push(im);
                }
            }
            _txtHardCost.text = 'Купить ресурсы за ' + String(_countCost);
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
        }
    }


    private function onClickMoney():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, _countOfResources);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_SOFT_FOR_HARD, {id: DataMoney.SOFT_CURRENCY, info: _countOfResources});
        super.hideIt();
        if (_callbackBuy != null) {
            _callbackBuy.apply(null);
            _callbackBuy = null;
        }
    }

    private function onClickAnimal():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(_countOfResources, -_countCost);
        } else {
            _callbackBuy = null;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addResource(_paramData.idResourceRaw, _countOfResources,true,callbackServe);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.idResourceRaw, info: _countOfResources});
        super.hideIt();
//        if (_callbackBuy != null) {
//            _callbackBuy.apply(null);
//            _callbackBuy = null;
//        }
    }

    private function onClickResource():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        if (_paramData.data.buildType == BuildType.INSTRUMENT) {
            g.userInventory.addResource(_paramData.data.id, _countOfResources,true,callbackServe);
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.id, info: _countOfResources});
            super.hideIt();
//            if (_callbackBuy != null) {
//                _callbackBuy.apply(null);
//                _callbackBuy = null;
//            }
        } else if (_paramData.data.buildType == BuildType.PLANT) {
            g.userInventory.addResource(_paramData.data.id, _countOfResources);
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.id, info: _countOfResources});
            super.hideIt();
            if (_callbackBuy != null) {
                _callbackBuy.apply(null, [_paramData.data, _paramData.ridge]);
                _callbackBuy = null;
            }
        } else if (_paramData.data.ingridientsId) {
            var countRes:int = 0;
            for (var i:int = 0; i < _paramData.data.ingridientsId.length; i++) {
                countRes = g.userInventory.getCountResourceById(_paramData.data.ingridientsId[i]);
                if (countRes < _paramData.data.ingridientsCount[i]) {
                    g.userInventory.addResource(_paramData.data.ingridientsId[i], _paramData.data.ingridientsCount[i] - countRes, true, callbackServe3);
                    g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.ingridientsId[i], info: _paramData.data.ingridientsCount[i] - countRes});
                }
            }
            super.hideIt();
//            if (_callbackBuy != null) {
//                _callbackBuy.apply(null, [_paramData.data, true]);
//            }
        }
    }

    private function onClickOrder():void {
        var number:int = 0;
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        for (var i:int=0; i<_paramData.resourceIds.length; i++) {
            number = g.userInventory.getCountResourceById(_paramData.resourceIds[i]);
            if (number < _paramData.resourceCounts[i]) {
                g.userInventory.addResource(_paramData.resourceIds[i], _paramData.resourceCounts[i] - number,true,callbackServe4);
                g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.resourceIds[i], info: _paramData.resourceCounts[i] - number});

            }
        }
        super.hideIt();
//        if (_callbackBuy != null) {
//            _callbackBuy.apply(null, [true, _paramData]);
//            _callbackBuy = null;
//        }
    }
    private function onClickPapper():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addResource(_paramData.data.id, _countOfResources,true,callbackServe2);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.id, info: _countOfResources});

        super.hideIt();
//        if (_callbackBuy != null) {
//            _callbackBuy.apply(null,[true]);
//            _callbackBuy = null;
//        }
    }

    private function onClickTrain():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addResource(_paramData.data.id, _countOfResources,true,callbackServe2);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.id, info: _countOfResources});
        super.hideIt();
//        if (_callbackBuy != null) {
//            _callbackBuy.apply(null,[true]);
//            _callbackBuy = null;
//        }
    }

    private function callbackServe(b:Boolean):void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null);
            _callbackBuy = null;
        }
    }

    private function callbackServe2(b:Boolean):void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[true]);
            _callbackBuy = null;
        }
    }

    private function callbackServe3(b:Boolean):void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null, [_paramData.data, true]);
        }
    }

    private function callbackServe4(b:Boolean):void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null, [true, _paramData]);
            _callbackBuy = null;
        }
    }

    override protected function deleteIt():void {
        g.marketHint.hideIt();
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;

        super.deleteIt();
    }

    private function onClickExit():void {
        g.windowsManager.uncasheWindow();
        _callbackBuy = null;
        super.hideIt();
    }
}
}