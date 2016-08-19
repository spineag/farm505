/**
 * Created by user on 5/13/16.
 */
package preloader.miniPreloader {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;

import manager.Vars;

import starling.display.Sprite;

public class FlashAnimatedPreloader {
    private var _source:Sprite;
    private var _arma:Armature;
    private var g:Vars = Vars.getInstance();

    public function FlashAnimatedPreloader() {
        _source = new Sprite();
        _source.touchable = false;
        _arma = g.allData.factory['preloader_2'].buildArmature("preloader");
        _source.addChild(_arma.display as Sprite);
        WorldClock.clock.add(_arma);
        _arma.animation.gotoAndPlayByFrame('start');
    }

    public function get source():Sprite {
        return _source;
    }

    public function deleteIt():void {
        WorldClock.clock.remove(_arma);
        _source.removeChild(_arma.display as Sprite);
        _arma.dispose();
        _source.dispose();
    }
}
}
