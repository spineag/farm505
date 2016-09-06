/**
 * Created by user on 7/24/15.
 */
package windows.train {
import build.train.TrainCell;
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class WOTrainItem {
    public var source:CSprite;
    private var _im:Image;
    private var _info:TrainCell;
    private var _txtWhite:CTextField;
    private var _txtRed:CTextField;
    private var _index:int;
    private var _f:Function;
    private var _galo4ka:Image;
    private var _bg:Image;
    private var _isHover:Boolean;

    private var g:Vars = Vars.getInstance();

    public function WOTrainItem() {
        _index = -1;
        source = new CSprite();
        _txtWhite = new CTextField(60,30,'-3');
        _txtWhite.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtWhite.alignH = Align.RIGHT;
        _txtWhite.x = 23;
        _txtWhite.y = 60;
        _txtRed = new CTextField(30,30,'');
        _txtRed.setFormat(CTextField.BOLD18, 18, ManagerFilters.ORANGE_COLOR, ManagerFilters.BROWN_COLOR);
        _txtRed.alignH = Align.RIGHT;
        _txtRed.y = 60;
        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        MCScaler.scale(_galo4ka, 30, 30);
        _galo4ka.x = 65;
        _galo4ka.y = 60;
        source.addChild(_galo4ka);
        _galo4ka.visible = false;
        _isHover = false;
    }

    public function fillIt(t:TrainCell, i:int, type:int):void {
        _index = i;
        if (_bg) {
            source.removeChild(_bg);
            _bg.dispose();
            _bg = null;
        }
        switch (type) {
            case (WOTrain.CELL_BLUE):
                _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_blue'));
                source.addChildAt(_bg, 0);
                break;
            case (WOTrain.CELL_GREEN):
                _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_green'));
                source.addChildAt(_bg, 0);
                break;
            case (WOTrain.CELL_RED):
                _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_red'));
                source.addChildAt(_bg, 0);
                break;
            case (WOTrain.CELL_GRAY):
                _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_gray'));
                source.addChildAt(_bg, 0);
                _txtWhite.text = '';
                _txtRed.text = '';
                return;
                break;
        }
        _info = t;
        if (!t || !g.dataResource.objectResources[_info.id]) {
            Cc.error('WOTrainItem fillIt:: trainCell==null or g.dataResource.objectResources[_info.id]==null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
        var curCount:int = g.userInventory.getCountResourceById(_info.id);
        if (curCount >= _info.count) {
           _txtRed.changeTextColor = ManagerFilters.LIGHT_GREEN_COLOR;
        } else {
            _txtRed.changeTextColor = ManagerFilters.ORANGE_COLOR;
        }
        _txtRed.text = String(curCount);
        _txtWhite.text = '/' + String(_info.count);
        _txtWhite.x = 23;
        _txtRed.x = 50 -_txtWhite.textBounds.width ;
        _im = currentImage();
        if (!_im) {
            Cc.error('WOTrainItem fillIt:: no such image: ' + g.dataResource.objectResources[_info.id].imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
        MCScaler.scale(_im, 80, 80);
        _im.x = 45 - _im.width/2;
        _im.y = 45 - _im.height/2;
        source.addChild(_im);
        source.addChild(_txtWhite);
        source.addChild(_txtRed);
        source.addChild(_galo4ka);
        source.endClickCallback = onClick;
        source.hoverCallback = onHover ;
        source.outCallback = onOut;
        if (isResourceLoaded) {
            _galo4ka.visible = true;
            _txtWhite.text = '';
            _txtRed.text = '';
        }
    }

    public function set clickCallback(f:Function):void {
        _f = f;
    }

    public function get idFree():int {
        return _info.id;
    }

    public function get countFree():int {
        return _info.count;
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_f != null) {
            _f.apply(null, [_index]);
        }
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        g.marketHint.showIt(_info.id,source.x, source.y, source);
    }

    private function onOut():void {
        _isHover = false;
        g.marketHint.hideIt();
    }

    public function get isResourceLoaded():Boolean {
        if (!_info) return false;
        else return _info.isFull;
    }

    public function canFull():Boolean {
        return _info.canBeFull();
    }

    public function fullIt():void {
        _galo4ka.visible = true;
        _txtWhite.text = '';
        _txtRed.text = '';
        _info.fullIt(_im);
    }

    public function clearIt():void {
        _galo4ka.visible = false;
        _txtWhite.text = '';
        _txtRed.text = '';
        _index = -1;
        if (_im) {
            source.removeChild(_im);
            _im.dispose();
            _im = null;
        }
        source.endClickCallback = null;
        if (_bg) {
            _bg.filter = null;
            source.removeChild(_bg);
            _bg.dispose();
            _bg = null;
        }
    }

    public function activateIt(v:Boolean):void {
        if (v) {
            _bg.filter = ManagerFilters.YELLOW_STROKE;
        } else {
            _bg.filter = null;
        }
    }

    public function get countXP():int {
        return _info.countXP;
    }

    public function get countCoins():int {
        return _info.countMoney;
    }

    public function currentImage():Image{
        if (g.dataResource.objectResources[_info.id].buildType == BuildType.PLANT)
            return new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_info.id].imageShop + '_icon'));
        else
            return new Image(g.allData.atlas[g.dataResource.objectResources[_info.id].url].getTexture(g.dataResource.objectResources[_info.id].imageShop));
    }

    public function updateIt():void {
        if (_info) {
            if (!_galo4ka.visible) {
                var curCount:int = g.userInventory.getCountResourceById(_info.id);
                _txtRed.text = String(g.userInventory.getCountResourceById(_info.id));
//                if (curCount >= _info.count) {
//                    _txtWhite.text = String(g.userInventory.getCountResourceById(_info.id) + '/' + String(_info.count));
//                    _txtWhite.x = 23;
//                } else {
//                    _txtRed.text = String(curCount);
//                    _txtWhite.text = '/' + String(_info.count);
//
//                    _txtWhite.x = 23;
//                    _txtRed.x = 50 -_txtWhite.textBounds.width ;
//                }
                if (curCount >= _info.count) {
                    _txtRed.changeTextColor = ManagerFilters.LIGHT_GREEN_COLOR;
                } else {
                    _txtRed.changeTextColor = ManagerFilters.ORANGE_COLOR;
                }
            }
        }
    }

    public function deleteIt():void {
        _im = null;
        _info = null;
        _txtWhite = null;
        _txtRed = null;
        _f = null;
        _galo4ka = null;
        _bg.filter = null;
        _bg = null;
        source.deleteIt();
        source = null;
    }
}
}
