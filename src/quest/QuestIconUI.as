/**
 * Created by andy on 12/29/16.
 */
package quest {
import com.greensock.TweenMax;

import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;

import utils.CSprite;

public class QuestIconUI {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;
    private var _onHover:Boolean;
    private var _isShow:Boolean;

    public function QuestIconUI(f:Function) {
        _isShow = false;
        _onHover = false;
        _source = new CSprite();
        _source.x = 70;
        checkContPosition();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_quest_icon'));
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
        
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = f;
    }

    public function showItAnimate():void {
        _source.scale = .3;
        if (!g.cont.interfaceCont.contains(_source)) {
            g.cont.interfaceCont.addChild(_source);
            var f2:Function = function ():void {
                _isShow = true;
                TweenMax.to(_source, 1, {scale: .1});
            };
            var f1:Function = function ():void {
                TweenMax.to(_source, .1, {scale: .93, onComplete: f2})
            };
            TweenMax.to(_source, .3, {scale: 1.1, onComplete: f1});
        }
    }

    public function hideItAnimate():void {
        if (g.cont.interfaceCont.contains(_source)) {
            var f1:Function = function ():void {
                g.cont.interfaceCont.removeChild(_source);
                _isShow = false;
            };
            TweenMax.to(_source, .2, {scale: .3, onComplete: f1});
        }
    }

    public function get isShow():Boolean {
        return _isShow;
    }

    public function checkContPosition():void {
        if (g.user.level > 16) {
            _source.y = 270;
        } else {
            _source.y = 180;
        }
    }

    public function hideIt(v:Boolean):void {
        _source.visible = !v;
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        g.hint.showIt("Задания",'none',1);
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
    }

    private function onOut():void {
        if (!_onHover) return;
        _onHover = false;
        g.hint.hideIt();
        _source.filter = null;
    }
}
}
