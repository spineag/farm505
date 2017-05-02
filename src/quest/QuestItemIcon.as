/**
 * Created by andy on 2/20/17.
 */
package quest {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import manager.Vars;
import starling.display.Image;
import starling.textures.Texture;
import utils.CSprite;
import utils.MCScaler;
import utils.SimpleArrow;

public class QuestItemIcon {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;
    private var _quest:QuestStructure;
    public var priority:int;
    private var _position:int;
    private var _onHover:Boolean;
    private var _arrow:SimpleArrow;

    public function QuestItemIcon(q:QuestStructure) {
        if (!q) {
            Cc.error('QuestItemIcon:: questStructure == null');
            return;
        }
        if (!q.tasks || !q.tasks.length) {
            Cc.error('QuestItemIcon:: no tasks for quest with id: ' + q.questId);
            return;
        }
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

    private function onClick():void {
        g.managerQuest.showWOForQuest(_quest);
    }

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
            MCScaler.scale(im, 80, 80);
            im.alignPivot();
            _source.addChild(im);
        }
        var t:QuestTaskStructure = _quest.tasks[0];
        if (t.typeAction == ManagerQuest.ADD_LEFT_MENU || t.typeAction == ManagerQuest.POST || t.typeAction == ManagerQuest.ADD_LEFT_MENU) {

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
            im.y = 27;
            _source.addChild(im);
        }
    }

    public function get questId():int { return _quest.id; }
    public function get source():CSprite { return _source; }
    private function onLoadIcon(bitmap:Bitmap):void { addIm(new Image(Texture.fromBitmap(bitmap))); }
    private function onLoadSmallIcon(bitmap:Bitmap):void { addSmallIm(new Image(Texture.fromBitmap(bitmap))); }

    public function set position(a:int):void {
        _position = a;
        _source.y = a*90 + 40;
    }
    
    public function addArrow():void {
        hideArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, _source);
        _arrow.animateAtPosition(40, 5);
        _arrow.activateTimer(3, hideArrow);
    }

    public function hideArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }
}
}
