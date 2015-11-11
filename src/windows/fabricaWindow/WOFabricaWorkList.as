/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import com.junkbyte.console.Cc;

import resourceItem.ResourceItem;
import manager.Vars;

import starling.display.Quad;
import starling.display.Sprite;

public class WOFabricaWorkList {
    private var _maxCount:int;
    private var _arrItems:Array;
    private var _arrRecipes:Array;
    private var _parent:Sprite;

    private var g:Vars = Vars.getInstance();

    public function WOFabricaWorkList(s:Sprite) {
        _parent = s;
        _arrItems = [];
        _arrRecipes = [];
        createItems();
    }

    private function createItems():void {
        var item:WOFabricaWorkListItem;
        item = new WOFabricaWorkListItem(WOFabricaWorkListItem.BIG_CELL);
        item.source.x = -165;
        item.source.y = 50;
        _parent.addChild(item.source);
        _arrItems.push(item);
        for (var i:int = 0; i < 8; i++) {
            item = new WOFabricaWorkListItem();
            item.source.x = -50 + (i%4)*55;
            item.source.y = 50 + int(i/4)*53;
            _parent.addChild(item.source);
            _arrItems.push(item);
        }
    }

    public function fillIt(arrCurList:Array, maxCount:int):void {
        try {
            for (var i:int = 0; i < arrCurList.length; i++) {
                addResource(arrCurList[i]);
            }
            _maxCount = maxCount;
            if (_maxCount < 9) {
                (_arrItems[_maxCount] as WOFabricaWorkListItem).showBuyPropose(12);
            }
            for (i=1; i<_maxCount; i++) {
                _arrItems[i].source.visible = true;
            }
        } catch (e:Error) {
            Cc.error('WOFabricaWorkList fillit error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    public function get isFull():Boolean {
        return _arrRecipes.length >= _maxCount;
    }

    public function addResource(resource:ResourceItem):void {
        _arrItems[_arrRecipes.length].fillData(resource, null);
        _arrRecipes.push(resource);
        if (_arrRecipes.length == 1) {
            activateTimer();
        }
    }

    private function activateTimer():void {
        _arrItems[0].activateTimer(onFinishTimer);
    }

    private function onFinishTimer():void {
        var i:int;

        for (i=0; i<_arrItems.length; i++) {
            _arrItems[i].unfillIt();
        }
        _arrRecipes.shift();
        if (_arrRecipes.length) {
            for (i=0; i<_arrRecipes.length; i++) {
                _arrItems[i].fillData(_arrRecipes[i], null);
            }
            activateTimer();
        }
    }

    public function unfillIt():void {
        if (_arrItems.length) _arrItems[0].destroyTimer();
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].unfillIt();
        }
        _arrRecipes.length = 0;

    }

    public function skipIt():void {
        var i:int;
        _arrItems[0].destroyTimer();
        _arrItems[0].unfillIt();
        onFinishTimer();

//        _arrItems[0] = null;
//        _arrRecipes[0] = null;
//        if (_arrRecipes.length) {
//            for (i = 0; i < _arrRecipes.length; i++) {
//                _arrItems[i].fillData(_arrRecipes[i], null);
//            }
//        }
    }
}
}
