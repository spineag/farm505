/**
 * Created by user on 1/30/17.
 */
package ui.party {
import data.BuildType;

import flash.geom.Point;

import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;

import utils.CSprite;
import utils.CTextField;
import utils.TimeUtils;

import windows.WindowsManager;

public class PartyPanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();
    private var _txtData:CTextField;

    public function PartyPanel() {
        _source = new CSprite();
        var im:Image = new Image(g.allData.atlas['partyAtlas'].getTexture('clover_leaf_event_timer'));
        _source.addChild(im);

        _txtData = new CTextField(100,60,'');
        _txtData.setFormat(CTextField.BOLD18, 18, 0xd30102);
        _source.addChild(_txtData);
        _txtData.y = 55;

        g.cont.interfaceCont.addChild(_source);
        _source.y = 130;
        _source.x = g.managerResize.stageWidth - 108;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
        g.gameDispatcher.addToTimer(startTimer);
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 130;
        _source.x = g.managerResize.stageWidth - 108;
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
                g.managerParty.endPartyWindow()
            }
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    private function onHover():void {
        g.hint.showIt(String(g.managerLanguage.allTexts[497]),'none', _source.x);
    }

    private function onOut():void {
        g.hint.hideIt();
    }

    public function visiblePartyPanel(b:Boolean):void {
        if (b) _source.visible = true;
        else _source.visible = false;
    }

    private function onClick():void {
        if (g.userTimer.partyToEndTimer > 0) {
            g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
        }
    }

    public function getPoint():Point {
        var p:Point = new Point();
        if (g.windowsManager.currentWindow) {
            p = new Point(_source.x+40,_source.y +40);
            return p;
        }
        p.x = _source.x + 20;
        p.y = _source.y + 10;
        p = _source.localToGlobal(p);

        return p;
    }
}
}