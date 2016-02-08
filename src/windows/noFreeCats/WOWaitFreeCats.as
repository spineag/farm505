/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOWaitFreeCats extends Window{

    private var _contBtn:CButton;
    private var _txtText:TextField;
    private var _txtBtn:TextField;
    private var _woBG:WindowBackground;

    public function WOWaitFreeCats() {
        super();
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _txtText = new TextField(300,100,"НЕТ СВОБОДНЫХ КОТОВ!",g.allData.fonts['BloggerBold'],20,Color.WHITE);
        _txtText.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtText.touchable = false;
        _txtText.x = -150;
        _txtText.y = -155;
        var txt:TextField = new TextField(310,100,'Все коты сейчас заняты! Подождите окончания другого производства!',g.allData.fonts['BloggerBold'],14,Color.WHITE);
        txt.x = -160;
        txt.y = -120;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _source.addChild(txt);
        _contBtn = new CButton();
        _contBtn.addButtonTexture(130,40,CButton.YELLOW, true);
        _contBtn.clickCallback = onClick;
//        _contBtn.x =-_contBtn.width/2;
        _contBtn.y = 100;
        _source.addChild(_contBtn);
        _txtBtn = new TextField(_contBtn.width,_contBtn.height,"ОК",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _txtBtn.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
        _contBtn.addChild(_txtBtn);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
        im.x = -70;
        im.y = -70;
        _source.addChild(im);
        _source.addChild(_txtText);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    private function onClick():void {
        hideIt();
    }
}
}
