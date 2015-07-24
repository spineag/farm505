/**
 * Created by user on 7/24/15.
 */
package windows.dailyBonusWindow {
import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class WODailyBonusItem {
    public var source:Sprite;
    private var _imageItem:Image;
    private var _txtItem:TextField;

    private var g:Vars = Vars.getInstance();
    public function WODailyBonusItem(obj:Object) {
        source = new Sprite();
        _txtItem = new TextField(50,50,"","Arial",12,Color.WHITE);
        if (obj.buildType == BuildType.INSTRUMENT) {
            _imageItem = new Image(g.instrumentAtlas.getTexture(obj.imageShop));

        } else if (obj.buildType == BuildType.PLANT || obj.buildType == BuildType.RESOURCE) {
            if (obj.url == "plantAtlas") {
                _imageItem = new Image(g.plantAtlas.getTexture(obj.imageShop));
            } else {
                _imageItem = new Image(g.resourceAtlas.getTexture(obj.imageShop));
            }
        }
        g.userInventory.addResource(obj.id,1);
        MCScaler.scale(_imageItem, 50,50);
        if (_imageItem)source.addChild(_imageItem);
        source.addChild(_txtItem);
    }
}
}
