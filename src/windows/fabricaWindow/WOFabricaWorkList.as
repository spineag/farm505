/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import build.fabrica.Fabrica;
import com.junkbyte.console.Cc;
import resourceItem.ResourceItem;
import manager.Vars;
import starling.display.Sprite;
import windows.WindowsManager;

public class WOFabricaWorkList {
    public var maxCount:int;
    [ArrayElementType('windows.fabricaWindow.WOFabricaWorkListItem')]
    private var _arrItems:Array;
    public var arrRecipes:Array;
    private var _parent:Sprite;
    private var _fabrica:Fabrica;

    private var g:Vars = Vars.getInstance();

    public function WOFabricaWorkList(s:Sprite) {
        _parent = s;
        _arrItems = [];
        arrRecipes = [];
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
            maxCount = _fabrica.dataBuild.countCell;
            if (maxCount < 9) {
                var price:int = 6 + (maxCount - g.dataBuilding.objectBuilding[_fabrica.dataBuild.id].startCountCell)*3;
                _arrItems[maxCount].showBuyPropose(price, onBuyNewCell);
            }
            for (i=1; i<maxCount; i++) {
                _arrItems[i].source.visible = true;
            }
        } catch (e:Error) {
            Cc.error('WOFabricaWorkList fillit error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woFabricaWorkList');
        }
    }

    public function butNewCellFromWO():void {
        _arrItems[maxCount].removePropose();
        onBuyNewCell();
    }

    private function onBuyNewCell():void {
        maxCount++;
        _fabrica.onBuyNewCell();
        if (maxCount < 9) {
            var price:int = priceForNewCell;
            (_arrItems[maxCount] as WOFabricaWorkListItem).showBuyPropose(price, onBuyNewCell);
        }
    }

    public function onSkip():void {
        _fabrica.skipRecipe();
        var ar:Array = arrRecipes.slice(1); // don't use first recipe, because it was just skipped
        arrRecipes.length = 0;
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].unfillIt();
        }
        fillIt(ar, _fabrica);
    }

    public function get isFull():Boolean {
        return arrRecipes.length >= maxCount;
    }

    public function get priceForNewCell():int {
        return 6 + (maxCount - g.dataBuilding.objectBuilding[_fabrica.dataBuild.id].startCountCell)*3;
    }

    public function addResource(resource:ResourceItem, buy:Boolean = false):void {
        _arrItems[arrRecipes.length].fillData(resource, buy);
        arrRecipes.push(resource);
        if (arrRecipes.length == 1) {
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
            visibleSource();
        }
        arrRecipes.shift();
        if (arrRecipes.length) {
            for (i=0; i<arrRecipes.length; i++) {
                _arrItems[i].fillData(arrRecipes[i]);
            }
            activateTimer();
        }
    }

    private function visibleSource():void {
        if (maxCount < 9) {
            var price:int = 6 + (maxCount - g.dataBuilding.objectBuilding[_fabrica.dataBuild.id].startCountCell)*3;
            _arrItems[maxCount].showBuyPropose(price, onBuyNewCell);
        }
        for (var i:int=1; i<maxCount; i++) {
            _arrItems[i].source.visible = true;
        }
    }

    public function deleteIt():void {
        arrRecipes.length = 0;
        for (var i:int = 0; i < _arrItems.length; i++) {
            _parent.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        _fabrica = null;
        _parent = null;
    }

    public function getSkipBtnProperties():Object {
        if (_arrItems.length) {
            return _arrItems[0].getSkipBtnProperties();
        } else {
            return {};
        }
    }
}
}
