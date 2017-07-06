/**
 * Created by andy on 2/20/17.
 */
package quest {
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import manager.Vars;
import starling.display.Image;
import starling.textures.Texture;
import utils.AnimationsStock;
import utils.CSprite;
import utils.MCScaler;
import utils.SimpleArrow;

public class QuestItemIcon {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;
    private var _quest:QuestStructure;
    private var _priority:int;
    private var _position:int;
    private var _onHover:Boolean;
    private var _arrow:SimpleArrow;
    private var _im:Image;
    private var _imSmall:Image;
    private var _isAnimate:Boolean;

    public function QuestItemIcon(q:QuestStructure) {
        if (!q) {
            Cc.error('QuestItemIcon:: questStructure == null');
            return;
        }
        if (!q.tasks || !q.tasks.length) {
            Cc.error('QuestItemIcon:: no tasks for quest with id: ' + q.questId);
            return;
        }
        _isAnimate = false;
        _onHover = false;
        _source = new CSprite();
        _quest = q;
        var st:String = _quest.iconPath;
        if (st == '0') {
            st = _quest.getUrlFromTask();
            if (st == '0') {
                addIm(_quest.iconImageFromAtlas());
            } else {
                g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
            }
        } else {
            g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
        }
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
    }
    
    public function set priority(n:int):void {
        if (_quest.id < 4) _priority = n + 100000;
        else _priority = n;
    }
    
    public function get priority():int { return _priority; }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        g.hint.showIt(_quest.questName,'none',1);
    }

    private function onOut():void {
        _onHover = false;
        g.hint.hideIt();
    }

    private function addIm(im:Image):void {
        if (im) {
            MCScaler.scale(im, 85, 85);
            im.alignPivot();
            _source.addChild(im);
            _im = im;
        }
        var t:QuestTaskStructure = _quest.tasks[0];
        if (t.typeAction == ManagerQuest.ADD_LEFT_MENU || t.typeAction == ManagerQuest.POST || t.typeAction == ManagerQuest.ADD_TO_GROUP) {

        } else {
            var st:String = _quest.getUrlFromTask();
            if (st == '0') {
                addSmallIm(_quest.iconImageFromAtlas());
            } else {
                g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadSmallIcon);
            }
        }
    }

    private function addSmallIm(im:Image):void {
        if (im) {
            MCScaler.scale(im, 40, 40);
            im.alignPivot();
            im.x = 27;
            im.y = 25;
            _source.addChild(im);
            _imSmall = im;
        }
    }

    private function onClick():void { g.managerQuest.showWOForQuest(_quest); }
    public function get questId():int { return _quest.id; }
    public function get source():CSprite { return _source; }
    private function onLoadIcon(bitmap:Bitmap):void { addIm(new Image(Texture.fromBitmap(bitmap))); }
    private function onLoadSmallIcon(bitmap:Bitmap):void { addSmallIm(new Image(Texture.fromBitmap(bitmap))); }

    public function set position(a:int):void {
        _position = a;
        _source.y = a*90 + 40;
    }
    
    public function addArrow(t:int=3):void {
        hideArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, _source);
        _arrow.animateAtPosition(40, 5);
        _arrow.activateTimer(t, hideArrow);
    }

    public function hideArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function animateOnTaskUpdate():void {
        if (_isAnimate) return;
        _isAnimate = true;
        if (_im) AnimationsStock.joggleItBaby(_im, 3, function():void { _isAnimate=false; });
        if (_imSmall) AnimationsStock.jumpSimple(_imSmall);
    }
    
    public function deleteIt():void {
        if (_im) TweenMax.killTweensOf(_im);
        if (_imSmall) TweenMax.killTweensOf(_imSmall);
        _source.deleteIt();
    }

}
}
