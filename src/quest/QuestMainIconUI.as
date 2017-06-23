/**
 * Created by andy on 12/29/16.
 */
package quest {
import com.greensock.TweenMax;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

public class QuestMainIconUI {
    private var g:Vars = Vars.getInstance();
    private var _sp:Sprite;
    private var _mask:Sprite;
    private var _cont:Sprite;
    private var _topArrow:CButton;
    private var _bottomArrow:CButton;
    private var _items:Array;
    private var _shift:int;

    public function QuestMainIconUI() {
        _items = [];

        _shift = 0;
        _sp = new Sprite();
        _sp.x = 15;
        _topArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        MCScaler.scale(im, 65, 65);
        im.alignPivot();
        im.rotation = Math.PI/2;
        _topArrow.addDisplayObject(im);
        _topArrow.x = 40;
        _topArrow.y = 17;
        _sp.addChild(_topArrow);
        _topArrow.clickCallback = onClickTop;
        _topArrow.visible = false;

        _bottomArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        MCScaler.scale(im, 65, 65);
        im.alignPivot();
        im.rotation = -Math.PI/2;
        _bottomArrow.addDisplayObject(im);
        _bottomArrow.x = 40;
        _bottomArrow.y = 315;
        _sp.addChild(_bottomArrow);
        _bottomArrow.clickCallback = onClickBottom;
        _bottomArrow.visible = false;

        _mask = new Sprite();
        _mask.mask = new Quad(300, 260);
        _mask.y = _topArrow.height + 7;
        _sp.addChild(_mask);
        _cont = new Sprite();
        _mask.addChild(_cont);
        g.cont.interfaceCont.addChild(_sp);

        checkContPosition();
    }

    private function deleteIcons():void {
        for (var i:int=0; i<_items.length; i++) {
            if (_cont.contains(_items[i].source)) _cont.removeChild(_items[i].source)
        }
        _items.length = 0;
    }
    
    public function updateIcons():void {
        deleteIcons();
        _shift = 0;
        _cont.y = 0;
        var ar:Array = g.managerQuest.userQuests;
        var arNew:Array = [];
        var j:int;
        for (var i:int=0; i<ar.length; i++) {
            for (j=0; j<_items.length; j++) {
                if ((ar[i] as QuestStructure).id == (_items[j] as QuestItemIcon).questId) break;
            }
            arNew.push(ar[i]);
        }
        if (arNew.length) {
            var pos:int = _items.length;
            for (i=0; i<pos; i++) {
                (_items[i] as QuestItemIcon).priority = 100 + i;
            }
            var it:QuestItemIcon;
            for (i=0; i<arNew.length; i++) {
                it = new QuestItemIcon(arNew[i]);
                it.source.x = 40;
                it.priority = 100 + i + pos;
                _cont.addChild(it.source);
                if ((arNew[i] as QuestStructure).isNew) {
                    it.priority = i;
                    it.addArrow();
                    (arNew[i] as QuestStructure).isNew = false;
                }
                _items.push(it);
            }
            _items.sortOn('priority', Array.NUMERIC);
            for (i=0; i<_items.length; i++) {
                (_items[i] as QuestItemIcon).position = i;
                (_items[i] as QuestItemIcon).priority = i;
            }
        }
        checkArrows();
    }

    public function checkContPosition():void {
        if (g.user.level > 10) {
            _sp.y = 210;
        } else {
            _sp.y = 150;
        }
    }

    public function hideIt(v:Boolean):void {
        _sp.visible = !v;
    }

    private function checkArrows():void {
        if (_items.length < 4) {
            _topArrow.visible = false;
            _bottomArrow.visible = false;
        } else {
            if (_shift > 0) _topArrow.visible = true;
            else _topArrow.visible = false;
            if (_shift + 3 < _items.length) _bottomArrow.visible = true;
            else _bottomArrow.visible = false;
        }
    }

    private function onClickTop():void {
        if (_shift > 0) {
            _shift--;
            TweenMax.to(_cont, .3, {y: -_shift * 90});
            checkArrows();
        }
    }

    private function onClickBottom():void {
        if (_shift + 3 < _items.length) {
            _shift++;
            TweenMax.to(_cont, .3, {y: -_shift * 90});
            checkArrows();
        }
    }
    
    public function showArrowsForAllVisibleIconQuests(t:int):void {
        for (var i:int=0; i<_items.length; i++) {
            (_items[i] as QuestItemIcon).addArrow(t);
        }
    }
}
}
