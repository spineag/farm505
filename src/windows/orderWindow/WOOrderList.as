/**
 * Created by user on 7/28/15.
 */
package windows.orderWindow {
import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class WOOrderList {
    public var source:Sprite;
    private var _contBtn:CSprite;
    private var _image:Image;
    private var _txtCount:TextField;

    private var g:Vars = Vars.getInstance();
    public function WOOrderList(ob:Object) {
        source = new Sprite();
        _contBtn = new CSprite();
        var q:Quad = new Quad(50, 50, Color.WHITE);
        q.pivotX = 0;
        q.pivotY = 0;
        if (ob.buildType == BuildType.PLANT || ob.buildType == BuildType.RESOURCE) {
            if(ob.url == "plantAtlas")
            {
                _image = new Image(g.plantAtlas.getTexture(ob.imageShop));
            }else {
                _image = new Image(g.resourceAtlas.getTexture(ob.imageShop));
            }
        }
        _txtCount = new TextField(50,50,"","Arial",12,Color.BLACK);
        _txtCount.text = String(g.userInventory.getCountResourceById(ob.id) +"/"+ "1");
        source.addChild(q);
       if (_image) source.addChild(_image);
        MCScaler.scale(_image,35,35);
        source.addChild(_txtCount);
        source.addChild(_contBtn);
        source.x = 100;
        source.y = 60;
    }
}
}
