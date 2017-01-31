/**
 * Created by user on 1/30/17.
 */
package ui.event {
import manager.Vars;

import social.SocialNetworkSwitch;

import utils.CSprite;

import windows.WindowsManager;

public class EventPanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();

    public function EventPanel() {
        _source = new CSprite();
        g.cont.interfaceCont.addChild(_source);
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 77;
        _source.x = g.managerResize.stageWidth - 108;
    }

    private function onHover():void {

    }

    private function onOut():void {

    }

    public function visibleCatPanel(b:Boolean):void {
        if (b) _source.visible = true;
        else _source.visible = false;
    }

    private function onClick():void {
        g.windowsManager.openWindow(WindowsManager.WO_EVENT, null);
    }
}
}
