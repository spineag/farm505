/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {

import com.junkbyte.console.Cc;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import resourceItem.RawItem;
import resourceItem.ResourceItem;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;

public class WOFabricaWorkListItem {
    public static const BIG_CELL:String = 'big';
    public static const SMALL_CELL:String = 'small';

    private var _source:Sprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _resource:ResourceItem;
    private var _txtTimer:TextField;
    private var _timerFinishCallback:Function;
    private var _txtNumberCreate:TextField;
    private var _type:String;
    private var _timerBlock:Sprite;
    private var _btnSkip:CButton;
    private var _txtSkip:TextField;
    private var _proposeBtn:CSprite;
    private var _skipCallback:Function;

    private var g:Vars = Vars.getInstance();

    public function WOFabricaWorkListItem(type:String = 'small') {
        _type = type;
        _source = new CSprite();
        if (type == SMALL_CELL) {
            _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_blue_d'));
            MCScaler.scale(_bg, 50, 50);
            _txtNumberCreate = new TextField(20,20,"",g.allData.fonts['BloggerRegular'], 13,ManagerFilters.TEXT_BROWN);
        } else {
            _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_k'));
            _txtNumberCreate = new TextField(20,20,"",g.allData.fonts['BloggerRegular'], 16,ManagerFilters.TEXT_BROWN);
        }
        _source.addChild(_bg);
        if (type == SMALL_CELL) {
            _source.visible = false;
        }

        if (_type == BIG_CELL) {
            _timerBlock = new Sprite();
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_clock'));
            im.x = 13;
            im.y = -20;
            _timerBlock.addChild(im);
            _txtTimer = new TextField(78, 33, '', g.allData.fonts['BloggerRegular'], 18, Color.WHITE);
            _txtTimer.x = 13;
            _txtTimer.y = -20;
            _timerBlock.addChild(_txtTimer);
            _source.addChild(_timerBlock);
            _timerBlock.visible = false;

            _btnSkip = new CButton();
            _btnSkip.addButtonTexture(120, 40, CButton.GREEN, true);
            _txtSkip = new TextField(100,35,"25",g.allData.fonts['BloggerBold'], 22, Color.WHITE);
            _txtSkip.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _txtSkip.y = 2;
            _btnSkip.addChild(_txtSkip);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            MCScaler.scale(im, 30, 30);
            im.x = 72;
            im.y = 5;
            _btnSkip.addChild(im);
            im.filter = ManagerFilters.SHADOW_TINY;
            _btnSkip.x = 52;
            _btnSkip.y = 117;
            _source.addChild(_btnSkip);
            _btnSkip.visible = false;
            _btnSkip.clickCallback = makeSkip;
        }
    }

    public function get source():Sprite {
        return _source;
    }

    public function fillData(resource:ResourceItem):void {
        _resource = resource;
        if (_type == BIG_CELL) {
            _txtSkip.text = String(_resource.priceSkipHard);
        }
        if (!_resource) {
            Cc.error('WOFabricaWorkListItem fillData:: _resource == null');
            g.woGameError.showIt();
            return;
        }
        fillIcon(_resource.imageShop);
        _source.visible = true;
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            _source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(s));
        if (_type == BIG_CELL) {
            MCScaler.scale(_icon, 100, 100);
            _icon.x = 53 - _icon.width/2;
            _icon.y = 53 - _icon.height/2;
        } else {
            MCScaler.scale(_icon, 44, 44);
            _icon.x = 23 - _icon.width/2;
            _icon.y = 22 - _icon.height/2;
        }
        for(var id:String in g.dataRecipe.objectRecipe){
            if(g.dataRecipe.objectRecipe[id].idResource == _resource.resourceID){
                if(g.dataRecipe.objectRecipe[id].numberCreate > 1) {
                    _txtNumberCreate.text = String(g.dataRecipe.objectRecipe[id].numberCreate);
                    break;
                }
                else _txtNumberCreate.text = "";
            }
        }
        _source.addChild(_icon);
        if (_type == BIG_CELL) {
            _txtNumberCreate.x = 75;
            _txtNumberCreate.y = 70;
        } else {
            _txtNumberCreate.x = 27;
            _txtNumberCreate.y = 25;
        }
        _source.addChild(_txtNumberCreate);
    }

    public function unfillIt():void {
        if (_icon) {
            _txtNumberCreate.text = "";
            _source.removeChild(_txtNumberCreate);
            _source.removeChild(_icon);
            _icon = null;
        }
        _resource = null;
        _skipCallback = null;
        if (_type == SMALL_CELL) {
            _source.visible = false;
            if (_proposeBtn) {
                _source.removeChild(_proposeBtn);
                _proposeBtn.deleteIt();
                _proposeBtn = null;
            }
        }
    }

    public function destroyTimer():void {
        g.gameDispatcher.removeFromTimer(render);
        _timerFinishCallback = null;
        _txtTimer.text = '';
        _timerBlock.visible = false;
    }

    public function activateTimer(f:Function):void {
        if (_type == BIG_CELL) {
            _timerFinishCallback = f;
            g.gameDispatcher.addToTimer(render);
            _timerBlock.visible = true;
            _btnSkip.visible = true;
        } else {
            Cc.error('WOFabricaWorkListItem activateTimer:: ');
        }
    }

    private function render():void {
        if (!_resource) return;
        _txtTimer.text = TimeUtils.convertSecondsToStringClassic(_resource.leftTime);
        if (_resource.leftTime <= 0) {
            g.gameDispatcher.removeFromTimer(render);
            _txtTimer.text = '';
            _timerBlock.visible = false;
            _btnSkip.visible = false;
            if (_timerFinishCallback != null) {
                _timerFinishCallback.apply();
            }
        }
    }

    public function showBuyPropose(buyCount:int, callback:Function):void {
        if (_type == SMALL_CELL) {
            _source.visible = true;
            _proposeBtn = new CSprite();
            var txt:TextField = new TextField(46, 28, "+" + String(buyCount), g.allData.fonts['BloggerBold'], 16, Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _proposeBtn.addChild(txt);
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            MCScaler.scale(im, 20, 20);
            im.x = 14;
            im.y = 23;
            im.filter = ManagerFilters.SHADOW_TINY;
            _proposeBtn.addChild(im);
            _proposeBtn.flatten();
            _source.addChild(_proposeBtn);
            var f1:Function = function ():void {
                if (g.user.hardCurrency >= buyCount) {
                    if (callback != null) {
                        callback.apply();
                    }
                    unfillIt();
                    _source.visible = true;
                    var p:Point = new Point(_source.width / 2, _source.height / 2);
                    p = _source.localToGlobal(p);
                    new RawItem(p, g.allData.atlas['interfaceAtlas'].getTexture('rubins'), buyCount, 0);
                    g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -buyCount);
                } else {
                    g.woFabrica.onClickExit();
                    g.woBuyCurrency.showItMenu(true);
                }
            };
            _proposeBtn.endClickCallback = f1;
        }
    }

    public function removePropose():void {
        unfillIt();
        _source.visible = true;
    }

    private function makeSkip():void {
        if (g.user.hardCurrency >= _resource.priceSkipHard) {
            if (_skipCallback != null) {
                g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_resource.priceSkipHard);
                destroyTimer();
                _btnSkip.visible = false;
                _skipCallback.apply();
            }
        } else {
            g.woBuyCurrency.showItMenu(true);
        }
    }

    public function set skipCallback(f:Function):void {
        _skipCallback = f;
    }

}
}
