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
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import windows.WOComponents.WindowBackground;

public class WONoResources extends Window {
    private var _btnBuy:CButton;
    private var _woBG:WindowBackground;

    private var _txtHardCost:TextField;
    private var _arrItems:Array;

    private var _count:int;
    private var _dataResource:Object;
    private var _callbackBuy:Function;
    private var _params:Object;

    public function WONoResources() {
        super();
        _woWidth = 400;
        _woHeight = 340;
        _arrItems = [];
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        callbackClickBG = onClickExit;

        var txt:TextField = new TextField(300, 30, "НЕДОСТАТОЧНО РЕСУРСОВ", g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -135;
        _source.addChild(txt);
        txt = new TextField(350, 100, "Не хватает ингредиентов. Вы можете купить их за изумруды и начать производство немедленно.", g.allData.fonts['BloggerMedium'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -175;
        txt.y = -110;
        _source.addChild(txt);

        createBtn();
    }

    private function createBtn():void {
        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(190, 34, CButton.GREEN, true);
        _btnBuy.x = 0;
        _btnBuy.y = 124;
        _source.addChild(_btnBuy);
        _txtHardCost = new TextField(160, 34, "Купить ресурсы за 8888", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        _txtHardCost.y = 0;
        _txtHardCost.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnBuy.addChild(_txtHardCost);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 25, 25);
        im.x = 160;
        im.y = 4;
        _btnBuy.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
    }

    private function onClickExit(e:Event = null):void {
        _btnBuy.clickCallback = null;
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        hideIt();
    }

    public function showItMoney(currency:int, count:int, f:Function):void {
        _count = Math.ceil(_count / g.HARD_IN_SOFT);
        if (currency == DataMoney.HARD_CURRENCY) {
            Cc.error('hard currency can"t be in woNoResourceWindow');
            g.woGameError.showIt();
            return;
        }
        _txtHardCost.text = 'Купить ресурсы ' + String(_count);
        var item:WONoResourcesItem = new WONoResourcesItem();
        item.fillWithMoney(count);
        item.source.x = - item.source.width/2;
        item.source.y = 0;
        _source.addChild(item.source);
        _arrItems.push(item);
        _callbackBuy = f;
        _btnBuy.clickCallback = onClickMoney;
        showIt();
    }

    private function onClickMoney():void {
        if (_count < g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_count);
        } else {
            g.woBuyCurrency.showItMenu(true);
            return;
        }
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, _count);
        onClickExit();
        if (_callbackBuy != null) {
            _callbackBuy.apply(null);
            _callbackBuy = null;
        }
    }

    public function showItAnimal(data:Object, f:Function = null):void {
        _dataResource = data;
        _callbackBuy = f;
        _count = g.dataResource.objectResources[_dataResource.idResourceRaw].priceHard;
        _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
        var item:WONoResourcesItem = new WONoResourcesItem();
        item.fillWithResource(g.dataResource.objectResources[_dataResource.idResourceRaw], 1);
        item.source.x =  - item.source.width/2;
        item.source.y = 0;
        _source.addChild(item.source);
        _arrItems.push(item);
        _callbackBuy = f;
        _btnBuy.clickCallback = onClickAnimal;
        showIt();
    }

    private function onClickAnimal():void {
        if (int(_txtHardCost.text) < g.user.hardCurrency) {
            g.userInventory.addMoney(1, -int(_txtHardCost.text));
        } else {  g.woBuyCurrency.showItMenu(true);
            return;
        }
        g.userInventory.addResource(_dataResource.idResourceRaw,1);
        onClickExit();
        if (_callbackBuy != null) {
            _callbackBuy.apply(null);
            _callbackBuy = null;
        }
    }

    public function showItMenu(data:Object, count:int, f:Function = null, params:Object = null):void {
        createList(data, count);
        showIt();
        _params = params;
        _dataResource = data;
        _callbackBuy = f;
    }

    private function createList(_data:Object, count:int):void {
        var im:WONoResourcesItem;
        var countRes:int = 0;
        var i:int;

        if (!_data) {
            Cc.error('WONoResource createList:: empty _data');
            g.woGameError.showIt();
            return;
        }

        if (_data.buildType == BuildType.PLANT) {
            im = new WONoResourcesItem();
            im.fillWithResource(_data.id, 1);
            im.source.x =  - im.source.width/2;
            im.source.y = 0;
            _source.addChild(im.source);
            _arrItems.push(im);
            _count = int(g.dataResource.objectResources[_data.ingridientsId].priceHard);
            _txtHardCost.text = 'Купить ресурсы за ' + String(_count);
            return;
        }

        if (_data.ingridientsId) {
            _count = 0;
            for (i = 0; i < _data.ingridientsId.length; i++) {
                countRes = g.userInventory.getCountResourceById(_data.ingridientsId[i]);
                if (countRes < _data.ingridientsCount[i]) {
                    im = new WONoResourcesItem();
                    im.fillWithResource(_data.ingridientsId[i], _data.ingridientsCount[i] - countRes);
                    count += g.dataResource.objectResources[_data.ingridientsId[i]].priceHard * (_data.ingridientsCount[i] - countRes);
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
        }

        _btnBuy.clickCallback = onClickResource;

    }

    private function onClickResource():void {
        var countRes:int = 0;
        if (int(_txtHardCost.text) < g.user.hardCurrency) {
            g.userInventory.addMoney(1, -int(_txtHardCost.text));
        } else {
            g.woBuyCurrency.showItMenu(true);
            return;
        }

        if (_dataResource.ingridientsId) {
            for (var i:int = 0; i < _dataResource.ingridientsId.length; i++) {
                countRes = g.userInventory.getCountResourceById(_dataResource.ingridientsId[i]);
                if (countRes < _dataResource.ingridientsCount[i]) {
                    g.userInventory.addResource(_dataResource.ingridientsId[i], _dataResource.ingridientsCount[i] - countRes);
                }
            }

            if (_callbackBuy != null) {
                if (_params) {
                    _callbackBuy.apply(null, [_dataResource, _params]);
                    _params = null;
                } else {
                    _callbackBuy.apply(null, [_dataResource]);
                }
            }
        }
        onClickExit();
    }

}
}