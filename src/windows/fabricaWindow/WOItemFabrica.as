/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.text.TextField;

import tutorial.SimpleArrow;
import tutorial.TutorialAction;

import utils.CSprite;
import utils.MCScaler;

public class WOItemFabrica {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _dataRecipe:Object;
    private var _clickCallback:Function;
    private var _arrow:SimpleArrow;

    private var g:Vars = Vars.getInstance();

    public function WOItemFabrica() {
        source = new CSprite();
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_k'));
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        source.endClickCallback = onClick;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        source.alpha = .5;
    }

    public function fillData(ob:Object, f:Function):void {
        _dataRecipe = ob;
        if (!_dataRecipe || !g.dataResource.objectResources[_dataRecipe.idResource]) {
            Cc.error('WOItemFabrica:: empty _dataRecipe or g.dataResource.objectResources[_dataRecipe.idResource] == null');
            g.woGameError.showIt();
            return;
        }
        _clickCallback = f;
        if (_dataRecipe.blockByLevel == g.user.level + 1) {
            source.alpha = .5;
        } else if (_dataRecipe.blockByLevel <= g.user.level) {
            source.alpha = 1;
        } else {
            source.alpha = 0;
            Cc.error("Warning woItemFabrica filldata:: _dataRecipe.blockByLevel > g.user.level + 1");
        }
        fillIcon(g.dataResource.objectResources[_dataRecipe.idResource].imageShop);
        if (g.managerTutorial && g.managerTutorial.currentAction == TutorialAction.RAW_RECIPE && g.managerTutorial.isTutorialResource(_dataRecipe.id)) {
            addArrow();
        }
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(s));
        if (!_icon) {
            Cc.error('WOItemFabrica fillIcon:: no such image: ' + s);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(_icon, 80, 80);
        _icon.x = _bg.width/2 - _icon.width/2;
        _icon.y = _bg.height/2 - _icon.height/2;
        source.addChild(_icon);
    }

    public function unfillIt():void {
        removeArrow();
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _dataRecipe = null;
        _clickCallback = null;
        source.alpha = .5;
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.RAW_RECIPE) return;
        if (_dataRecipe.blockByLevel > g.user.level) return;
        source.filter = null;
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_dataRecipe]);
        }
        g.fabricHint.hideIt();
        if (g.managerTutorial && g.managerTutorial.currentAction == TutorialAction.RAW_RECIPE && g.managerTutorial.isTutorialResource(_dataRecipe.id)) {
            removeArrow();
            g.managerTutorial.checkTutorialCallback();
        }
    }

    private function onHover():void {
        if (!_dataRecipe) return;
        source.filter = ManagerFilters.YELLOW_STROKE;
        g.fabricHint.hideIt();
        var point:Point = new Point(0, 0);
        var pointGlobal:Point = source.localToGlobal(point);
        if (_dataRecipe.blockByLevel > g.user.level) {
            g.resourceHint.showIt(_dataRecipe.id,source.x,source.y,source,false,true);
            //resourcehint
        } else {
            g.fabricHint.showIt(_dataRecipe,pointGlobal.x, pointGlobal.y);

        }
    }

    private function onOut():void {
        if (!_dataRecipe) return;
        source.filter = null;
        g.fabricHint.hideIt();
        g.resourceHint.hideIt();
    }

    private function addArrow():void {
        removeArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, source, 1);
        _arrow.animateAtPosition(source.width/2, 0);
    }

    private function removeArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }
}
}
