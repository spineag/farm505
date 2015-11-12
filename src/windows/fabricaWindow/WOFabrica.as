/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import build.fabrica.Fabrica;

import com.junkbyte.console.Cc;

import flash.filters.GlowFilter;

import resourceItem.ResourceItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

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

    public function WOFabrica() {
        super();
        _woHeight = 455;
        _woWidth = 580;

        createTopBG();
        createShiftBtns();
        createFabricaItems();
        createBottomBG();
        callbackClickBG = onClickExit;
        _list = new WOFabricaWorkList(_source);
    }

    public function onClickExit(e:Event=null):void {
        unfillFabricaItems();
        _list.unfillIt();
        _fabrica = null;
        _callbackOnClick = null;
        _arrAllRecipes.length = 0;
        hideIt();
//        _source.removeChild(_contBtn);
    }

    public function showItWithParams(arrRecipes:Array, arrList:Array, fabr:Fabrica, f:Function):void {
        _fabrica = fabr;
        _callbackOnClick = f;
        _arrAllRecipes = arrRecipes;
        activateShiftBtn(1, false);
        fillFabricaItems();
        _list.fillIt(arrList, _fabrica);
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
        unfillFabricaItems();
        for (var i:int=0; i<5; i++) {
            if (_arrAllRecipes[_shift*5 + i]) {
                arr.push(_arrAllRecipes[_shift*5 + i]);
            } else {
                break;
            }
        }
        for (i=0; i<arr.length; i++) {
            if (arr[i].blockByLevel + 1 <= g.user.level)
             _arrFabricaItems[i].fillData(arr[i], onItemClick);
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

//    public function onSkip():void {
//        if (g.user.hardCurrency < int(_txtCount.text)) {
//            g.woBuyCurrency.showItMenu(true);
//            return;
//        }
//        g.userInventory.addMoney(1,-int(_txtCount.text));
//        _list.skipIt();
//    }

    private function createTopBG():void {
        _topBG = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_l'));
        _topBG.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_r'));
        im.x = 580 - im.width;
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

        _arrShiftBtns = [];
        for (var i:int=0; i<4; i++) {
            s = new CSprite();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_bt_number'));
            s.addChild(im);
            txt = new TextField(32, 32, String(i), g.allData.fonts['BloggerBold'], 22,0x009bff);
            txt.nativeFilters = [new GlowFilter(Color.WHITE, 1, 6, 6, 5.0)];
            txt.y = 20;
            txt.x = 2;
            s.addChild(txt);
            s.flatten();
            s.x = -_woWidth/2 + 220 + i*(42);
            s.y = -_woHeight/2 + 117;
            _source.addChildAt(s, 0);
            _arrShiftBtns.push(s);
            s.endClickParams = i+1;
            s.endClickCallback = activateShiftBtn;
        }
    }

    private function activateShiftBtn(n:int, needUpdate:Boolean = true):void {
        for (var i:int=0; i<_arrShiftBtns.length; i++) {
            _arrShiftBtns[i].y = -_woHeight/2 + 117;
        }
        _arrShiftBtns[n-1].y += 8;
        _shift = n-1;
        if (needUpdate) {
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
