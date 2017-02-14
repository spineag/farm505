/**
/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import build.fabrica.Fabrica;
import com.junkbyte.console.Cc;
import data.BuildType;
import resourceItem.ResourceItem;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import windows.WOComponents.Birka;
import windows.WindowMain;
import windows.WindowsManager;

public class WOFabrica extends WindowMain {
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
        _windowType = WindowsManager.WO_FABRICA;
        _arrShiftBtns = [];
        _woHeight = 455;
        _woWidth = 580;
        _birka = new Birka('Фабрика', _source, 455, 580);
        _birka.flipIt();
        _birka.source.rotation = Math.PI/2;
        _callbackClickBG = onClickExit;
        createTopBG();
        createBottomBG();
        createFabricaItems();
        _list = new WOFabricaWorkList(_source,this);
    }

    private function onClickExit(e:Event = null):void {
        if (g.managerTutorial.isTutorial) return;
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        _fabrica = params[2];
        _callbackOnClick = callback;
        _arrAllRecipes = params[0];
        _shift = 0;
        fillFabricaItems();
        createShiftBtns();
        if (_arrShiftBtns.length > 0) activateShiftBtn(1, false);
        _list.fillIt(params[1], _fabrica);
        _birka.updateText(_fabrica.dataBuild.name);
        _birka.source.x = 270 - _birka.bg.height;
        showAnimateFabricaItems();
        if (params[3]) {
            addArrowForPossibleRawItems();
        }
        super.showIt();
    }

    private function createFabricaItems():void {
        var item:WOItemFabrica;
        _arrFabricaItems = [];
        for (var i:int = 0; i < 5; i++) {
            item = new WOItemFabrica();
            item.setCoordinates(-_woWidth/2 + 70 + i*107, -_woHeight/2 + 115);
            _source.addChild(item.source);
            _arrFabricaItems.push(item);
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

    private function showAnimateFabricaItems():void {
        var delay:Number = .1;
        for (var i:int = 0; i < _arrFabricaItems.length; i++) {
            (_arrFabricaItems[i] as WOItemFabrica).showAnimateIt(delay);
            delay += .1;
        }
    }

    private function animateChangeFabricaItems():void {
        var arr:Array = [];
        for (var i:int=0; i<5; i++) {
            if (_arrAllRecipes[_shift*5 + i]) {
                arr.push(_arrAllRecipes[_shift*5 + i]);
            } else {
                break;
            }
        }
        var delay:Number = .1;
        for (i = 0; i < _arrFabricaItems.length; i++) {
            if (arr[i]) {
                (_arrFabricaItems[i] as WOItemFabrica).showChangeAnimate(delay, arr[i], onItemClick);
            } else {
                (_arrFabricaItems[i] as WOItemFabrica).showChangeAnimate(delay, null, null);
            }
            delay += .1;
        }
    }

    private function onBuyResource(obj:Object, lastRes:Boolean = false):void {
//        super.showIt();
        onItemClick(obj, lastRes);
    }

    private function onItemClick(dataRecipe:Object, lastRes:Boolean = false):void {
        var obj:Object;
        if (!lastRes) {
                var fExit:Function = function():void {
                    g.windowsManager.uncasheWindow();
                };
                if (_list.arrRecipes.length == 9) {
                        g.windowsManager.cashWindow = this;
                        super.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_NO_PLACES, onBuyNewCellFromWO, g.managerTimerSkip.newCount(_list.arrRecipes[0].buildTime, _list.arrRecipes[0].leftTime, _list.arrRecipes[0].priceSkipHard),_list.arrRecipes[0].resourceID, fExit, true);
                    return;
                } else if (_list.arrRecipes.length == _list.maxCount){
                        g.windowsManager.cashWindow = this;
                        super.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_NO_PLACES, onBuyNewCellFromWO, _list.priceForNewCell, 0, fExit, false);
                    return;
                }
            if (!_fabrica.heroCat && g.managerCats.countFreeCats <= 0) {
                isCashed = false;
                super.hideIt();
                if (g.managerCats.curCountCats == g.managerCats.maxCountCats) {
                    g.windowsManager.openWindow(WindowsManager.WO_WAIT_FREE_CATS);
                } else {
                    g.windowsManager.openWindow(WindowsManager.WO_NO_FREE_CATS);
                }
                return;
            }

            var count:int = 0;
            if (!dataRecipe || !dataRecipe.ingridientsId) {
                Cc.error('UserInventory checkRecipe:: bad _data');
                isCashed = false;
                super.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woFabrica');
                return;
            }
            var i:int;
            for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
                count = g.userInventory.getCountResourceById(int(dataRecipe.ingridientsId[i]));
                if (count < int(dataRecipe.ingridientsCount[i])) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    obj = {};
                    obj.data = dataRecipe;
                    obj.count = int(dataRecipe.ingridientsCount[i]) - count;
//                    obj.fabrica = _fabrica;
//                    obj.callback = _callbackOnClick;
                    g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onBuyResource, 'menu', obj);
                    return;
                }
            }

            for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
                count = g.userInventory.getCountResourceById(int(dataRecipe.ingridientsId[i]));
                if (g.dataResource.objectResources[dataRecipe.ingridientsId[i]].buildType == BuildType.PLANT && count == int(dataRecipe.ingridientsCount[i]) && !g.userInventory.checkLastResource(dataRecipe.ingridientsId[i])) {
                    obj = {};
                    obj.data = dataRecipe;
                    obj.fabrica = _fabrica;
                    obj.callback = _callbackOnClick;
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onBuyResource, dataRecipe, 'fabrica', obj);
                    return;
                }
            }
        }
        var resource:ResourceItem = new ResourceItem();
        resource.fillIt(g.dataResource.objectResources[dataRecipe.idResource]);
        _list.addResource(resource, true);
        g.fabricHint.updateItem();
        if (_callbackOnClick != null) {
            _callbackOnClick.apply(null, [resource, dataRecipe]);
        }
    }

    private function onBuyNewCellFromWO():void { // or skip first cell if we can't buy cell
        if (_fabrica.dataBuild.countCell >= 9) {
            _list.onSkip();
        } else {
            _list.butNewCellFromWO();
        }
//        showIt();
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
        _topBG.x = -_woWidth/2;
        _topBG.y = -_woHeight/2 + 80;
        _source.addChild(_topBG);
    }

    private function createShiftBtns():void {
        var item:WOFabricNumber;
        var n:int = 0;
        var i:int;
        for (i = 0; i < _arrAllRecipes.length; i++) {
            if (_arrAllRecipes[i].blockByLevel <= g.user.level) n++;
        }
        if ( n > 5 && n <= 10) {
            for (i= 0; i < 2; i++) {
                item = new WOFabricNumber(i+1);
                item.source.x = -_woWidth / 2 + 220 + i * (42);
                item.source.y = -_woHeight / 2 + 117;
                _source.addChildAt(item.source,1);
                _arrShiftBtns.push(item);
                item.source.endClickParams = i + 1;
                item.source.endClickCallback = activateShiftBtn;
            }
        } else if (n > 10 && n <= 15) {
            for (i= 0; i < 3; i++) {
                item = new WOFabricNumber(i+1);
                item.source.x = -_woWidth / 2 + 220 + i * (42);
                item.source.y = -_woHeight / 2 + 117;
                _source.addChildAt(item.source,1);
                _arrShiftBtns.push(item);
                item.source.endClickParams = i + 1;
                item.source.endClickCallback = activateShiftBtn;
            }
        } else if (n > 15 && n <= 20) {
            for (i= 0; i < 4; i++) {
                item = new WOFabricNumber(i+1);
                item.source.x = -_woWidth / 2 + 220 + i * (42);
                item.source.y = -_woHeight / 2 + 117;
                _source.addChildAt(item.source,1);
                _arrShiftBtns.push(item);
                item.source.endClickParams = i + 1;
                item.source.endClickCallback = activateShiftBtn;
            }
        }
    }

    private function activateShiftBtn(n:int, needUpdate:Boolean = true):void {
        for (var i:int=0; i<_arrShiftBtns.length; i++) {
            _arrShiftBtns[i].source.y = -_woHeight/2 + 117;
        }

        _arrShiftBtns[n-1].source.y += 8;
        _shift = n-1;
        if (needUpdate) {
            animateChangeFabricaItems();
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
        _bottomBG.x = -_bottomBG.width/2;
        _bottomBG.y = -_woHeight/2 + 260;
        _source.addChild(_bottomBG);
    }

    public function getSkipBtnProperties():Object {
        return _list.getSkipBtnProperties();
    }
    
    public function addArrowForPossibleRawItems():void {
        for (var i:int=0; i<_arrFabricaItems.length; i++) {
            (_arrFabricaItems[i] as WOItemFabrica).addArrowIfPossibleToRaw();
        }
    }

    override protected function deleteIt():void {
        for (var i:int=0; i<_arrShiftBtns.length; i++) {
            _source.removeChild(_arrShiftBtns[i].source);
            _arrShiftBtns[i].deleteIt();
        }
        _arrShiftBtns.length = 0;
        for (i = 0; i < _arrFabricaItems.length; i++) {
            _source.removeChild(_arrFabricaItems[i].source);
            _arrFabricaItems[i].deleteIt();
        }
        _arrFabricaItems.length = 0;
        if (_list) _list.deleteIt();
        _list = null;
        _fabrica = null;
        _topBG = null;
        _bottomBG = null;
        _callbackOnClick = null;
        _arrAllRecipes.length = 0;
        super.deleteIt();
    }
}
}
