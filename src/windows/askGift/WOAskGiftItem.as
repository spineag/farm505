/**
 * Created by andy on 8/3/17.
 */
package windows.askGift {
import data.StructureDataResource;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

public class WOAskGiftItem {
    private var g:Vars = Vars.getInstance();
    private var _dataResource:StructureDataResource;
    public var source:Sprite;
    private var _btn:CButton;
    private var _im:Image;
    private var _txtName:CTextField;

    public function WOAskGiftItem(id:int, onClick:Function) {  // 120x162
        _dataResource = g.allData.getResourceById(id);
        source = new Sprite();

        _im = new Image(g.allData.atlas[_dataResource.url].getTexture(_dataResource.imageShop));
        MCScaler.scale(_im, 80, 80);
        _im.x = 60 - _im.width/2;
        _im.y = 50 - _im.height/2;
        source.addChild(_im);

        _txtName = new CTextField(120,32,_dataResource.name);
        _txtName.setFormat(CTextField.MEDIUM18, 18, ManagerFilters.BLUE_COLOR);
        _txtName.y = 76;
        source.addChild(_txtName);

        _btn = new CButton();
        _btn.addButtonTexture(120, 42, CButton.GREEN, true);
        _btn.x = 60;
        _btn.y = 140;
        var t:CTextField = new CTextField(120,42,'Попросить');
        t.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        t.touchable = false;
        _btn.addChild(t);
        source.addChild(_btn);
        _btn.clickCallback = function():void { if (onClick!=null) onClick.apply(null, [_dataResource]); }
    }

    public function deleteIt():void {
        _dataResource = null;
        source.removeChild(_txtName);
        _txtName.deleteIt();
        _txtName = null;
        source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        source.dispose();
        source = null;
    }
}
}
