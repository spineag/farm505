/**
 * Created by andy on 1/17/16.
 */
package particle {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import utils.CSprite;

public class CraftItemParticle {
    private var _source:Sprite;
    private var _parent:CSprite;
    private var g:Vars = Vars.getInstance();

    public function CraftItemParticle(p:CSprite) {
        _parent = p;
        _source = new Sprite();
        _parent.addChildAt(_source, 0);
        addParticle();
    }

    private function addParticle():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('product_particle'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
        _source.touchable = false;
        makeTween();
    }

    private function makeTween():void {
        new TweenMax(_source, 5, {rotation:2*Math.PI, onComplete: makeTween, ease:Linear.easeNone});
    }

    public function deleteIt():void {
        TweenMax.killTweensOf(_source);
        _parent.removeChild(_source);
        _source.dispose();
        _source = null;
        _parent = null;
    }
}
}
