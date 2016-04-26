/**
 * Created by user on 7/23/15.
 */
package windows.train {
import build.train.Train;
import data.BuildType;
import flash.geom.Point;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;
import utils.CButton;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTrain extends WindowMain {

    public static var CELL_RED:int = 1;
    public static var CELL_GREEN:int = 2;
    public static var CELL_BLUE:int = 3;
    public static var CELL_GRAY:int = 4;

    private var _woBG:WindowBackground;
    private var _rightBlock:Sprite;
    private var _leftBlock:Sprite;
    private var _arrItems:Array;
    private var _btnSend:CButton;
    private var _btnLoad:CButton;
    private var _btnHelp:CButton;
    private var _activeItemIndex: int;
    private var _build:Train;
    private var _txt:TextField;
    private var _txtCounter:TextField;
    private var _txtHelp:TextField;
    private var _counter:int;
    private var _idFree:int;
    private var _countFree:int;
    private var _txtCostItem:TextField;
    private var _txtXpItem:TextField;
    private var _txtCostAll:TextField;
    private var _txtXpAll:TextField;
    public var _imageItem:Image;
    private var _lock:int;
    private var _isBigCount:Boolean;
    private var _birka:Birka;
    private var _rightBlockBG:CartonBackground;
    private var _rightBlockCarton:CartonBackgroundIn;
    private var _rightBlockCarton2:CartonBackgroundIn;
    private var _leftBlockBG:CartonBackground;

    public function WOTrain() {
        super ();
        _windowType = WindowsManager.WO_TRAIN;
        _woWidth = 727;
        _woHeight = 529;
        _activeItemIndex = -1;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        createRightBlock();
        createLeftBlock();
        _arrItems = [];
        addItems();

        _btnSend = new CButton();
        _btnSend.addButtonTexture(120, 40, CButton.GREEN, true);
        _btnSend.x = _woWidth/2 - 180;
        _btnSend.y = 205;
        var txt:TextField = new TextField(89,62,"Отправить",g.allData.fonts['BloggerBold'],16,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        txt.x = 5;
        txt.y = -10;
        _btnSend.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_kor_ico'));
        im.y = -15;
        im.x = 88;
        _btnSend.addDisplayObject(im);
        _source.addChild(_btnSend);
        _btnSend.alpha = .5;

        _txt = new TextField(150, 40, '', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txt.x = 120;
        _txt.y = 110;
        _source.addChild(_txt);
        _txtCounter = new TextField(150, 40, '', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtCounter.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCounter.x = 110;
        _txtCounter.y = 130;
        _source.addChild(_txtCounter);
        _callbackClickBG = hideIt;
        _birka = new Birka('Корзинка', _source, _woWidth, _woHeight);
    }

    private function createRightBlock():void {
        var txt:TextField;
        var im:Image;
        _rightBlock = new Sprite();
        _rightBlock.y = -205;
        _rightBlock.x = 35;
        _source.addChild(_rightBlock);
        _rightBlockBG = new CartonBackground(287, 375);
        _rightBlockBG .filter = ManagerFilters.SHADOW;
        _rightBlock.addChild(_rightBlockBG);

        txt = new TextField(240, 50, 'Загрузите корзинку товаром и получите награду', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 25;
        txt.y = 5;
        txt.touchable = false;
        _rightBlock.addChild(txt);
        _rightBlockCarton = new CartonBackgroundIn(267, 68);
        _rightBlockCarton.y = 250;
        _rightBlockCarton.x = 10;
        _rightBlock.addChild(_rightBlockCarton);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        im.y = 325;
        im.x = 20;
        _rightBlock.addChild(im);

        _btnLoad = new CButton();
        _btnLoad.addButtonTexture(130, 36, CButton.YELLOW, true);
        txt = new TextField(80,30,'Загрузить', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 25;
        txt.y = 3;
        _btnLoad.addChild(txt);
        _btnLoad.x = 200;
        _btnLoad.y = 150;
        _rightBlock.addChild(_btnLoad);

        _btnHelp = new CButton();
        _btnHelp.addButtonTexture(240,52,CButton.BLUE,true);
        txt = new TextField(80,30,'', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnHelp.addChild(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_rup_ico'));
        im.y = -10;
        im.touchable = false;
        _btnHelp.addDisplayObject(im);
        _btnHelp.x = 143;
        _btnHelp.y = 210;
        _rightBlock.addChild(_btnHelp);
        _txtHelp = new TextField(180, 50, 'Помогите!!', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtHelp.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtHelp.x = 50;
        _btnHelp.addChild(_txtHelp);

        txt = new TextField(240,50,'Награда за полную загрузку:', g.allData.fonts['BloggerBold'], 15, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 240;
        txt.x = 23;
        txt.touchable = false;
        _rightBlock.addChild(txt);

        _txtCostItem = new TextField(40,30,'-3', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtCostItem.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCostItem.x = 226;
        _txtCostItem.y = 80;
        _txtCostItem.hAlign = HAlign.LEFT;
        _txtXpItem = new TextField(40,30,'-3', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtXpItem.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtXpItem.x = 155;
        _txtXpItem.y = 80;
        _txtXpItem.hAlign = HAlign.LEFT;
        _txtCostAll = new TextField(40,30,'-5', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtCostAll.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCostAll.x = 160;
        _txtCostAll.y = 280;
        _txtCostAll.hAlign = HAlign.LEFT;
        _txtXpAll = new TextField(40,30,'-5', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtXpAll.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtXpAll.x = 75;
        _txtXpAll.y = 280;
        _txtXpAll.hAlign = HAlign.LEFT;

        _rightBlock.addChild(_txtCostItem);
        _rightBlock.addChild(_txtXpItem);
        _rightBlock.addChild(_txtCostAll);
        _rightBlock.addChild(_txtXpAll);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 45;
        im.y = 280;
        MCScaler.scale(im,27,27);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = 125;
        im.y = 279;
        MCScaler.scale(im,30,30);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_cup_ico'));
        im.x = 205;
        im.y = 283;
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 130;
        im.y = 80;
        MCScaler.scale(im,27,27);
        _rightBlock.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = 200;
        im.y = 80;
        MCScaler.scale(im,30,30);
        _rightBlock.addChild(im);
        txt = new TextField(20,20,'1',g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 225;
        txt.y = 283;
        _rightBlock.addChild(txt);

        _rightBlockCarton2 = new CartonBackgroundIn(90, 90);
        _rightBlockCarton2.x = 20;
        _rightBlockCarton2.y = 70;
        _rightBlock.addChild(_rightBlockCarton2);
    }

    private function createLeftBlock():void {
        _leftBlock = new Sprite();
        _leftBlockBG = new CartonBackground(325, 430);
        _leftBlockBG.filter = ManagerFilters.SHADOW;
        _leftBlock.addChild(_leftBlockBG);
        _leftBlock.y = -205;
        _leftBlock.x = -_woWidth/2 + 40;
        _source.addChild(_leftBlock);
        var txt:TextField = new TextField(200,30,'Требуются продукты:', g.allData.fonts['BloggerBold'], 19, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.y = 15;
        txt.x = 60;
        _leftBlock.addChild(txt);
    }

    override public function showItParams(callback:Function, params:Array):void {
        var list:Array = params[0];
        _build = params[1];
        _counter = params[3];
            _txt.text = 'До отправления:';
                _isBigCount = list.length > 9;
                var type:int;
                for (var i:int = 0; i < list.length; i++) {
                    if (_isBigCount) type = int(i / 4);
                    else type = int(i / 3);
                    _arrItems[i].fillIt(list[i], i, type + 1);
                    _arrItems[i].clickCallback = onItemClick;
                }
                if (!_isBigCount) {
                    _arrItems[9].fillIt(null, 9, CELL_GRAY);
                    _arrItems[10].fillIt(null, 10, CELL_GRAY);
                    _arrItems[11].fillIt(null, 11, CELL_GRAY);
                }
            _txtCostAll.text = String(_build.allCoinsCount);
            _txtXpAll.text = String(_build.allXPCount);
            onItemClick(0);
            checkBtn();
            _txtCounter.text = TimeUtils.convertSecondsForHint(_counter);
            g.gameDispatcher.addToTimer(checkCounter);
            super.showIt();
    }

    private function checkCounter():void {
        _counter--;
        _txtCounter.text = TimeUtils.convertSecondsForHint(_counter);
    }

    private function addItems():void {
        var item:WOTrainItem;
        for (var i:int = 0; i < 12; i++) {
            item = new WOTrainItem();
            item.source.x = i%3 * 100 - 310;
            if(i >= 9) {
              item.source.y = 110;
            } else if (i >= 6) {
                item.source.y = 20;
            } else if (i >= 3) {
                item.source.y = -70;
            } else {
                item.source.y = -160;
            }
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function onItemClick(k:int):void {
        _activeItemIndex = k;
        _btnLoad.visible = true;
        _btnHelp.visible = true;
        for (var i:int = 0; i<_arrItems.length; i++) {
            _arrItems[i].activateIt(false);
        }
        _arrItems[_activeItemIndex].activateIt(true);
        if (_arrItems[k].isResourceLoaded) {
            _btnLoad.visible = false;
            _btnHelp.visible = false;
        } else {
            if (_arrItems[k].canFull()) {
                _btnLoad.clickCallback = onResourceLoad;
            } else  {
                _btnLoad.clickCallback = onClickBuy;
               _idFree = _arrItems[k].idFree;
               _countFree = _arrItems[k].countFree;
            }
        }

        _txtCostItem.text = String(_arrItems[_activeItemIndex].countCoins);
        _txtXpItem.text = String(_arrItems[_activeItemIndex].countXP);
        if (_imageItem) {
            _rightBlock.removeChild(_imageItem);
            _imageItem.dispose();
            _imageItem = null;
        }
        _imageItem = _arrItems[_activeItemIndex].currentImage();
        MCScaler.scale(_imageItem, 80, 80);
        _imageItem.x = 65 - _imageItem.width/2;
        _imageItem.y = 115 - _imageItem.height/2;
        _rightBlock.addChild(_imageItem);
    }

    private function onResourceLoad(lastResource:Boolean = false):void {
        if (_activeItemIndex == -1) return;
        if (!lastResource && _arrItems[_activeItemIndex].countFree == g.userInventory.getCountResourceById(_arrItems[_activeItemIndex].idFree)
                && g.dataResource.objectResources[_arrItems[_activeItemIndex].idFree].buildType == BuildType.PLANT ) {
            g.windowsManager.cashWindow = this;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_FOR_HARD, onResourceLoad, {id: _arrItems[_activeItemIndex].idFree}, 'market');
            return;
        }
        if (_arrItems[_activeItemIndex].canFull) {
            _arrItems[_activeItemIndex].fullIt();
        }
        updateItems();
        _btnLoad.visible = false;
    }

    private function updateItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].updateIt();
        }
    }

    private function onClickBuy():void {
        var ob:Object = {};
        ob.data = g.dataResource.objectResources[_idFree];
        ob.count = _countFree - g.userInventory.getCountResourceById(_idFree);
        g.windowsManager.cashWindow = this;
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onResourceLoad, 'train', ob);
    }

    private function checkBtn():void {
        if (g.isAway) {
            _btnSend.visible = false;
            return;
        }
        _btnSend.visible = true;
        _btnSend.clickCallback = null;
        var i:int;
        _lock = 0;
        for (i = 0; i<_arrItems.length; i++) {
            if (!_isBigCount && i == 9 || !_isBigCount && i == 10 || !_isBigCount && i == 11){
                _lock++;
            } else if (_arrItems[i].isResourceLoaded) {
                _lock++;
            }
        }
        if (_lock >= _arrItems.length || _lock == 0 || !_isBigCount && _lock <= 3) {
            _btnSend.alpha = 1;
        } else {
            _btnSend.alpha = .5;
            return;
        }
        _btnSend.alpha = 1;
        _btnSend.clickCallback = fullTrain;
    }

    private function fullTrain(b:Boolean = false):void {
        if (!b) {
            if (_lock == 0 || !_isBigCount && _lock <= 3) {
                g.windowsManager.cashWindow = this;
                super.hideIt();
//                deleteIt();
                g.windowsManager.openWindow(WindowsManager.WO_TRAIN_SEND, fullTrain);
                return;
            }
        }
        var p:Point = new Point(_btnSend.x, _btnSend.y);
        p = _btnSend.localToGlobal(p);
        (_build as Train).fullTrain(p,b);
        super.hideIt();
    }

    public function clearItems():void {
        for (var i:int = 0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        g.gameDispatcher.removeFromTimer(checkCounter);
        for (var i:int=0; i<_arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _rightBlock.removeChild(_rightBlockBG);
        _rightBlockBG.deleteIt();
        _rightBlockBG = null;
        _rightBlock.removeChild(_rightBlockCarton);
        _rightBlockCarton.deleteIt();
        _rightBlockCarton = null;
        _rightBlock.removeChild(_rightBlockCarton2);
        _rightBlockCarton2.deleteIt();
        _rightBlockCarton2 = null;
        _leftBlock.removeChild(_leftBlockBG);
        _leftBlockBG.deleteIt();
        _leftBlockBG = null;
        _arrItems.length = 0;
        _build = null;
        _txt = _txtCostAll = _txtCostItem = _txtCounter = _txtHelp = _txtXpAll = _txtXpItem = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_btnSend);
        _btnSend.deleteIt();
        _btnSend = null;
        _rightBlock.removeChild(_btnLoad);
        _btnLoad.deleteIt();
        _btnLoad = null;
        _rightBlock.removeChild(_btnHelp);
        _btnHelp.deleteIt();
        _btnHelp = null;
        _rightBlock = null;
        _leftBlock = null;
        _source.removeChild(_birka);
        _birka.deleteIt();
        _birka = null;
        super.deleteIt();
    }

}
}
