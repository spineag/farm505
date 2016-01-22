/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WONoFreeCats extends Window{
    private var _contBtn:CSprite;
    private var _txtText:TextField;
    private var _txtBtn:TextField;
    private var _woBG:WindowBackground;


    public function WONoFreeCats() {
        super();
        _woWidth = 320;
        _woHeight = 300;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _txtText = new TextField(300,100,"Нету сводобных котов",g.allData.fonts['BloggerMedium'],20,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtText.touchable = false;
        _txtText.x = -150;
        _txtText.y = -120;
       var  bg:WOButtonTexture = new WOButtonTexture(130, 40, WOButtonTexture.BLUE);
        _contBtn = new CSprite();
        _contBtn.endClickCallback = onClick;
        _contBtn.addChild(bg);
        _contBtn.x =-_contBtn.width/2;
        _contBtn.y = 70;
        _source.addChild(_contBtn);
        _txtBtn = new TextField(_contBtn.width,_contBtn.height,"Купить",g.allData.fonts['BloggerMedium'],20,Color.WHITE);
        _txtBtn.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _contBtn.addChild(_txtBtn);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
        im.x = -70;
        im.y = -70;
        _source.addChild(im);
        _source.addChild(_txtText);
    }

    private function onClick():void {
        hideIt();
        g.woShop.activateTab(1);
        g.woShop.showIt();
    }
}
}
