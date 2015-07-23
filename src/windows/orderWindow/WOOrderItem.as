/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {
import data.BuildType;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class WOOrderItem {
    public var source:Sprite;
    private var _image:Image;
    private var _txtCoin:TextField;
    private var _txtXp:TextField;
    private var _txtCount:TextField;


    private var g:Vars = Vars.getInstance();
    public function WOOrderItem(ob:Object) {
        source = new Sprite();
         if (ob.buildType == BuildType.PLANT || ob.buildType == BuildType.RESOURCE) {
            if(ob.url == "plantAtlas")
            {
                _image = new Image(g.plantAtlas.getTexture(ob.imageShop));
            }else {
                _image = new Image(g.resourceAtlas.getTexture(ob.imageShop));
            }
        }

        _txtCoin = new TextField(50,50,"100", "Arial",12,Color.BLACK);
        _txtCoin.x = 10;
        _txtCoin.y = -110;
        _txtXp = new TextField(50,50,"150","Arial",12,Color.BLACK);
        _txtXp.x = 60;
        _txtXp.y = -110;
        _txtCount = new TextField(50,50,"","Arial",12,Color.BLACK);
        _txtCount.text = String(g.userInventory.getCountResourceById(g.dataResource.objectResources.ob) +"/"+ "1");
        _txtCount.x = -100;
        _txtCount.y = -70;
        MCScaler.scale(_image,70,70);
        _image.x = -100;
        _image.y = -100;
        source.addChild(_image);
        source.addChild(_txtCoin);
        source.addChild(_txtXp);
        source.addChild(_txtCount);
    }

}
}
