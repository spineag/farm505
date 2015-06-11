/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import manager.ResourceItem;
import manager.Vars;

import starling.display.Quad;
import starling.display.Sprite;

public class WOFabricaWorkList {
    private var _bg:Quad;
    private var _maxCount:int;
    private var _arrItems:Array;
    private var _arrRecipes:Array;
    private var _parent:Sprite;

    private var g:Vars = Vars.getInstance();

    public function WOFabricaWorkList(s:Sprite) {
        _parent = s;
        _arrItems = [];
        _arrRecipes = [];
        _bg = new Quad(450, 120, 0x6fa9ce);
        _bg.x = - 450/2;
        _bg.y = 75;
        _parent.addChild(_bg);
    }

    private function createItems():void {
        var item:WOFabricaWorkListItem;

        for (var i:int = 0; i < 3; i++) { // вместо 3 будет _maxCount
            item = new WOFabricaWorkListItem();
            item.source.x = -105 + 105*i;
            item.source.y = 135;
            _parent.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function destroyItems():void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            _parent.removeChild(_arrItems[i].source);
        }
        _arrItems.length = 0;
        _arrRecipes.length = 0;
    }

    public function get isFull():Boolean {
        return _arrRecipes.length >= _maxCount;
    }

    public function fillIt(arrCurList:Array, maxCount:int):void {
        _maxCount = maxCount;
        destroyItems();
        createItems();
        for (var i:int = 0; i < arrCurList.length; i++) {
            addResource(arrCurList[i]);
        }
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
        destroyItems();

    }
}
}
