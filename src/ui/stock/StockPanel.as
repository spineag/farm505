/**
 * Created by user on 10/26/16.
 */
package ui.stock {
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.ManagerLanguage;
import manager.Vars;

import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.TimeUtils;

import windows.WindowsManager;

public class StockPanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();
    private var _armature:Armature;
    private var _timer:int;
    private var _txtData:CTextField;
    private var _txtTime:CTextField;
    private var _spriteTxt:Sprite;
    private var _spriteTime:Sprite;

    public function StockPanel() {
        _source = new CSprite();
        _source.endClickCallback = onClick;
        _source.hoverCallback = function ():void {
            g.hint.showIt(String(g.managerLanguage.allTexts[454]))
        };
        _source.outCallback = function ():void {
            g.hint.hideIt()
        };
        onResize();
        g.cont.interfaceCont.addChild(_source);
        loadTipsIcon();
    }

    private function loadTipsIcon():void {
        var st:String;
        st = 'animations_json/offer_icon';
        g.loadAnimation.load(st, 'action_icon', onLoad);
    }

    private function onLoad():void {
        _armature =  g.allData.factory['action_icon'].buildArmature('cat');
        WorldClock.clock.add(_armature);
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        _armature.animation.gotoAndPlayByFrame('idle');
        _timer = 20;

        _txtTime = new CTextField(128,60,'');
        _txtTime.setFormat(CTextField.BOLD18, 16, 0xff0c84);
        _txtTime.alignH = Align.LEFT;
        _txtTime.y = -28;
        _spriteTime = new Sprite();
        _spriteTime.addChild(_txtTime);

        _txtData = new CTextField(128,60,String(g.managerLanguage.allTexts[454]));
        _txtData.setFormat(CTextField.BOLD24, 24, Color.WHITE, 0xff0c84);
        _txtData.y = -27;
        _txtData.x = -62;
        _spriteTxt = new Sprite();
        _spriteTxt.addChild(_txtData);


        if (!b) var b:Slot = _armature.getSlot('text');
        if (b) {
            b.displayList = null;
            b.display = _spriteTxt;
        }

        if (!t) var t:Slot = _armature.getSlot('timer');
        if (t) {
            t.displayList = null;
            t.display = _spriteTime;
        }
        g.gameDispatcher.addToTimer(startTimer);
        g.gameDispatcher.addToTimer(animation);
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 12;
        _source.x = g.managerResize.stageWidth - 240;
    }

    private function onClick():void {
        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, false);
    }

    private function animation():void {
        _timer--;
        if (_timer <= 0) {
            g.gameDispatcher.removeFromTimer(animation);
            _armature.animation.gotoAndPlayByFrame('idle');
            _timer = 12;
            g.gameDispatcher.addToTimer(animation);
        }
    }

    private function startTimer():void {
        if (g.userTimer.stockTimerToEnd > 0) {
            if (_txtTime) {
                _txtTime.text = TimeUtils.convertSecondsForHint(g.userTimer.stockTimerToEnd);
                _txtTime.x = 8 -_txtTime.textBounds.width/2;
            }
        } else {
            visiblePartyPanel(false);
            if (_txtData) {
                _txtData.deleteIt();
                _txtData = null;
            }
            if (_txtTime) {
                _txtTime.deleteIt();
                _txtTime = null;
            }
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    public function visiblePartyPanel(b:Boolean):void {
        if (b) _source.visible = true;
        else _source.visible = false;
    }
}
}
