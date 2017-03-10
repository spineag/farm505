/**
 * Created by user on 10/26/16.
 */
package ui.stock {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;
import manager.Vars;
import utils.CSprite;
import windows.WindowsManager;

public class StockPanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();
    private var _armature:Armature;
    private var _timer:int;

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
        var st:String = 'animations_json/action_icon';
        g.loadAnimation.load(st, 'action_icon', onLoad);
    }

    private function onLoad():void {
        _armature =  g.allData.factory['action_icon'].buildArmature('cat');
        WorldClock.clock.add(_armature);
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        _armature.animation.gotoAndPlayByFrame('idle');
        _timer = 20;
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
}
}
