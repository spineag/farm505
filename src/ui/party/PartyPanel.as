/**
 * Created by user on 1/30/17.
 */
package ui.party {
import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import social.SocialNetworkSwitch;

import starling.animation.Tween;

import starling.display.Image;

import utils.CSprite;
import utils.CTextField;
import utils.TimeUtils;

import windows.WindowsManager;

public class PartyPanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();
    private var _txtData:CTextField;
    private var _isHover:Boolean;

    public function PartyPanel() {
        _source = new CSprite();
        var im:Image;
//        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) im = new Image(g.allData.atlas['partyAtlas'].getTexture('grape_mood_icon'));
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('zefir_timer'));
        _source.addChild(im);

        _txtData = new CTextField(100,60,'');
        _txtData.setFormat(CTextField.BOLD18, 18, 0xd30102);
        _source.addChild(_txtData);
        _txtData.y = 55;

        g.cont.interfaceCont.addChildAt(_source,0);
        onResize();
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
        g.gameDispatcher.addToTimer(startTimer);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height/2;
        _isHover = false;
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 180;
        _source.x = g.managerResize.stageWidth - 65;
    }

    private function startTimer():void {
        if (g.userTimer.partyToEndTimer > 0) {
            if (_txtData)_txtData.text = TimeUtils.convertSecondsForHint(g.userTimer.partyToEndTimer);
        } else {
            visiblePartyPanel(false);
            if (!g.managerParty.userParty.showWindow) {
                if (_txtData) {
                    _source.removeChild(_txtData);
                    _txtData.deleteIt();
                    _txtData = null;
                }
//                g.managerParty.endPartyWindow()
            }
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        g.hint.showIt(String(g.managerLanguage.allTexts[497]),'none', _source.x);
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
    }

    private function onOut():void {
        g.hint.hideIt();
        _isHover = false;
        _source.filter = null;
    }

    public function visiblePartyPanel(b:Boolean):void {
        if (b && _source && g.managerParty.eventOn) _source.visible = true;
        else if (_source) _source.visible = false;
    }

    private function onClick():void {
        if (g.userTimer.partyToEndTimer > 0) {
            _isHover = false;
            _source.filter = null;
            g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
        }
    }

    public function getPoint():Point {
        var p:Point = new Point();
        if (g.windowsManager.currentWindow) {
            p = new Point(_source.x,_source.y);
            return p;
        }
        p.x = _source.x;
        p.y = _source.y ;
        p = _source.localToGlobal(p);

        return p;
    }

    public function animationBuy():void {
        var tween:Tween;
        tween = new Tween(_source, 0.3);
        tween.scaleTo(1.8);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(1);
        g.starling.juggler.add(tween);

    }
}
}