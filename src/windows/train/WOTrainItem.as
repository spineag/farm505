/**
 * Created by user on 7/24/15.
 */
package windows.train {
import build.train.TrainCell;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import resourceItem.DropItem;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;
import temp.DropResourceVariaty;
import ui.xpPanel.XPStar;
import utils.CSprite;
import utils.MCScaler;

public class WOTrainItem {
    public var source:CSprite;
    private var _im:Image;
    private var _info:TrainCell;
    private var _txt:TextField;
    private var _index:int;
    private var _f:Function;
    private var _galo4ka:Image;
    private var _bg:Image;

    private var g:Vars = Vars.getInstance();

    public function WOTrainItem() {
        _index = -1;
        source = new CSprite();
        _txt = new TextField(40,30,'-3', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txt.hAlign = HAlign.RIGHT;
        _txt.x = 43;
        _txt.y = 60;
        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        MCScaler.scale(_galo4ka, 30, 30);
        _galo4ka.x = 65;
        _galo4ka.y = 60;
        source.addChild(_galo4ka);
        _galo4ka.visible = false;
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
                _txt.text = '';
                return;
                break;
        }
        _info = t;
        if (!t || !g.dataResource.objectResources[_info.id]) {
            Cc.error('WOTrainItem fillIt:: trainCell==null or g.dataResource.objectResources[_info.id]==null');
            g.woGameError.showIt();
            return;
        }

        _txt.text = String(g.userInventory.getCountResourceById(_info.id) + '/' + String(_info.count));
        _im = currentImage();
        if (!_im) {
            Cc.error('WOTrainItem fillIt:: no such image: ' + g.dataResource.objectResources[_info.id].imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(_im, 80, 80);
        _im.x = 45 - _im.width/2;
        _im.y = 45 - _im.height/2;
        source.addChild(_im);
        source.addChild(_txt);
        source.endClickCallback = onClick;
        if (isResourceLoaded) {
            _galo4ka.visible = true;
            _txt.text = '';
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
        if (_f != null) {
            _f.apply(null, [_index]);
        }
    }

    public function get isResourceLoaded():Boolean {
        return _info.isFull;
    }

    public function canFull():Boolean {
        return _info.canBeFull();
    }

    public function fullIt():void {
        _galo4ka.visible = true;
        _txt.text = '';
        _info.fullIt(_im);

        var p:Point = new Point(source.width/2, source.height/2);
        p = source.localToGlobal(p);
        new XPStar(p.x, p.y, 100);
        var prise:Object = {};
        prise.id = DataMoney.SOFT_CURRENCY;
        prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
        prise.count = 100;
        new DropItem(p.x, p.y, prise);
    }

    public function clearIt():void {
        _galo4ka.visible = false;
        _txt.text = '';
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
                _txt.text = String(g.userInventory.getCountResourceById(_info.id) + '/' + String(_info.count));
            }
        }
    }
}
}
