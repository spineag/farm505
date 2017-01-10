/**
 * Created by andy on 12/29/16.
 */
package windows.questList {
import flash.display.Bitmap;
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

    public function WOQuestListItem(d:QuestStructure) {
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
    }

    public function deleteIt():void {
        _source.deleteIt();
        _questData = null;
    }
}
}
