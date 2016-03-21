/**
 * Created by user on 6/2/15.
 */
package windows.buyPlant {
import build.ridge.Ridge;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import windows.WOComponents.Birka;
import windows.Window;
import windows.fabricaWindow.WOFabricNumber;

public class WOBuyPlant extends Window {
    private var _ridge:Ridge;
    private var _callback:Function;
    private var _topBG:Sprite;
    private var _shift:int;
    private var _arrShiftBtns:Array;
    private var _arrPlantItems:Array;
    private var _arrAllPlants:Array;
    private var _birka:Birka;

    public function WOBuyPlant() {
        super();
        _woWidth = 580;
        _woHeight = 134;
        createBG();
        createPlantItems();
        callbackClickBG = onClickExit;
        _arrAllPlants = [];

        _birka = new Birka('Огород', _source, 455, 580);
        _birka.flipIt();
        _birka.source.rotation = Math.PI/2;
        _birka.source.x = 80;
        _birka.source.y = 150;
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        hideIt();
    }

    override public function hideIt():void {
        unfillPlantItems();
        _callback = null;
        _ridge = null;
        super.hideIt();
        if (_arrShiftBtns.length > 0) activateShiftBtn(1, false);
        for (var i:int=0; i<_arrShiftBtns.length; i++) {
            _source.removeChild(_arrShiftBtns[i]);
            _arrShiftBtns[i].deleteIt();
        }
    }

    public function showItWithParams(ridge:Ridge, f:Function):void {
        if (!ridge) {
            Cc.error('WOBuyPlant showItWithParams: ridge == null');
            g.woGameError.showIt();
            return;
        }
        _ridge = ridge;
        _callback = f;
        updatePlantArray();
        createShiftBtns();
        if (_arrShiftBtns.length > 0) activateShiftBtn(1, false);
        fillPlantItems();
        super.showIt();
    }

    private function updatePlantArray():void {
        _arrAllPlants.length = 0;
        for (var id:String in g.dataResource.objectResources) {
            if (g.dataResource.objectResources[id].buildType == BuildType.PLANT && g.dataResource.objectResources[id].blockByLevel <= g.user.level + 1) {
                _arrAllPlants.push(g.dataResource.objectResources[id]);
            }
        }
        _arrAllPlants.sortOn('blockByLevel', Array.NUMERIC);
    }

    private function fillPlantItems():void {
        var arr:Array = [];
        unfillPlantItems();
        for (var i:int=0; i<5; i++) {
            if (_arrAllPlants[_shift*5 + i]) {
                arr.push(_arrAllPlants[_shift*5 + i]);
            } else {
                break;
            }
        }
        for (i=0; i<arr.length; i++) {
            if (arr[i].blockByLevel <= g.user.level + 1)
                _arrPlantItems[i].fillData(arr[i], onClickItem);
        }
    }

    private function unfillPlantItems():void {
        for (var i:int = 0; i < _arrPlantItems.length; i++) {
            _arrPlantItems[i].unfillIt();
        }
    }

    private function onClickItem(d:Object, r:Ridge = null):void {
        if (g.userInventory.getCountResourceById(d.id) <= 0) {
            g.woNoResources.showItMenu(d,1,onClickItem,_ridge);
            return;
        }
        if (!_ridge) _ridge = r;
        if (g.managerPlantRidge.checkIsCat(d.id)) {
            _ridge.fillPlant(d);
            if (_callback != null) {
                _callback.apply();
                _callback = null;
            }
            hideIt();
        } else {
            hideIt();
            if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                g.woWaitFreeCats.showIt();
            } else {
                g.woNoFreeCats.showIt();
            }
        }
    }

    private function createBG():void {
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

    private function createPlantItems():void {
        var item:WOBuyPlantItem;
        _arrPlantItems = [];
        for (var i:int = 0; i < 5; i++) {
            item = new WOBuyPlantItem();
            item.source.x = -_woWidth/2 + 70 + i*107;
            item.source.y = -_woHeight/2 + 115;
            _source.addChild(item.source);
            _arrPlantItems.push(item);
        }
    }

    private function createShiftBtns():void {
        var item:WOFabricNumber;
        var n:int = 0;
        var i:int;
        _arrShiftBtns = [];
        for (i = 0; i < _arrAllPlants.length; i++) {
            if (_arrAllPlants[i].blockByLevel <= g.user.level) n++;
        }
        if ( n > 5 && n <= 10) {
            for (i= 0; i < 2; i++) {
                item = new WOFabricNumber(i+1);
                item.source.x = -_woWidth / 2 + 180 + i * (42);
                item.source.y = -_woHeight / 2 + 117;
                _source.addChildAt(item.source,0);
                _arrShiftBtns.push(item.source);
                item.source.endClickParams = i + 1;
                item.source.endClickCallback = activateShiftBtn;
            }
        } else if (n > 10 && n <= 15) {
            for (i= 0; i < 3; i++) {
                item = new WOFabricNumber(i+1);
                item.source.x = -_woWidth / 2 + 180 + i * (42);
                item.source.y = -_woHeight / 2 + 117;
                _source.addChildAt(item.source,0);
                _arrShiftBtns.push(item.source);
                item.source.endClickParams = i + 1;
                item.source.endClickCallback = activateShiftBtn;
            }
        } else if (n > 15 && n <= 20) {
            for (i= 0; i < 4; i++) {
                item = new WOFabricNumber(i+1);
                item.source.x = -_woWidth / 2 + 180 + i * (42);
                item.source.y = -_woHeight / 2 + 117;
                _source.addChildAt(item.source,0);
                _arrShiftBtns.push(item.source);
                item.source.endClickParams = i + 1;
                item.source.endClickCallback = activateShiftBtn;
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
            fillPlantItems();
        }
    }
}
}
