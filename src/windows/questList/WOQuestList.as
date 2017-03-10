/**
 * Created by andy on 12/29/16.
 */
package windows.questList {
import com.greensock.TweenMax;

import quest.QuestStructure;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import utils.CButton;
import windows.WOComponents.Birka;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOQuestList extends WindowMain{
    private var _woBG:WindowBackground;
    private var _birka:Birka;
    private var _items:Array;
    private var _cont:Sprite;
    private var _maskedContainer:Sprite;
    private var _shift:int;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _isAnim:Boolean;

    public function WOQuestList() {   // not use it
        super();
        _items = [];
        _isAnim = false;
        _windowType = WindowsManager.WO_QUEST_LIST;
        _woWidth = 500;
        _woHeight = 150;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _callbackClickBG = hideIt;

        _birka = new Birka(g.managerLanguage.allTexts[623], _source, _woWidth, _woHeight);
        _birka.flipItY();
        _birka.source.rotation = Math.PI/2;
        _birka.source.x = 40;
        _birka.source.y = -75;

        _maskedContainer = new Sprite();
        _maskedContainer.mask = new Quad(360, 150);
        _cont = new Sprite();
        _maskedContainer.addChild(_cont);
        _maskedContainer.x = -180;
        _maskedContainer.y = -60;
        _source.addChild(_maskedContainer);

        addArrows();
    }
    
    override public function showItParams(callback:Function, params:Array):void {
        _shift = 0;
        fillItems();
        checkArrows();
        super.showIt();
    }

    private function fillItems():void {
        var q:Array = g.managerQuest.userQuests;
        var it:WOQuestListItem;
        for (var i:int=0; i<q.length; i++) {
            it = new WOQuestListItem(q[i], onItemClick);
            it.source.x = 60 + 120*i;
            it.source.y = 60;
            _cont.addChild(it.source);
            _items.push(it);
        }
    }

    private function onItemClick(d:QuestStructure):void {
        super.hideIt();
        g.managerQuest.showWOForQuest(d);
    }

    private function addArrows():void {
        var im:Image;
        _leftArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.x = im.width;
        _leftArrow.addDisplayObject(im);
        _leftArrow.setPivots();
        _leftArrow.x = -220;
        _source.addChild(_leftArrow);
        _leftArrow.clickCallback = onLeftClick;

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.scaleX = -1;
        _rightArrow.addDisplayObject(im);
        _rightArrow.setPivots();
        _rightArrow.x = 220;
        _source.addChild(_rightArrow);
        _rightArrow.clickCallback = onRightClick;
    }

    private function checkArrows():void {
        _leftArrow.visible = Boolean(_shift > 0);
        _rightArrow.visible = Boolean(_shift + 3 < _items.length);
    }

    private function onLeftClick():void {
        if (_isAnim) return;
        if (_items.length < 4) return;
        if (_shift <=0) return;
        _shift--;
        _isAnim = true;
        TweenMax.to(_cont, .3, {x: -_shift*120, onComplete:onAnim});
    }

    private function onRightClick():void {
        if (_isAnim) return;
        if (_items.length < 4) return;
        if (_shift >= _items.length - 3) return;
        _shift++;
        _isAnim = true;
        TweenMax.to(_cont, .3, {x: -_shift*120, onComplete:onAnim});
    }

    private function onAnim():void {
        _isAnim = false;
        checkArrows();
    }

    private function deleteItems():void {
        for (var i:int=0; i<_items.length; i++) {
            if (_cont.contains(_items[i].source)) _cont.removeChild(_items[i].source);
            (_items[i] as WOQuestListItem).deleteIt();
        }
        _items = [];
    }

    override protected function deleteIt():void {
        deleteItems();
        if (_leftArrow) {
            _source.removeChild(_leftArrow);
            _leftArrow.deleteIt();
            _leftArrow = null;
        }
        if (_rightArrow) {
            _source.removeChild(_rightArrow);
            _rightArrow.deleteIt();
            _rightArrow = null;
        }
        if (_birka) {
            _source.removeChild(_birka);
            _birka.deleteIt();
            _birka = null;
        }
        super.deleteIt();
    }

}
}
