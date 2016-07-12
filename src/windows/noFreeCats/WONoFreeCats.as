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

public class WONoFreeCats extends WindowMain {
    private var _btn:CButton;
    private var _woBG:WindowBackground;

    public function WONoFreeCats() {
        super();
        _windowType = WindowsManager.WO_NO_FREE_CATS;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        var txt:TextField = new TextField(400,100,"НЕТ СВОБОДНЫХ ПОМОЩНИКОВ!",g.allData.fonts['BloggerBold'],20,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.touchable = false;
        txt.x = -200;
        txt.y = -155;
        txt.touchable = false;
        _source.addChild(txt);
        txt = new TextField(400,100,'Подождите окончания производства или купите еще одного!',g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.x = -200;
        txt.y = -120;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.touchable = false;
        _source.addChild(txt);
        _btn = new CButton();
        _btn.addButtonTexture(130,40,CButton.GREEN, true);
        _btn.clickCallback = onClick;
        _btn.y = 100;
        _source.addChild(_btn);
        txt = new TextField(130, 40, "КУПИТЬ", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        txt.touchable = false;
        _btn.addChild(txt);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
        im.x = -40;
        im.y = -55;
        _source.addChild(im);
        txt.touchable = false;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        showIt();
    }

    private function onClick():void {
        super.hideIt();
        g.user.decorShop = false;
        g.user.decorShiftShop = 0;
        g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, 1);
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
