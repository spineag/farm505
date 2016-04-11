/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import com.greensock.TweenMax;

import heroes.BasicCat;
import heroes.HeroCatsAnimation;
import heroes.HeroEyesAnimation;
import starling.display.Image;
import starling.display.Sprite;
import utils.CSprite;
import windows.WOComponents.HintBackground;

public class TutorialCat extends BasicCat {
    private var _catImage:Sprite;
    private var _catBackImage:Sprite;
    private var heroEyes:HeroEyesAnimation;
    private var freeIdleGo:Boolean;
    private var _animation:HeroCatsAnimation;
    private var _bubble:TutorialTextBubble;
    private var _isFlip:Boolean;

    public function TutorialCat() {
        super();
        _speedWalk = 4;
        _speedRun = 12;

        _source = new CSprite();
        _catImage = new Sprite();
        _catBackImage = new Sprite();
        _catImage.touchable = false;
        _catBackImage.touchable = false;
        freeIdleGo = true;

        _animation = new HeroCatsAnimation();
        _animation.catArmature = g.allData.factory['tutorialCat'].buildArmature("cat");
        _animation.catBackArmature = g.allData.factory['cat'].buildArmature("cat_back");
        _catImage.addChild(_animation.catArmature.display as Sprite);
        _catBackImage.addChild(_animation.catBackArmature.display as Sprite);

        heroEyes = new HeroEyesAnimation(g.allData.factory['cat'], _animation.catArmature, 'heads/head', '', false);
        _source.addChild(_catImage);
        _source.addChild(_catBackImage);
        _animation.catImage = _catImage;
        _animation.catBackImage = _catBackImage;
        _bubble = new TutorialTextBubble(_source);
        showFront(true);
        addShadow();
    }

    private function addShadow():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_shadow'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -44*g.scaleFactor;
        im.y = -28*g.scaleFactor;
        im.alpha = .5;
        _source.addChildAt(im, 0);
    }

    public function showBubble(st:String, delay:Number=0):void {
        var type:int;
        if (st.length > 140) {
            type = TutorialTextBubble.BIG;
        } else if (st.length > 60) {
            type = TutorialTextBubble.MIDDLE;
        } else {
            type = TutorialTextBubble.SMALL;
        }
        if (_bubble) {
            _bubble.showBubble(st, _isFlip, type);
            if (_isFlip) {
                _bubble.setXY(20, -50);
            } else {
                _bubble.setXY(-20, -50);
            }
        }
    }

    public function hideBubble():void {
        if (_bubble) {
            _bubble.clearIt();
        }
    }

    override public function showFront(v:Boolean):void {
        _animation.showFront(v);
        if (v) heroEyes.startAnimations();
        else heroEyes.stopAnimations();
    }

    override public function set visible(value:Boolean):void {
        if (!value)  _animation.stopIt();
        super.visible = value;
    }

    override public function flipIt(v:Boolean):void {
        _isFlip = v;
        _animation.flipIt(v);
    }

    override public function walkAnimation():void {
        heroEyes.startAnimations();
        _animation.playIt('walk');
        super.walkAnimation();
    }
    override public function walkIdleAnimation():void {
        heroEyes.startAnimations();
        _animation.playIt('walk');
        super.walkIdleAnimation();
    }
    override public function runAnimation():void {
        heroEyes.startAnimations();
        _animation.playIt('run');
        super.runAnimation();
    }
    override public function stopAnimation():void {
        heroEyes.stopAnimations();
        _animation.stopIt();
        super.stopAnimation();
    }
    override public function idleAnimation():void {
        if (Math.random() > .2) {
            showFront(true);
        } else {
            showFront(false);
        }
        heroEyes.startAnimations();
        _animation.playIt('idle');
        super.idleAnimation();
    }

    public function playDirectLabel(label:String, playOnce:Boolean, callback:Function):void {
        showFront(true);
        heroEyes.startAnimations();
        _animation.playIt(label, playOnce, callback);
    }

    override public function deleteIt():void {
        if (_bubble) {
            _bubble.deleteIt();
            _bubble = null;
        }
        killAllAnimations();
        removeFromMap();
        if (heroEyes) {
            heroEyes.stopAnimations();
            heroEyes = null;
        }
        _catImage.removeChild(_animation.catArmature.display as Sprite);
        _catBackImage.removeChild(_animation.catBackArmature.display as Sprite);
        _animation.deleteArmature(_animation.catArmature);
        _animation.deleteArmature(_animation.catBackArmature);
        _animation.clearIt();
        super.deleteIt();
        _catImage = null;
        _catBackImage = null;
    }

    public function killAllAnimations():void {
        stopAnimation();
        _currentPath = [];
        TweenMax.killTweensOf(_source);
    }
}
}
