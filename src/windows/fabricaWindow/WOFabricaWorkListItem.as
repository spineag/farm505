/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import com.junkbyte.console.Cc;
import data.DataMoney;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;
import manager.ManagerFilters;
import resourceItem.RawItem;
import resourceItem.ResourceItem;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import tutorial.TutorialAction;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WindowsManager;

public class WOFabricaWorkListItem {
    public static const BIG_CELL:String = 'big';
    public static const SMALL_CELL:String = 'small';

    private var _source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _resource:ResourceItem;
    private var _txtTimer:CTextField;
    private var _timerFinishCallback:Function;
    private var _txtNumberCreate:CTextField;
    private var _type:String;
    private var _timerBlock:Sprite;
    private var _btnSkip:CButton;
    private var _txtSkip:CTextField;
    private var _proposeBtn:CButton;
    private var _skipCallback:Function;
    private var _rubinSmall:Image;
    private var _txt:CTextField;
    private var _priceSkip:int;
    private var g:Vars = Vars.getInstance();

    public function WOFabricaWorkListItem(type:String = 'small') {
        _type = type;
        _source = new CSprite();
        _txtNumberCreate = new CTextField(20,20,"");
        if (type == SMALL_CELL) {
            _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_blue_d'));
            MCScaler.scale(_bg, 50, 50);
            _txtNumberCreate.setFormat(CTextField.BOLD14, 13, Color.WHITE, ManagerFilters.BLUE_COLOR);
        } else {
            _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_k'));
            _txtNumberCreate.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        }
        _source.addChild(_bg);

        if (type == SMALL_CELL) {
            _source.visible = false;
            _txt = new CTextField(50, 30, 'пусто');
            _txt.setFormat(CTextField.BOLD18, 15, ManagerFilters.LIGHT_BROWN);
            _txt.x = -1;
            _txt.y = 5;
            source.addChild(_txt);
        }

        if (_type == BIG_CELL) {
            _timerBlock = new Sprite();
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_clock'));
            im.x = 13;
            im.y = -20;
            _timerBlock.addChild(im);
            _txtTimer = new CTextField(78, 33, '');
            _txtTimer.setFormat(CTextField.BOLD18, 18, Color.WHITE);
            _txtTimer.x = 13;
            _txtTimer.y = -20;
            _timerBlock.addChild(_txtTimer);
            _source.addChild(_timerBlock);
            _timerBlock.visible = false;
            _txt = new CTextField(100, 90, 'загрузите ячейку очереди');
            _txt.setFormat(CTextField.BOLD18, 18, ManagerFilters.LIGHT_BROWN);
            _txt.x = 2;
            _txt.y = 5;
            _source.addChild(_txt);
            _btnSkip = new CButton();
            _btnSkip.addButtonTexture(120, 40, CButton.GREEN, true);
            _txtSkip = new CTextField(100,35,"25");
            _txtSkip.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _txtSkip.y = 11;
            _btnSkip.addChild(_txtSkip);
            _rubinSmall = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            _rubinSmall.x = 78;
            _rubinSmall.y = 5;
            _btnSkip.addChild(_rubinSmall);
            _rubinSmall.filter = ManagerFilters.SHADOW_TINY;
            _btnSkip.x = 52;
            _btnSkip.y = 117;
            var txt:CTextField = new CTextField(65,35,"ускорить");
            txt.setFormat(CTextField.BOLD14, 14, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            txt.x = 10;
            txt.y = -8;
            _btnSkip.addChild(txt);
            _source.addChild(_btnSkip);
            _btnSkip.visible = false;
            _btnSkip.clickCallback = makeSkip;
        }
        _txt.alpha = .5;
    }

    public function get source():Sprite {
        return _source;
    }

    public function fillData(resource:ResourceItem, buy:Boolean = false):void {
        _resource = resource;
        if (!_resource) {
            Cc.error('WOFabricaWorkListItem fillData:: _resource == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'WoFabricaWorkListItem');
            return;
        }
        if (_type == BIG_CELL) {
            _btnSkip.visible = true;
            if (g.managerTutorial.isTutorial)  _txtSkip.text = String(0);
            else {
                _txtSkip.text = String(g.managerTimerSkip.newCount(_resource.buildTime, _resource.leftTime, _resource.priceSkipHard));
                _priceSkip = g.managerTimerSkip.newCount(_resource.buildTime, _resource.leftTime, _resource.priceSkipHard);
            }
        }
        fillIcon(_resource.imageShop, buy);
        _source.visible = true;
    }

    private function fillIcon(s:String, buy:Boolean = false):void {
        if (_icon) {
            _source.removeChild(_icon);
            _icon = null;
        }

        var onFinish:Function = function():void {
            WorldClock.clock.remove(arm);
            arm.removeEventListener(EventObject.COMPLETE, onFinish);
            arm.removeEventListener(EventObject.LOOP_COMPLETE, onFinish);
            _source.removeChild(arm.display as StarlingArmatureDisplay);
            if (g.managerTutorial) {
//                removeArrow();
                g.managerTutorial.checkTutorialCallback();
            }
        };
        if (buy) {
            var arm:Armature;
            arm = g.allData.factory['explode_gray_fabric'].buildArmature("expl_fabric");
            (arm.display as StarlingArmatureDisplay).x = _bg.width / 2;
            (arm.display as StarlingArmatureDisplay).y = _bg.height;
            if (_type == SMALL_CELL) {
                (arm.display as StarlingArmatureDisplay).scale = .5;
            }
            WorldClock.clock.add(arm);
            _source.addChild(arm.display as StarlingArmatureDisplay);
            arm.addEventListener(EventObject.COMPLETE, onFinish);
            arm.addEventListener(EventObject.LOOP_COMPLETE, onFinish);
            arm.animation.gotoAndPlayByFrame("idle");
        }

        _icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(s));
        if (_type == BIG_CELL) {
            MCScaler.scale(_icon, 85, 100);
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
        _source.addChildAt(_icon,1);
        if (_type == BIG_CELL) {
            _txtNumberCreate.x = 75;
            _txtNumberCreate.y = 70;
        } else {
            _txtNumberCreate.x = 27;
            _txtNumberCreate.y = 25;
            _source.hoverCallback =  function():void {
                g.hint.showIt("в очереди");
            };
            _source.outCallback =  function():void {
                g.hint.hideIt();
            };
        }
        _source.addChild(_txtNumberCreate);
        _txt.visible = false;
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
            _txtTimer.text = TimeUtils.convertSecondsToStringClassic(_resource.leftTime);
        } else {
            Cc.error('WOFabricaWorkListItem activateTimer:: ');
        }
    }

    private function render():void {
        if (!_resource) return;
        if (_resource.leftTime <= 0) {
            g.gameDispatcher.removeFromTimer(render);
            _txtTimer.text = '';
            _timerBlock.visible = false;
            _btnSkip.visible = false;
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.FABRICA_SKIP_RECIPE) {
                g.managerTutorial.checkTutorialCallback();
            }
            if (_timerFinishCallback != null) {
                _timerFinishCallback.apply();
            }
        } else {
            _txtTimer.text = TimeUtils.convertSecondsToStringClassic(_resource.leftTime);
        }
    }

    public function showBuyPropose(buyCount:int, callback:Function):void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        if (_type == SMALL_CELL) {
            _source.visible = true;
            _txt.visible = false;
            if (_proposeBtn) return;
            _proposeBtn = new CButton();
            var txt:CTextField = new CTextField(46, 28, "+");
            txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
            _proposeBtn.addChild(txt);
            txt = new CTextField(46, 28, String(buyCount));
            txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
            txt.y = 20;
            txt.x = -10;
            _proposeBtn.addChild(txt);
            _rubinSmall = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            MCScaler.scale(_rubinSmall, 20, 20);
            _rubinSmall.x = 23;
            _rubinSmall.y = 23;
            _rubinSmall.filter = ManagerFilters.SHADOW_TINY;
            _proposeBtn.addChild(_rubinSmall);
            _source.addChild(_proposeBtn);
            var f1:Function = function ():void {
                _proposeBtn.filter = null;
                if (g.user.hardCurrency >= buyCount) {
                    if (callback != null) {
                        callback.apply();
                    }
                    unfillIt();
                    _txt.visible = true;
                    _source.visible = true;
                    var p:Point = new Point(_source.width / 2, _source.height / 2);
                    p = _source.localToGlobal(p);
                    new RawItem(p, g.allData.atlas['interfaceAtlas'].getTexture('rubins'), buyCount, 0);
                    g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -buyCount);
                } else {
//                    g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
                    g.windowsManager.closeAllWindows();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
                }
            };
            _proposeBtn.clickCallback = f1;
            _proposeBtn.hoverCallback = function():void {
                _proposeBtn.filter = ManagerFilters.BUILDING_HOVER_FILTER;
                    g.hint.showIt("докупить ячейку");
            };
            _proposeBtn.outCallback = function():void {
                _proposeBtn.filter = null;
                g.hint.hideIt();
            };
        }
    }

    public function removePropose():void {
        unfillIt();
        _source.visible = true;
    }

    private function makeSkip():void {
        if (g.managerTutorial.isTutorial) {
            if (_skipCallback != null) {
                destroyTimer();
                _btnSkip.visible = false;
                _skipCallback.apply();
            }
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.FABRICA_SKIP_RECIPE) {
                g.managerTutorial.checkTutorialCallback();
            }
            return;
        }
        if (g.user.hardCurrency >= _priceSkip) {
            if (_skipCallback != null) {
                g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_priceSkip);
                destroyTimer();
                _btnSkip.visible = false;
                _skipCallback.apply();
            }
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.FABRICA_SKIP_RECIPE) {
                g.managerTutorial.checkTutorialCallback();
            }
        } else {
            g.windowsManager.hideWindow(WindowsManager.WO_FABRICA);
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
        }
    }

    public function set skipCallback(f:Function):void {
        _skipCallback = f;
    }

    public function getSkipBtnProperties():Object {
        var ob:Object = {};
        ob.x = _btnSkip.x - _btnSkip.width/2;
        ob.y = _btnSkip.y - _btnSkip.height/2;
        var p:Point = new Point(ob.x, ob.y);
        p = _source.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = _btnSkip.width;
        ob.height = _btnSkip.height;
        return ob;
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
        } else {
            _txtSkip.text = '';
            _btnSkip.visible = false;
        }
        _txt.visible = true;
    }

    public function deleteIt():void {
        if (_proposeBtn) {
            _source.removeChild(_proposeBtn);
            _proposeBtn.deleteIt();
            _proposeBtn = null;
        }
        if (_btnSkip) {
            _source.removeChild(_btnSkip);
            _btnSkip.deleteIt();
            _btnSkip = null;
        }
        if (_rubinSmall) _rubinSmall.filter = null;
        g.gameDispatcher.removeFromTimer(render);
        _source.dispose();
        _source = null;
        _timerFinishCallback = null;
        _skipCallback = null;
        if (_resource) {
            _resource = null;
        }
    }

}
}
