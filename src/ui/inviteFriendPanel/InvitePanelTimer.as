/**
 * Created by andy on 6/20/17.
 */
package ui.inviteFriendPanel {

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import utils.CSprite;
import utils.CTextField;
import utils.TimeUtils;

public class InvitePanelTimer {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;
    private var _txtTimer:CTextField;
    private var _isHover:Boolean;

    public function InvitePanelTimer() {
        _source = new CSprite();
        var im:Image = new Image(g.allData.atlas['inviteAtlas'].getTexture('Invite_5_friends_icon'));
        _source.addChild(im);
        _source.alignPivot();
        _txtTimer = new CTextField(100,60,'');
        _txtTimer.setFormat(CTextField.BOLD18, 17, ManagerFilters.HARD_GREEN_COLOR);
        _source.addChild(_txtTimer);
        _txtTimer.x = 15;
        _txtTimer.y = 81;

        _source.x = g.managerResize.stageWidth - 65;
        g.cont.interfaceCont.addChild(_source);
        updatePosition();

        _isHover = false;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
        g.gameDispatcher.addToTimer(startTimer);
    }
    
    public function updatePosition():void {
        if (g.partyPanel && g.partyPanel.isVisible || g.stockPanel && g.stockPanel.isVisible || g.salePanel && g.salePanel.isVisible) _source.y = 280;
        else _source.y = 180;
        _source.x = g.managerResize.stageWidth - 65;
    }

    private function startTimer():void { if (_txtTimer) _txtTimer.text = TimeUtils.convertSecondsToStringClassic(g.managerInviteFriend.timerEnd); }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        g.hint.showIt(String(g.managerLanguage.allTexts[427]),'none', _source.x);
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
    }

    private function onOut():void {
        g.hint.hideIt();
        _isHover = false;
        _source.filter = null;
    }

    private function onClick():void {
        _isHover = false;
        _source.filter = null;
       g.managerInviteFriend.openWO();
    }

    public function deleteIt():void {
        if (_source) {
            if (g.cont.interfaceCont.contains(_source)) g.cont.interfaceCont.removeChild(_source);
            g.gameDispatcher.removeFromTimer(startTimer);
            _source.removeChild(_txtTimer);
            _txtTimer.deleteIt();
            _txtTimer = null;
            _source.dispose();
            _source = null;
        }
    }
}
}
