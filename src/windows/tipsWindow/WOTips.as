/**
 * Created by user on 8/8/16.
 */
package windows.tipsWindow {
import manager.ManagerFilters;
import starling.text.TextField;
import starling.utils.Color;

import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.DefaultVerticalScrollSprite;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTips  extends WindowMain {
    private var _woBG:WindowBackground;
    private var _carton:CartonBackground;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrTips:Array;
    private var _birka:Birka;

    public function WOTips() {
        super();
        _windowType = WindowsManager.WO_TIPS;
        _woWidth = 590;
        _woHeight = 540;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _callbackClickBG = hideIt;
        _carton = new CartonBackground(464, 444);
        _carton.filter = ManagerFilters.SHADOW_LIGHT;
        _carton.x = -232;
        _carton.y = -221;
        _source.addChild(_carton);
        var txt:TextField = new TextField(420,80,'Список действий',g.allData.bFonts['BloggerBold30'],30,Color.WHITE);
        txt.autoScale = true;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN2;
        txt.x = -210;
        txt.y = -240;
        txt.touchable = false;
        _source.addChild(txt);

        _scrollSprite = new DefaultVerticalScrollSprite(425, 408, 422, 68);
        _scrollSprite.source.x = -228;
        _scrollSprite.source.y = -190;
        _scrollSprite.createScoll(440, 0, 400, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        _source.addChild(_scrollSprite.source);
        createExitButton(hideIt);
        _birka = new Birka('ПОДСКАЗКИ', _source, _woWidth, _woHeight);
    }

    override public function showItParams(callback:Function, params:Array):void {
        createTips();
        fillTips();
        super.showIt();
    }
    
    private function createTips():void {
        var item:WOTipsItem;
        _arrTips = [];
        for (var i:int=0; i<11; i++) {
            item = new WOTipsItem(onItemClick);
            _scrollSprite.addNewCell(item.source);
            _arrTips.push(item);
        }
    }

    private function fillTips():void {
        var arr:Array = g.managerTips.getArrTips();
        for (var i:int=0; i<11; i++) {
            _arrTips[i].fillIt(arr[i]);
        }
    }
    
    private function onItemClick(ob:Object):void {
        if (g.managerTips) g.managerTips.onChooseTip(ob);
        super.hideIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_scrollSprite.source);
        _scrollSprite.resetAll();
        _scrollSprite.deleteIt();
        for (var i:int=0; i<11; i++) {
            _arrTips[i].deleteIt();
        }
        _arrTips.length = 0;
        _source.removeChild(_birka);
        _birka.deleteIt();
        _birka = null;
        _source.removeChild(_carton);
        _carton.deleteIt();
        _carton = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        super.deleteIt();
        g.managerTips.onHideWOTips();
    }

}
}
