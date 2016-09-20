/**
 * Created by user on 6/11/15.
 */
package hint {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CButton;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class WildHint {
    private var _source:CSprite;
    private var _btn:CButton;
    private var _isShowed:Boolean;
    private var _isOnHover:Boolean;
    private var _circle:Image;
    private var _bgItem:Image;
    private var _iconResource:Image;
    private var _txtCount:CTextField;
    private var _txtName:CTextField;
    private var _deleteCallback:Function;
    private var _id:int;
    private var _height:int;
    private var _closeTime:Number;
    private var bg:HintBackground;
    private var g:Vars = Vars.getInstance();
    private var _quad:Quad;
    private var _buildType:int;
    private var _onOutCallback:Function;

    public function WildHint() {
        _source = new CSprite();
        _source.nameIt = 'wildHint';
        _btn = new CButton();
        _isShowed = false;
        _isOnHover = false;
        bg = new HintBackground(120, 104, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _source.addChild(bg);
        _source.addChild(_btn);
        _bgItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_blue_d'));
//        _bgItem.x = -_bgItem.width/2;
//        _bgItem.y = -_bgItem.height - 35;
        _btn.addDisplayObject(_bgItem);
        _circle = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_number_circle'));
        _txtCount = new CTextField(30,30,"");
        _txtCount.setFormat(CTextField.BOLD18, 16, Color.WHITE);
        _txtName = new CTextField(100,50,"");
        _txtName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.x = -50;
        _txtName.y = -150;
        _circle.x = +_bgItem.width/2 -20;
        _circle.y = -_bgItem.height - 50;
        _source.addChild(_circle);
        _source.addChild(_txtCount);
        _source.addChild(_txtName);
        _btn.clickCallback = onClick;
        _source.outCallback = onOutHint;
        _source.hoverCallback = onHover;
        _btn.x = -33;
        _btn.y = -_bgItem.height - 35;
    }

    public function showIt(height:int,x:int,y:int, idResourceForRemoving:int, name:String, out:Function,buildType:int = 0):void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (_isShowed) return;
        _id = idResourceForRemoving;
        _isShowed = true;
        _height = height;
        _buildType = buildType;
        _onOutCallback = out;
        _quad = new Quad(bg.width, bg.height + _height * g.currentGameScale,Color.WHITE);
        _quad.alpha = 0;
        _quad.x = -bg.width/2;
        _quad.y = -bg.height;
        _source.addChildAt(_quad,0);
        if (!g.dataResource.objectResources[idResourceForRemoving]) {
            Cc.error('WildHInt showIt:: no such g.dataResource.objectResources[idResourceForRemoving] for idResourceForRemoving: ' + idResourceForRemoving);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'wildHint');
            return;
        }
        _txtName.text = name;
        _txtCount.text = String(g.userInventory.getCountResourceById(idResourceForRemoving));
        _iconResource = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[idResourceForRemoving].imageShop));
        _txtCount.text = String(g.userInventory.getCountResourceById(idResourceForRemoving));
        _txtCount.x = _circle.x + 3;
        _txtCount.y = _circle.y + 2;
        _iconResource = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[idResourceForRemoving].imageShop));
        if (!_iconResource) {
            Cc.error('WildHint showIt:: no such image: ' + g.dataResource.objectResources[idResourceForRemoving].imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'wildHint');
            return;
        }
        MCScaler.scale(_iconResource, 60, 60);
//        _iconResource.x = -_bgItem.width/2 +3;
//        _iconResource.y = -_bgItem.height - 32;
        _btn.addChild(_iconResource);
        _source.x = x;
        _source.y = y;
        g.cont.hintGameCont.addChild(_source);
        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.1);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            updateTextField();
        };
        g.starling.juggler.add(tween);
    }

    private function updateTextField():void {
        _txtCount.updateIt();
        _txtName.updateIt();
    }

    public function hideIt():void {
        if (_isOnHover) return;
        _closeTime = 1.5;
        g.gameDispatcher.addToTimer(closeTimer);
    }

    private function closeTimer():void {
        _closeTime--;
        if (_closeTime <= 0) {
            if (!_isOnHover) {
                var tween:Tween = new Tween(_source, 0.1);
                tween.scaleTo(0);
                tween.onComplete = function ():void {
                    g.starling.juggler.remove(tween);
                    _isShowed = false;
                    if (g.cont.hintGameCont.contains(_source))
                        g.cont.hintGameCont.removeChild(_source);
                    _source.removeChild(_quad);
                    _btn.removeChild(_iconResource);
                    _iconResource = null;
                    _height = 0;
                };
                g.starling.juggler.add(tween);
            }
            g.gameDispatcher.removeFromTimer(closeTimer);
        }
    }

    private function onClick(id:int = 0):void {
        if (g.userInventory.getCountResourceById(_id) <= 0){
            var ob:Object = {};
            ob.data = g.dataResource.objectResources[_id];
            ob.count = 1;
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClick, 'menu', ob);
        } else {
            if (_buildType == BuildType.TREE) {
                new XPStar(_source.x,_source.y,8);
            }
            g.userInventory.addResource(_id, -1);
            if (_deleteCallback != null) {
                _deleteCallback.apply();
                _deleteCallback = null;
            }
            managerHide();
//            onOutHint();
        }
    }

    public function set onDelete(f:Function):void {
        _deleteCallback = f;
    }

    private function onHover():void {
        _isOnHover = true;
    }


    private function onOutHint():void {
        _isOnHover = false;
        hideIt();
//        if (_onOutCallback != null) {
//            _onOutCallback.apply();
//            _onOutCallback = null;
//        }
    }

    public function get isShow():Boolean {
        return _isShowed;
    }

    public function managerHide(callback:Function = null):void {
        if (_isShowed) {
            var tween:Tween = new Tween(_source, 0.1);
            tween.scaleTo(0);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
                _isShowed = false;
                if (g.cont.hintGameCont.contains(_source))
                    g.cont.hintGameCont.removeChild(_source);
                _source.removeChild(_quad);
                _btn.removeChild(_iconResource);
                _iconResource = null;
                _height = 0;
                if (callback != null) {
                    callback.apply();
                    callback = null;
                }
            };
            g.starling.juggler.add(tween);
            g.gameDispatcher.removeFromTimer(closeTimer);
        }
    }
}
}
