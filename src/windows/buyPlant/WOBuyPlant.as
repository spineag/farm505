/**
 * Created by user on 6/2/15.
 */
package windows.buyPlant {
import build.ridge.Ridge;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.filters.GlowFilter;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import windows.WOComponents.Birka;
import windows.Window;

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
        createShiftBtns();
        createPlantItems();
        callbackClickBG = onClickExit;
//        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('btn_exit'), '', g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_click'), g.allData.atlas['interfaceAtlas'].getTexture('btn_exit_hover'));
//        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        callbackClickBG = hideIt;
        _arrAllPlants = [];

        _birka = new Birka('Огород', _source, 455, 580);
        _birka.flipIt();
        _birka.source.rotation = Math.PI/2;
        _birka.source.x = 80;
        _birka.source.y = 150;
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    override public function hideIt():void {
        unfillPlantItems();
        _callback = null;
        _ridge = null;
        super.hideIt();
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
        activateShiftBtn(1, false);
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
            if (arr[i].blockByLevel + 1 <= g.user.level)
                _arrPlantItems[i].fillData(arr[i], onClickItem);
        }
    }

    private function unfillPlantItems():void {
        for (var i:int = 0; i < _arrPlantItems.length; i++) {
            _arrPlantItems[i].unfillIt();
        }
    }

    private function onClickItem(d:Object):void {
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
        var s:CSprite;
        var im:Image;
        var txt:TextField;

        _arrShiftBtns = [];
        for (var i:int=0; i<4; i++) {
            s = new CSprite();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_bt_number'));
            s.addChild(im);
            txt = new TextField(32, 32, String(i+1), g.allData.fonts['BloggerBold'], 22,0x009bff);
            txt.nativeFilters = [new GlowFilter(Color.WHITE, 1, 6, 6, 5.0)];
            txt.y = 20;
            txt.x = 2;
            s.addChild(txt);
            s.flatten();
            s.x = -_woWidth/2 + 180 + i*(42);
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
            fillPlantItems();
        }
    }
}
}
