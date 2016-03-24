/**
 * Created by user on 10/6/15.
 */
package windows.noFreeCats {
import manager.ManagerFilters;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WONoFreeCats extends WindowMain {
    private var _contBtn:CButton;
    private var _woBG:WindowBackground;

    public function WONoFreeCats() {
        super();
        _windowType = WindowsManager.WO_NO_FREE_CATS;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        var txt:TextField = new TextField(300,100,"НЕТ СВОБОДНЫХ КОТОВ!",g.allData.fonts['BloggerBold'],20,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.touchable = false;
        txt.x = -150;
        txt.y = -155;
        txt = new TextField(310,100,'Все коты сейчас заняты! Подождите окончания производства или купите еще одного!',g.allData.fonts['BloggerBold'],14,Color.WHITE);
        txt.x = -160;
        txt.y = -120;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _source.addChild(txt);
        _contBtn = new CButton();
        _contBtn.addButtonTexture(130,40,CButton.GREEN, true);
        _contBtn.clickCallback = onClick;
        _contBtn.y = 100;
        _source.addChild(_contBtn);
        txt = new TextField(_contBtn.width,_contBtn.height,"КУПИТЬ",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _contBtn.addChild(txt);
        var im:Image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
        im.x = -70;
        im.y = -70;
        _source.addChild(im);
        _source.addChild(txt);
    }

    private function onClick():void {
        hideIt();
        g.woShop.activateTab(1);
        g.woShop.showIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_contBtn);
        _contBtn.deleteIt();
        _contBtn = null;
        super.deleteIt();
    }
}
}
