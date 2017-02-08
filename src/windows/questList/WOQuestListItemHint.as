/**
 * Created by andy on 2/7/17.
 */
package windows.questList {
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import quest.QuestStructure;
import starling.display.Sprite;
import utils.CTextField;
import windows.WOComponents.HintBackground;

public class WOQuestListItemHint {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _txtName:CTextField;
    private var _bgTop:HintBackground;
    private var _bgBottom:HintBackground;
    private var _quest:QuestStructure;
    private var _items:Array;
    private var _sp:Sprite;

    public function WOQuestListItemHint(q:QuestStructure, p:Point) {
        _source = new Sprite();
        _quest = q;
        _txtName = new CTextField(200, 30, _quest.questName);
        _txtName.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        var w:int = _txtName.textBounds.width + 20;
        _bgTop = new HintBackground(w, 36, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _bgTop.y = -40;
        _txtName.y = -94;
        _txtName.x = -100;
        _source.addChild(_bgTop);
        _source.addChild(_txtName);

        _source.x = p.x;
        _source.y = p.y;
        g.cont.hintCont.addChild(_source);

        var ar:Array = _quest.tasks;
        _items = [];
        _sp = new Sprite();
        var it:Item;
        for (var i:int=0; i<ar.length; i++) {
            it = new Item(ar[i]);
            it.source.x = i*45 + 20;
            _sp.addChild(it.source);
            _items.push(it);
        }
        _sp.x = -_sp.width/2;
        _sp.y = 100;
        _source.addChild(_sp);

        w = _sp.width + 20;
        if (w < 70) w = 70;
        _bgBottom = new HintBackground(w, 60, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
        _bgBottom.y = 40;
        _source.addChildAt(_bgBottom, 0);
    }

    public function hideIt():void {
        if (!_source) return;
        g.cont.hintCont.removeChild(_source);
        for (var i:int=0; i<_items.length; i++) {
            _sp.removeChild(_items[i].source);
            _items[i].deleteIt();
        }
        _items.length = 0;
        _source.removeChild(_bgTop);
        _source.removeChild(_bgBottom);
        _source.removeChild(_txtName);
        _bgTop.deleteIt();
        _bgBottom.deleteIt();
        _txtName.deleteIt();
        _source.dispose();
        _source = null;
    }
}
}

import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;
import quest.ManagerQuest;
import quest.QuestTaskStructure;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CTextField;
import utils.MCScaler;
internal class Item {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _txt:CTextField;
    private var _t:QuestTaskStructure;

    public function Item(t:QuestTaskStructure) {
        _t = t;
        _source = new Sprite();
        _source.touchable = false;
        var st:String = _t.icon;
        if (st == '0') {
            addIm(_t.iconImageFromAtlas);
        } else {
            g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
        }
        _txt = new CTextField(40, 20, String(_t.countDone) + '/' + String(_t.countNeed));
        _txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -20;
        _txt.y = -10;
        _source.addChild(_txt);
    }

    private function onLoadIcon(bitmap:Bitmap):void {
        addIm(new Image(Texture.fromBitmap(bitmap)));
    }

    private function addIm(im:Image):void {
        if (!im) return;
        MCScaler.scale(im, 40, 40);
        im.x = -im.width/2;
        im.y = -im.height;
        im.touchable = false;
        _source.addChildAt(im, 0);
    }

    public function get source():Sprite { return _source; }

    public function deleteIt():void {
        _source.removeChild(_txt);
        _txt.deleteIt();
        _txt = null;
        _source.dispose();
        _source = null;
    }

}
