/**
 * Created by andy on 12/29/16.
 */
package windows.questList {
import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;
import quest.ManagerQuest;
import quest.QuestStructure;
import starling.display.Image;
import starling.textures.Texture;
import utils.CSprite;
import utils.MCScaler;

public class WOQuestListItem {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;
    private var _questData:QuestStructure;
    private var _onHover:Boolean;
    private var _clickCallback:Function;

    public function WOQuestListItem(d:QuestStructure, f:Function) {
        _clickCallback = f;
        _onHover = false;
        _source = new CSprite();
        _questData = d;
        g.load.loadImage(ManagerQuest.ICON_PATH + _questData.iconPath, onLoadIcon);
    }

    public function get source():CSprite {
        return _source;
    }

    private function onLoadIcon(bitmap:Bitmap):void {
        var im:Image = new Image(Texture.fromBitmap(bitmap));
        MCScaler.scale(im, 100, 100);
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _source.y = 54;
    }

    private function onOut():void {
        if (!_onHover) return;
        _onHover = false;
        _source.filter = null;
        _source.y = 60;
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_questData]);
        }
    }

    public function deleteIt():void {
        _clickCallback = null;
        _source.deleteIt();
        _questData = null;
    }
}
}
