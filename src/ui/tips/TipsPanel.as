/**
 * Created by user on 8/8/16.
 */
package ui.tips {
import com.greensock.TweenMax;
import manager.Vars;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CSprite;
import utils.MCScaler;
import utils.SimpleArrow;
import windows.WindowsManager;

public class TipsPanel {
    private var _source:CSprite;
    private var _timer:int;
    private var _txt:TextField;
    private var _arrow:SimpleArrow;
    private var _onHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function TipsPanel() {
        _onHover = false;
        _source = new CSprite();
        _source.x = 70;
        _source.y = 200;
        var im:Image = new Image(g.allData.atlas['tipsAtlas'].getTexture('helper_cat_1'));
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_m_big'));
        MCScaler.scale(im,35,35);
        im.x = 16;
        im.y = 30;
        _source.addChild(im);
        _txt= new TextField(30,30,"", g.allData.bFonts['BloggerBold24'],20,Color.WHITE);
        _txt.x = 18;
        _txt.y = 35;
        _txt.touchable = false;
        _source.addChild(_txt);
        _source.scaleX = _source.scaleY = .1;
        if (!g.cont.interfaceCont.contains(_source)) g.cont.interfaceCont.addChild(_source);
        TweenMax.to(_source, .3, {scaleX:1, scaleY:1, onComplete: onShow1});
    }

    private function onShow1():void {
        TweenMax.to(_source, .4, {scaleX:.9, scaleY:.9, onComplete:onShow2});
    }

    private function onShow2():void {
        _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        // also add cutScene here about it
        g.managerTips.calculateAvailableTips();
        g.gameDispatcher.addToTimer(onTimer);
        _timer = 7;
    }

    public function hideIt():void {
        deleteArrow();
        if (g.cont.interfaceCont.contains(_source)) g.cont.interfaceCont.removeChild(_source);
        g.gameDispatcher.removeFromTimer(onTimer);
        _source.deleteIt();
        _source = null;
    }

    public function updateAvailableActionCount(count:int):void {
        if (_txt) _txt.text = String(count);
    }

    private function onTimer():void {
        _timer--;
        if (_timer < 0) {
            animateIt();
            _timer = 7;
        }
    }

    private function onClick():void {
        deleteArrow();
        if (g.managerCutScenes.isCutScene || g.managerTutorial.isTutorial || g.isAway) return;
        TweenMax.killTweensOf(_source);
        _source.scaleX = _source.scaleY = .9;
        g.gameDispatcher.removeFromTimer(onTimer);
        g.windowsManager.openWindow(WindowsManager.WO_TIPS);
    }

    public function onHideWO():void {
        g.gameDispatcher.addToTimer(onTimer);
        _timer = 7;
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        TweenMax.killTweensOf(_source);
        _source.scaleX = _source.scaleY = 1;
        g.gameDispatcher.removeFromTimer(onTimer);
        g.hint.showIt("Подсказки",'none',1);
    }

    private function onOut():void {
        if (!_onHover) return;
        _onHover = false;
        _source.scaleX = _source.scaleY = .9;
        g.gameDispatcher.addToTimer(onTimer);
        _timer = 7;
        g.hint.hideIt()
    }

    private function animateIt():void {
        TweenMax.to(_source, .2, {scaleX:1, scaleY:1, onComplete: animate2});
    }

    private function animate2():void {
        TweenMax.to(_source, .2, {scaleX:.9, scaleY:.9, onComplete: animate3});
    }

    private function animate3():void {
        TweenMax.to(_source, .2, {scaleX:1, scaleY:1, onComplete: animate4});
    }

    private function animate4():void {
        TweenMax.to(_source, .2, {scaleX:.9, scaleY:.9});
    }

    public function setUnvisible(v:Boolean):void {
        _source.visible = !v;
        if (v) {
            g.gameDispatcher.removeFromTimer(onTimer);
        } else {
            _timer = 7;
            g.gameDispatcher.addToTimer(onTimer);
        }
    }

    public function showArrow():void {
        deleteArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, _source);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(60, 15);
        _arrow.activateTimer(5, deleteArrow);
    }

    private function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

}
}
