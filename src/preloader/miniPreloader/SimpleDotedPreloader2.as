/**
 * Created by andy on 5/12/16.
 */
package preloader.miniPreloader {
import manager.Vars;

import starling.display.Sprite;

public class SimpleDotedPreloader2 {
    private var _source:Sprite;
    private var _arrDots:Array;
    private var _counter:int;
    private var _curr:int;
    private var g:Vars = Vars.getInstance();

    public function SimpleDotedPreloader2() {
        _source = new Sprite();
        _source.touchable = false;
        _arrDots = [];
        var dot:Particle;
        for (var i:int=0; i<8; i++) {
            dot = new Particle(i, _source);
            _arrDots.push(dot);
        }
        _curr = 0;
        _arrDots[_curr].showIt(true);
        _counter = 0;
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function onEnterFrame():void {
        _counter++;
        if (_counter > 5) {
            _counter = 0;
            _arrDots[_curr].showIt(false);
            _curr++;
            if (_curr >= 8) _curr = 0;
            _arrDots[_curr].showIt(true);
        }
    }

    public function get source():Sprite {
        return _source;
    }

    public function deleteIt():void {
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        for (var i:int=0; i<_arrDots.length; i++) {
            _arrDots[i].deleteIt();
        }
        _arrDots.length = 0;
        _source.dispose();
        _source = null;
    }
}
}

import com.greensock.TweenMax;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;

internal class Particle {
    private var _source:Sprite;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();

    public function Particle(i:int, p:Sprite) {
        _parent = p;
        _source = new Sprite();
        switch (i) {
            case 0:
                _source.x = 0;
                _source.y = -20;
                break;
            case 1:
                _source.x = 14;
                _source.y = -15;
                break;
            case 2:
                _source.x = 20;
                _source.y = 0;
                break;
            case 3:
                _source.x = 14;
                _source.y = 15;
                break;
            case 4:
                _source.x = 0;
                _source.y = 20;
                break;
            case 5:
                _source.x = -14;
                _source.y = 15;
                break;
            case 6:
                _source.x = -20;
                _source.y = 0;
                break;
            case 7:
                _source.x = -14;
                _source.y = -15;
                break;
        }
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('white'));
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
        _parent.addChild(_source);
        _source.alpha = .4;
    }

    public function showIt(v:Boolean):void {
        if (v) _source.alpha = .8;
            else _source.alpha = .4;
    }

    public function deleteIt():void {
        TweenMax.killTweensOf(_source);
        _parent.removeChild(_source);
        _parent = null;
        _source.dispose();
        _source = null;
    }
}
