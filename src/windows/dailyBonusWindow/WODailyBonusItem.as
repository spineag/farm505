/**
 * Created by user on 7/24/15.
 */
package windows.dailyBonusWindow {
import com.junkbyte.console.Cc;

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
        if (!obj) {
            Cc.error('WODailyBonusItem:: empty data');
            g.woGameError.showIt();
            return;
        }
        source = new Sprite();
        _txtItem = new TextField(50,50,"","Arial",12,Color.WHITE);
        if (obj.buildType == BuildType.PLANT)
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(obj.imageShop + '_icon'));
        else
            _imageItem = new Image(g.allData.atlas[obj.url].getTexture(obj.imageShop));
        if (!_imageItem) {
            Cc.error('WODailyBonusItem:: no such image: ' + obj.imageShop);
            g.woGameError.showIt();
            return;
        }
        g.userInventory.addResource(obj.id,1);
        MCScaler.scale(_imageItem, 50,50);
        if (_imageItem)source.addChild(_imageItem);
        source.addChild(_txtItem);
    }
}
}
