/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOWaitFreeCats extends WindowMain{

    private var _btn:CButton;
    private var _woBG:WindowBackground;

    public function WOWaitFreeCats() {
        super();
        _windowType = WindowsManager.WO_WAIT_FREE_CATS;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _callbackClickBG = hideIt;
        createExitButton(hideIt);
        var txt:TextField = new TextField(400,100,"НЕТ СВОБОДНЫХ ПОМОЩНИКОВ!");
        txt.format.setTo(g.allData.bFonts['BloggerBold24'],20,Color.WHITE);
        txt.filter = ManagerFilters.TEXT_STROKE_BLUE;
        txt.touchable = false;
        txt.x = -200;
        txt.y = -155;
        _source.addChild(txt);
        txt = new TextField(400,100,'Все помощники сейчас заняты! Подождите окончания другого производства!');
        txt.format.setTo(g.allData.bFonts['BloggerBold18'],18,Color.WHITE);
        txt.x = -200;
        txt.y = -120;
        txt.filter = ManagerFilters.TEXT_STROKE_BLUE;
        txt.touchable = false;
        _source.addChild(txt);
        _btn = new CButton();
        _btn.addButtonTexture(130,40,CButton.GREEN, true);
        _btn.clickCallback = hideIt;
        _btn.y = 100;
        _source.addChild(_btn);
        txt = new TextField(130, 40, "ОК");
        txt.format.setTo(g.allData.bFonts['BloggerBold18'],18,Color.WHITE);
        txt.filter = ManagerFilters.TEXT_STROKE_GREEN;
        _btn.addChild(txt);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
        im.x = -40;
        im.y = -55;
        _source.addChild(im);
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        showIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        super.deleteIt();
    }
}
}
