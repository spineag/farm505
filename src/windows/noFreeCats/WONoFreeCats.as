/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WONoFreeCats extends Window{
    private var _contBtn:CSprite;
    private var _txtText:TextField;
    private var _txtBtn:TextField;
    private var _imageBtn:Image;

    public function WONoFreeCats() {
        super();
        _woWidth = 300;
        _woHeight = 300;
        createTempBG();
        createExitButton(hideIt);
        _txtText = new TextField(300,100,"Нету сводобных котов","Arial",20,Color.BLACK);
        _txtText.x = -150;
        _txtText.y = -100;
        _imageBtn = new Image(g.allData.atlas['interfaceAtlas'].getTexture("btn3"));
        _contBtn = new CSprite();
        _contBtn.endClickCallback = onClick;
        _contBtn.addChild(_imageBtn);
        _contBtn.x =-_contBtn.width/2;
        _contBtn.y = 100;
        _source.addChild(_contBtn);
        _txtBtn = new TextField(_contBtn.width,_contBtn.height,"Купить","Arial",20,Color.BLACK);
        _contBtn.addChild(_txtBtn);
        _source.addChild(_txtText);
    }

    private function onClick():void {
        hideIt();
        g.woShop.activateTab(2);
        g.woShop.showIt();
    }
}
}
