/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import build.fabrica.Fabrica;

import com.junkbyte.console.Cc;
import flash.filters.GlowFilter;

import manager.ManagerFilters;

import resourceItem.ResourceItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import windows.WOComponents.Birka;
import windows.Window;

public class WOFabrica extends Window {
    private var _list:WOFabricaWorkList;
    private var _arrFabricaItems:Array;
    private var _callbackOnClick:Function;
    private var _topBG:Sprite;
    private var _shift:int;
    private var _arrShiftBtns:Array;
    private var _arrAllRecipes:Array;
    private var _bottomBG:Sprite;
    private var _fabrica:Fabrica;
    private var _birka:Birka;

    public function WOFabrica() {
        super();
        _arrShiftBtns = [];
        _woHeight = 455;
        _woWidth = 580;
        _birka = new Birka('Фабрика', _source, 455, 580);
        _birka.flipIt();
        _birka.source.rotation = Math.PI/2;
        _birka.source.x = -100;
        _birka.source.y = 257;
        callbackClickBG = onClickExit;
        createTopBG();
        createBottomBG();
        createFabricaItems();
        _list = new WOFabricaWorkList(_source);
    }

    public function onClickExit(e:Event=null):void {
        unfillFabricaItems();
        _list.unfillIt();
        _fabrica = null;
        _callbackOnClick = null;
        _arrAllRecipes.length = 0;
        for (var i:int=0; i<_arrShiftBtns.length; i++) {
            _source.removeChild(_arrShiftBtns[i]);
            _arrShiftBtns[i].deleteIt();
        }
        _arrShiftBtns.length = 0;
        hideIt();
    }

    public function showItWithParams(arrRecipes:Array, arrList:Array, fabr:Fabrica, f:Function):void {
        _fabrica = fabr;
        _callbackOnClick = f;
        _arrAllRecipes = arrRecipes;
        createShiftBtns();
        fillFabricaItems();
        _list.fillIt(arrList, _fabrica);
        _birka.updateText(_fabrica.dataBuild.name);
        super.showIt();
    }

    private function createFabricaItems():void {
        var item:WOItemFabrica;
        _arrFabricaItems = [];
        for (var i:int = 0; i < 5; i++) {
            item = new WOItemFabrica();
            item.source.x = -_woWidth/2 + 70 + i*107;
            item.source.y = -_woHeight/2 + 115;
            _source.addChild(item.source);
            _arrFabricaItems.push(item);
        }
    }
    
    private function unfillFabricaItems():void {
        for (var i:int = 0; i < _arrFabricaItems.length; i++) {
            _arrFabricaItems[i].unfillIt();
        }
    }

    private function fillFabricaItems():void {
        var arr:Array = [];
        for (var i:int=0; i<5; i++) {
            if (_arrAllRecipes[_shift*5 + i]) {
                arr.push(_arrAllRecipes[_shift*5 + i]);
            } else {
                break;
            }
        }
        for (i=0; i<arr.length; i++) {
            if (arr[i].blockByLevel - 1 <= g.user.level)
             _arrFabricaItems[i].fillData(arr[i], onItemClick);
        }
    }

    private function onBuyResource(dataRecipe:Object, obj:Object):void {
        showItWithParams((obj.fabrica as Fabrica).arrRecipes, (obj.fabrica as Fabrica).arrList, obj.fabrica as Fabrica, obj.callback);
        onItemClick(dataRecipe);
    }

    private function onItemClick(dataRecipe:Object):void {
        if (_list.isFull){
            var price:int = _list.priceForNewCell;
            hideIt();
            g.woNoPlaces.showItWithParams(price, onBuyNewCellFromWO, onClickExit);
            return;
        }

        if (!_fabrica.heroCat && g.managerCats.countFreeCats <= 0) {
            onClickExit();
            if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                g.woWaitFreeCats.showIt();
            } else {
                g.woNoFreeCats.showIt();
            }
            return;
        }

        var count:int = 0;
        if (!dataRecipe || !dataRecipe.ingridientsId) {
            Cc.error('UserInventory checkRecipe:: bad _data');
            g.woGameError.showIt();
        }
        for (var i:int = 0; i < dataRecipe.ingridientsId.length; i++) {
            count =  g.userInventory.getCountResourceById(int(dataRecipe.ingridientsId[i]));
            if (count < int(dataRecipe.ingridientsCount[i])) {
                var obj:Object = {};
                obj.fabrica = _fabrica;
                obj.callback = _callbackOnClick;
                onClickExit();
                g.woNoResources.showItMenu(dataRecipe, int(dataRecipe.ingridientsCount[i]) - count,onBuyResource, obj);
                return;
            }
        }

        var resource:ResourceItem = new ResourceItem();
        resource.fillIt(g.dataResource.objectResources[dataRecipe.idResource]);
        _list.addResource(resource);
        if (_callbackOnClick != null) {
            _callbackOnClick.apply(null, [resource, dataRecipe]);
        }
    }

    private function onBuyNewCellFromWO():void {
        showIt();
        _list.butNewCellFromWO();
    }

    private function createTopBG():void {
        _topBG = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_l'));
        _topBG.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_r'));
        im.x = _woWidth - im.width;
        _topBG.addChild(im);
        for (var i:int=0; i<10; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_c'));
            im.x = 50*(i+1);
            _topBG.addChildAt(im, 0);
        }
        _topBG.flatten();
        _topBG.x = -_woWidth/2;
        _topBG.y = -_woHeight/2 + 80;
        _source.addChild(_topBG);
    }

    private function createShiftBtns():void {
        var s:CSprite;
        var im:Image;
        var txt:TextField;
        var n:int = 0;
        var i:int;

        for (i = 0; i < _arrAllRecipes.length; i++) {
            if (_arrAllRecipes[i].blockByLevel <= g.user.level) n++;
        }
//        if (n <= 5) {
//            s = new CSprite();
//            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_bt_number'));
//            s.addChild(im);
//            txt = new TextField(32, 32, String(1), g.allData.fonts['BloggerBold'], 22, ManagerFilters.TEXT_BLUE);
//            txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
//            txt.y = 20;
//            txt.x = 2;
//            s.addChild(txt);
//            s.flatten();
//            s.x = -_woWidth / 2 + 220 + 42;
//            s.y = -_woHeight / 2 + 117;
//            _source.addChildAt(s, 0);
//            _arrShiftBtns.push(s);
//            s.endClickParams = 1;
//            s.endClickCallback = activateShiftBtn;
//        } else
        if ( n > 5 && n <= 10) {
            for (i= 0; i < 2; i++) {
                s = new CSprite();
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_bt_number'));
                s.addChild(im);
                txt = new TextField(32, 32, String(i + 1), g.allData.fonts['BloggerBold'], 22, ManagerFilters.TEXT_BLUE);
                txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
                txt.y = 20;
                txt.x = 2;
                s.addChild(txt);
                s.flatten();
                s.x = -_woWidth / 2 + 220 + i * (42);
                s.y = -_woHeight / 2 + 117;
                _source.addChildAt(s, 0);
                _arrShiftBtns.push(s);
                activateShiftBtn(1, false);
                s.endClickParams = i + 1;
                s.endClickCallback = activateShiftBtn;
            }
        } else if (n > 10 && n <= 15) {
            for (i= 0; i < 3; i++) {
                s = new CSprite();
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_bt_number'));
                s.addChild(im);
                txt = new TextField(32, 32, String(i + 1), g.allData.fonts['BloggerBold'], 22, ManagerFilters.TEXT_BLUE);
                txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
                txt.y = 20;
                txt.x = 2;
                s.addChild(txt);
                s.flatten();
                s.x = -_woWidth / 2 + 220 + i * (42);
                s.y = -_woHeight / 2 + 117;
                _source.addChildAt(s, 0);
                _arrShiftBtns.push(s);
                s.endClickParams = i + 1;
                s.endClickCallback = activateShiftBtn;
            }
        } else if (n > 15 && n <= 20) {
            for (i= 0; i < 4; i++) {
                s = new CSprite();
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_bt_number'));
                s.addChild(im);
                txt = new TextField(32, 32, String(i + 1), g.allData.fonts['BloggerBold'], 22, ManagerFilters.TEXT_BLUE);
                txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
                txt.y = 20;
                txt.x = 2;
                s.addChild(txt);
                s.flatten();
                s.x = -_woWidth / 2 + 220 + i * (42);
                s.y = -_woHeight / 2 + 117;
                _source.addChildAt(s, 0);
                _arrShiftBtns.push(s);
                s.endClickParams = i + 1;
                s.endClickCallback = activateShiftBtn;
            }
        }
    }

    private function activateShiftBtn(n:int, needUpdate:Boolean = true):void {
        for (var i:int=0; i<_arrShiftBtns.length; i++) {
            _arrShiftBtns[i].y = -_woHeight/2 + 117;
        }
        _arrShiftBtns[n-1].y += 8;
        _shift = n-1;
        if (needUpdate) {
            unfillFabricaItems();
            fillFabricaItems();
        }
    }

    private function createBottomBG():void {
        _bottomBG = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_box_l'));
        _bottomBG.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_box_r'));
        im.x = 374 - im.width;
        _bottomBG.addChild(im);
        for (var i:int=0; i<6; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_box_c'));
            im.x = 50*(i+1);
            _bottomBG.addChildAt(im, 0);
        }
        _bottomBG.flatten();
        _bottomBG.x = -_bottomBG.width/2;
        _bottomBG.y = -_woHeight/2 + 260;
        _source.addChild(_bottomBG);
    }
}
}
