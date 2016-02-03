/**
 * Created by user on 8/25/15.
 */
package windows.lastResource {

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOLastResource extends Window{
    private var _contBtnYes:CButton;
    private var _contBtnNo:CButton;
    private var _data:Object;
    private var _callbackBuy:Function;
    private var _woBG:WindowBackground;
    private var _arrItems:Array;
    private var _dataResource:Object;
    public function WOLastResource() {
        super();
        var txt:TextField;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        txt = new TextField(150,50,"ВНИМАНИЕ!",g.allData.fonts['BloggerBold'],20,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -80;
        txt.y = -130;
        _source.addChild(txt);
        txt = new TextField(320,50,"Вы подтверждаете использование этого ресурса? После этого у вас не останется семян для посадки!",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -160;
        txt.y = -90;
        _source.addChild(txt);
        _contBtnYes = new CButton();
        txt = new TextField(50, 50, "ДА", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
        txt.x = 15;
        txt.y = -5;
        _contBtnYes.addButtonTexture(80, 40, CButton.YELLOW, true);
        _contBtnYes.addChild(txt);
        _source.addChild(_contBtnYes);

        _contBtnNo = new CButton();
        txt = new TextField(50, 50, "НЕТ", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
        txt.x = 15;
        txt.y = -5;
        _contBtnNo.addButtonTexture(80, 40, CButton.YELLOW, true);
        _contBtnNo.addChild(txt);
        _source.addChild(_contBtnNo);
        _contBtnYes.clickCallback = onClickNo;

        _contBtnYes.x = 100;
        _contBtnYes.y = 80;
        _contBtnNo.x = -100;
        _contBtnNo.y = 80;
        callbackClickBG = onClickExit;
        _arrItems = [];
    }

    private function onClickExit():void {
        _contBtnYes.clickCallback = null;
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        hideIt();
    }

    public function showItOrder(_data:Object, f:Function):void {
        _callbackBuy = f;
        if (!_data) {
            Cc.error('WOLastResource showItMenu:: empty _data');
            g.woGameError.showIt();
            return;
        }
        var item:WOLastResourceItem;
        _dataResource = _data;
        for (var i:int=0; i < _data.resourceIds.length; i++) {
            if (_data.resourceCounts[i] == g.userInventory.getCountResourceById(_data.resourceIds[i]) && g.dataResource.objectResources[_data.resourceIds[i]].buildType == BuildType.PLANT) {
                item = new WOLastResourceItem();
                item.fillWithResource(_data.resourceIds[i]);
//                item.source.x = -70 * i +50;
//                item.source.y = -40;
                _source.addChild(item.source);
                _arrItems.push(item);
            }
        }
        switch (_arrItems.length) {
            case 1:
                _arrItems[0].source.x = - item.source.width/2;
                _arrItems[0].source.y =  -40;
                break;
            case 2:
                _arrItems[0].source.x = -200 + 117;
                _arrItems[0].source.y =  -40;
                _arrItems[1].source.x = -200 + 217;
                _arrItems[1].source.y =  -40;
                break;
            case 3:
                _arrItems[0].source.x = -200 + 77;
                _arrItems[0].source.y =  -40;
                _arrItems[1].source.x = -200 + 167;
                _arrItems[1].source.y =  -40;
                _arrItems[2].source.x = -200 + 257;
                _arrItems[2].source.y =  -40;
                break;
            case 4:
                _arrItems[0].source.x = -200 + 39;
                _arrItems[0].source.y =  -40;
                _arrItems[1].source.x = -200 + 124;
                _arrItems[1].source.y =  -40;
                _arrItems[2].source.x = -200 + 209;
                _arrItems[2].source.y =  -40;
                _arrItems[3].source.x = -200 + 294;
                _arrItems[3].source.y =  -40;
                break;
            case 5:
                _arrItems[0].source.x = -200 + 27;
                _arrItems[0].source.y =  -40;
                _arrItems[1].source.x = -200 + 97;
                _arrItems[1].source.y =  -40;
                _arrItems[2].source.x = -200 + 167;
                _arrItems[2].source.y =  -40;
                _arrItems[3].source.x = -200 + 237;
                _arrItems[3].source.y =  -40;
                _arrItems[4].source.x = -200 + 307;
                _arrItems[4].source.y =  -40;
                break;
        }
        _contBtnYes.clickCallback = onClickOrder;

        showIt();
    }

    private function onClickOrder():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[true, _dataResource]);
            _callbackBuy = null;
        }
        onClickExit();
    }

    public function showItMarket(id:int,f:Function):void {
        _callbackBuy = f;
        var item:WOLastResourceItem;
        item = new WOLastResourceItem();
        item.fillWithResource(id);
        item.source.x = -25;
        item.source.y = -40;
        _source.addChild(item.source);
        _arrItems.push(item);
        _contBtnYes.clickCallback = onClickMarket;
        showIt();
    }

    private function onClickMarket():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[true]);
            _callbackBuy = null;
        }
        onClickExit();
    }

    private function onClickNo():void {
        onClickExit();
    }
}
}
