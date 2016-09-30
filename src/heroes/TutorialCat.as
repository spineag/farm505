/**
 * Created by andy on 3/3/16.
 */
package heroes {
import com.junkbyte.console.Cc;
import dragonBones.starling.StarlingArmatureDisplay;
import tutorial.*;
import build.TownAreaBuildSprite;
import com.greensock.TweenMax;
import starling.display.Image;
import starling.display.Sprite;

public class TutorialCat extends BasicCat {
    private var _catImage:Sprite;
    private var _catBackImage:Sprite;
//    private var heroEyes:HeroEyesAnimation;
    private var freeIdleGo:Boolean;
    private var _animation:HeroCatsAnimation;
    private var _bubble:TutorialTextBubble;
    private var _isFlip:Boolean;
    private var _label:String = '';

    public function TutorialCat() {
        super();
        _speedWalk = 4;
        _speedRun = 12;

        _source = new TownAreaBuildSprite();
        _source.isTouchable = false;
        _catImage = new Sprite();
        _catBackImage = new Sprite();
        _catImage.touchable = false;
        _catBackImage.touchable = false;
        freeIdleGo = true;

        if (g.allData.factory['tutorialCat']) {
            createCat();
        } else {
            g.loadAnimation.load('animations_json/x1/cat_tutorial', 'tutorialCat', createCat);
        }
    }

    private function createCat():void {
        _animation = new HeroCatsAnimation();
        _animation.catArmature = g.allData.factory['tutorialCat'].buildArmature("cat");
        _animation.catBackArmature = g.allData.factory['cat_main'].buildArmature("cat_back");
        _catImage.addChild(_animation.catArmature.display as StarlingArmatureDisplay);
        _catBackImage.addChild(_animation.catBackArmature.display as StarlingArmatureDisplay);

        _source.addChild(_catImage);
        _source.addChild(_catBackImage);
        _animation.catImage = _catImage;
        _animation.catBackImage = _catBackImage;
        _bubble = new TutorialTextBubble(g.cont.animationsCont);
        showFront(true);
        addShadow();
        if (_isFlip) _animation.flipIt(_isFlip);
        if (_label != '') _animation.playIt(_label);
    }

    public function get isFree():Boolean { return true; }

    private function addShadow():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_shadow'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -44*g.scaleFactor;
        im.y = -28*g.scaleFactor;
        im.alpha = .5;
        _source.addChildAt(im, 0);
    }

    public function get isShowingBubble():Boolean {
        if (_bubble) return true;
        else return false;
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
        try {
            if (_bubble) {
                _bubble.showBubble(st, _isFlip, type);
                if (_isFlip) {
                    _bubble.setXY(20 + _source.x, -50 + _source.y);
                } else {
                    _bubble.setXY(-20 + _source.x, -50 + _source.y);
                }
            }
        } catch (e:Error) {
            Cc.error('TutorialCat showBubble error: ' + e.message + '  step: ' + g.user.tutorialStep);
        }
    }

    public function hideBubble():void {
        if (_bubble) {
            _bubble.clearIt();
        }
    }

    override public function showFront(v:Boolean):void {
        if (_animation) _animation.showFront(v);
    }

    override public function set visible(value:Boolean):void {
        if (!value)  {
            if (_animation) _animation.stopIt();
        }
        super.visible = value;
    }

    override public function flipIt(v:Boolean):void {
        _isFlip = v;
        if (_animation) _animation.flipIt(v);
    }

    override public function walkAnimation():void {
        _label = 'walk';
        if (_animation) _animation.playIt('walk');
        super.walkAnimation();
    }
    override public function walkIdleAnimation():void {
        _label = 'walk';
        if (_animation) _animation.playIt('walk');
        super.walkIdleAnimation();
    }
    override public function runAnimation():void {
        _label = 'run';
        if (_animation) _animation.playIt('run');
        super.runAnimation();
    }
    override public function stopAnimation():void {
        _label = '';
        if (_animation) _animation.stopIt();
        super.stopAnimation();
    }
    override public function idleAnimation():void {
        _label = 'idle';
        showFront(true);
        if (_animation) _animation.playIt('idle');
        super.idleAnimation();
    }

    public function playDirectLabel(label:String, playOnce:Boolean, callback:Function):void {
        showFront(true);
        if (_animation) _animation.playIt(label, playOnce, callback);
    }

    override public function deleteIt():void {
        if (_bubble) {
            _bubble.deleteIt();
            _bubble = null;
        }
        killAllAnimations();
        removeFromMap();
        if (_animation) {
            _catImage.removeChild(_animation.catArmature.display as Sprite);
            _catBackImage.removeChild(_animation.catBackArmature.display as Sprite);
            _animation.deleteArmature(_animation.catArmature);
            _animation.deleteArmature(_animation.catBackArmature);
            _animation.clearIt();
        }
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
