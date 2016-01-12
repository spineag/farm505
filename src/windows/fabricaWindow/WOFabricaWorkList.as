/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import build.fabrica.Fabrica;

import com.junkbyte.console.Cc;

import resourceItem.ResourceItem;
import manager.Vars;

import starling.display.Sprite;

public class WOFabricaWorkList {
    private var _maxCount:int;
    [ArrayElementType('windows.fabricaWindow.WOFabricaWorkListItem')]
    private var _arrItems:Array;
    private var _arrRecipes:Array;
    private var _parent:Sprite;
    private var _fabrica:Fabrica;

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

    public function fillIt(arrCurList:Array, fabrica:Fabrica):void {
        try {
            for (var i:int = 0; i < arrCurList.length; i++) {
                addResource(arrCurList[i]);
            }
            _fabrica = fabrica;
            _maxCount = _fabrica.dataBuild.countCell;
            if (_maxCount < 9) {
                var price:int = 6 + (_maxCount - g.dataBuilding.objectBuilding[_fabrica.dataBuild.id].startCountCell)*3;
                _arrItems[_maxCount].showBuyPropose(price, onBuyNewCell);
            }
            for (i=1; i<_maxCount; i++) {
                _arrItems[i].source.visible = true;
            }
        } catch (e:Error) {
            Cc.error('WOFabricaWorkList fillit error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    public function visibleSource():void {
        if (_maxCount < 9) {
            var price:int = 6 + (_maxCount - g.dataBuilding.objectBuilding[_fabrica.dataBuild.id].startCountCell)*3;
            _arrItems[_maxCount].showBuyPropose(price, onBuyNewCell);
        }
        for (var i=1; i<_maxCount; i++) {
            _arrItems[i].source.visible = true;
        }
    }

    public function butNewCellFromWO():void {
        _arrItems[_maxCount].removePropose();
        onBuyNewCell();
    }

    private function onBuyNewCell():void {
        _maxCount++;
        _fabrica.onBuyNewCell();
        if (_maxCount < 9) {
            var price:int = priceForNewCell;
            (_arrItems[_maxCount] as WOFabricaWorkListItem).showBuyPropose(price, onBuyNewCell);
        }
    }

    private function onSkip():void {
        _fabrica.skipRecipe();
        updateList();
    }

    private function updateList():void {
        var ar:Array = _arrRecipes.slice(1); // don't use first recipe, because it was just skipped
        _arrRecipes.length = 0;
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].unfillIt();
        }
        fillIt(ar, _fabrica);
    }

    public function get isFull():Boolean {
        return _arrRecipes.length >= _maxCount;
    }

    public function get priceForNewCell():int {
        return 6 + (_maxCount - g.dataBuilding.objectBuilding[_fabrica.dataBuild.id].startCountCell)*3;
    }

    public function addResource(resource:ResourceItem):void {
        _arrItems[_arrRecipes.length].fillData(resource);
        _arrRecipes.push(resource);
        if (_arrRecipes.length == 1) {
            activateTimer();
            _arrItems[0].skipCallback = onSkip;
        }
    }

    private function activateTimer():void {
        _arrItems[0].activateTimer(onFinishTimer);
    }

    private function onFinishTimer():void {
        var i:int;
        for (i=0; i<_arrItems.length; i++) {
            _arrItems[i].unfillIt();
//            _arrItems[i].visibleSource(true);
            visibleSource();
        }
        _arrRecipes.shift();
        if (_arrRecipes.length) {
            for (i=0; i<_arrRecipes.length; i++) {
                _arrItems[i].fillData(_arrRecipes[i]);
            }
            activateTimer();
        }
    }

    public function unfillIt():void {
        _arrRecipes.length = 0;
        if (_arrItems.length) _arrItems[0].destroyTimer();
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].unfillIt();
        }
        _fabrica = null;
    }

//    public function skipIt():void {
//        _arrItems[0].destroyTimer();
//        _arrItems[0].unfillIt();
//        onFinishTimer();
//    }
}
}
