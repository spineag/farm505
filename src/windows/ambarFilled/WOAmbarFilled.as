/**
 * Created by user on 8/19/15.
 */
package windows.ambarFilled {
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.ProgressBarComponent;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;
import windows.ambar.WOAmbars;

public class WOAmbarFilled extends WindowMain {

    private var _btn:CButton;
    private var _woBG:WindowBackground;
    private var _imageAmbar:Image;
    private var _txtBtn:CTextField;
    private var _txtAmbarFilled:CTextField;
    private var _txtCount:CTextField;
    private var _isAmbar:Boolean;
    private var _imAmbarSklad:Image;
    private var _bar:ProgressBarComponent;

    public function WOAmbarFilled() {
        super();
        _windowType = WindowsManager.WO_AMBAR_FILLED;
        _woWidth = 400;
        _woHeight = 300;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        SOUND_OPEN = SoundConst.WO_AHTUNG;

        _btn = new CButton();
        _btn.clickCallback = onClick;
        _btn.addButtonTexture(130, 40, CButton.YELLOW, true);
        _txtBtn = new CTextField(150,50,"");
        _txtBtn.setFormat(CTextField.BOLD14, 14, ManagerFilters.DARK_YELLOW_COLOR);
        _txtBtn.y = -5;
        _txtBtn.x = -10;
        _txtBtn.touchable = false;
        _btn.addChild(_txtBtn);
        _btn.y = 90;
        _source.addChild(_btn);
        _imageAmbar = new Image(g.allData.atlas['interfaceAtlas'].getTexture("storage_window_pr"));
        _imageAmbar.x = -160;
        _imageAmbar.y = -20;
        _imageAmbar.touchable = false;
        MCScaler.scale(_imageAmbar,49,320);
        _txtAmbarFilled = new CTextField(200,50,"");
        _txtAmbarFilled.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtAmbarFilled.x = -100;
        _txtAmbarFilled.y = -125;
        _txtAmbarFilled.touchable = false;
        _source.addChild(_txtAmbarFilled);
        _txtCount = new CTextField(200,50,"");
        _txtCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount.x = -95;
        _txtCount.y = 16;
        _txtCount.touchable = false;
        _source.addChild(_txtCount);
        _source.addChild(_imageAmbar);
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_l'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_r'), 308);
        _bar.x = _imageAmbar.x + 5;
        _bar.y = _imageAmbar.y + 9;
        _source.addChild(_bar);
    }

    private function onClick():void {
        hideIt();
        if (_isAmbar) {
            g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null, WOAmbars.AMBAR, true);
        } else {
            g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null, WOAmbars.SKLAD, true);
        }
    }

    override public function showItParams(callback:Function, params:Array):void {
        _isAmbar = params[0];
        if (_isAmbar) {
            _txtCount.text = "ВМЕСТИМОСТЬ:" + String(g.userInventory.currentCountInAmbar) + "/" + String(g.user.ambarMaxCount);
            _txtAmbarFilled.text = "АМБАР ЗАПОЛНЕН";
            _txtBtn.text = "Увеличить Амбар";
            _imAmbarSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('ambar_icon'));
        } else {
            _txtCount.text = "ВМЕСТИМОСТЬ:" + String(g.userInventory.currentCountInSklad) + "/" + String(g.user.skladMaxCount);
            _txtAmbarFilled.text = "СКЛАД ЗАПОЛНЕН";
            _txtBtn.text = "Увеличить Склад";
            _imAmbarSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('sklad_icon'));
        }
        _bar.progress = 1;
        MCScaler.scale(_imAmbarSklad, 60, 60);
        _imAmbarSklad.x = -_imAmbarSklad.width/2;
        _imAmbarSklad.y = _imageAmbar.y - 60;
        _source.addChild(_imAmbarSklad);
        onWoShowCallback = onShow;
        super.showIt();
    }
    
    private function onShow():void {
        _txtAmbarFilled.updateIt();
        _txtBtn.updateIt();
        _txtCount.updateIt();
    }

    override protected function deleteIt():void {
        _txtAmbarFilled = null;
        _txtBtn = null;
        _txtCount = null;
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_bar);
        _bar.deleteIt();
        _bar = null;
        super.deleteIt();
    }

}
}