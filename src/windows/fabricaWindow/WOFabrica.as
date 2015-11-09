/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import com.junkbyte.console.Cc;

import data.DataMoney;

import resourceItem.ResourceItem;

import starling.display.Image;

import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;
import windows.ambar.AmbarCell;

public class WOFabrica extends Window {
    private var _list:WOFabricaWorkList;
    private var _arrItems:Array;
    private var _callbackOnClick:Function;
    private var _contBtn:CSprite;
    private var _imageBtnSkip:Image;
    private var _imageHard:Image;
    private var _txtCount:TextField;

    public function WOFabrica() {
        super();
        _contBtn = new CSprite();
        _contBtn.endClickCallback = onSkip;
        _woHeight = 400;
        _woWidth = 560;
        createTempBG(_woWidth, _woHeight, Color.GRAY);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('btn_exit'), '', g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_click'), g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        _imageBtnSkip = new Image(g.allData.atlas['interfaceAtlas'].getTexture('btn4'));
        _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture('diamont'));
        _imageHard.x = 10;
        _imageHard.y = 10;
        MCScaler.scale(_imageHard,25,25);
        _txtCount = new TextField(50,50,"","Arial",14,Color.BLACK);
        _txtCount.x = 40;
        _txtCount.y = 10;
        _contBtn.addChild(_imageBtnSkip);
        _contBtn.addChild(_imageHard);
        _contBtn.addChild(_txtCount);
        _contBtn.x = -150;
        _contBtn.y = 150;

        _list = new WOFabricaWorkList(_source);
        createItems();
        callbackClickBG = onClickExit;
    }

    private function onClickExit(e:Event=null):void {
        unfillItems();
        _list.unfillIt();
        hideIt();
        _source.removeChild(_contBtn);
    }

    public function showItWithParams(arrRecipes:Array, arrList:Array, maxCount:int, f:Function):void {
        _callbackOnClick = f;
        fillItems(arrRecipes, arrList, maxCount);
        super.showIt();
    }

    private function createItems():void {
        var item:WOItemFabrica;
        _arrItems = [];
        for (var i:int = 0; i < 10; i++) {
            item = new WOItemFabrica();
            item.source.x = -220 + i%5 * 110;
            i > 4 ? item.source.y = 0 : item.source.y = -120;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }
    
    private function unfillItems():void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].unfillIt();
        }
    }

    private function fillItems(arrAllRecipes:Array, arrList:Array, maxCount:int):void {
        try {
            unfillItems();
            if (arrAllRecipes.length > 10) arrAllRecipes.length = 10; // временно, пока не сделана нормальная прокрутка
            for (var i:int = 0; i < arrAllRecipes.length; i++) {
                _arrItems[i].fillData(arrAllRecipes[i], onItemClick);
            }
            _list.fillIt(arrList, maxCount);
            _txtCount.text = "5";
           if(arrList.length>0) _source.addChild(_contBtn);
        } catch (e:Error) {
            Cc.error('WOFabrica fillItems error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    private function onItemClick(dataRecipe:Object):void {
        if (_list.isFull){
            g.woNoPlaces.showItMenu();
            return;
        }
//        if(!g.userInventory.checkRecipe(dataRecipe)) return;
            var count:int = 0;
            if (!dataRecipe || !dataRecipe.ingridientsId) {
                Cc.error('UserInventory checkRecipe:: bad _data');
                g.woGameError.showIt();
            }
            for (var i:int = 0; i < dataRecipe.ingridientsId.length; i++) {
                count =  g.userInventory.getCountResourceById(int(dataRecipe.ingridientsId[i]));
                if (count < int(dataRecipe.ingridientsCount[i])) {
                    g.woNoResources.showItMenu(dataRecipe, int(dataRecipe.ingridientsCount[i]) - count,onItemClick);
                    return;
                }
            }

        var resource:ResourceItem = new ResourceItem();
        resource.fillIt(g.dataResource.objectResources[dataRecipe.idResource]);
        _list.addResource(resource);
//        _source.addChild(_contBtn);
        if (_callbackOnClick != null) {
            _callbackOnClick.apply(null, [resource, dataRecipe]);
        }
    }

    public function onSkip():void {
        if (g.user.hardCurrency < int(_txtCount.text)) {
            g.woBuyCurrency.showItMenu(true);
            return;
        }
        g.userInventory.addMoney(1,-int(_txtCount.text));
        _list.skipIt();
//        var i:int;
//
//        for (i=0; i<_arrItems.length; i++) {
//            _arrItems[i].unfillIt();
//        }
//        _arrItems.shift();
//        if (_arrItems.length) {
//            for (i=0; i<_arrItems.length; i++) {
//                _arrItems[i].fillData(_arrItems[i], null);
//            }
//        }
    }
}
}
