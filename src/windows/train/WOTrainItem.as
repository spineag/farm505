/**
 * Created by user on 7/24/15.
 */
package windows.train {
import build.train.TrainCell;
import com.junkbyte.console.Cc;
import data.BuildType;

import flash.display.Bitmap;

import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetwork;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import starling.utils.Padding;

import user.NeighborBot;

import user.Someone;

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
    private var _needHelp:Image;
    private var _personBuyer:Someone;
    private var _personBuyerTemp:Object;
    private var _ava:Image;
    private var _avaDefault:Image;
    private var _imageCont:Sprite;

    private var g:Vars = Vars.getInstance();

    public function WOTrainItem() {
        _index = -1;
        source = new CSprite();
        _txtWhite = new CTextField(60,30,'-3');
        _txtWhite.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtWhite.alignH = Align.RIGHT;
        _txtWhite.x = 23;
        _txtWhite.y = 60;
        _txtRed = new CTextField(60,30,'');
        _txtRed.setFormat(CTextField.BOLD18, 18, ManagerFilters.ORANGE_COLOR, ManagerFilters.BROWN_COLOR);
        _txtRed.alignH = Align.RIGHT;
        _txtRed.y = 60;
        _imageCont= new Sprite();
        source.addChild(_imageCont);
        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        MCScaler.scale(_galo4ka, 30, 30);
        _galo4ka.x = 65;
        _galo4ka.y = 5;
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
        if (!t) {
            Cc.error('WOTrainItem fillIt:: trainCell==null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
        if (!g.allData.getResourceById(_info.id)) {
            Cc.error('WOTrainItem fillIt:: g.dataResource.objectResources[_info.id]==null for: ' + _info.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
            if (int(_info.helpId) != 0) {
                return;
            }
        var curCount:int = g.userInventory.getCountResourceById(_info.id);
        if (curCount >= _info.count) {
            _txtRed.changeTextColor = ManagerFilters.LIGHT_GREEN_COLOR;
        } else {
            _txtRed.changeTextColor = ManagerFilters.ORANGE_COLOR;
        }
        _txtWhite.visible = true;
        _txtRed.visible = true;
        _txtRed.text = String(curCount);
        _txtWhite.text = '/' + String(_info.count);
        _txtWhite.x = 23;
        _txtRed.x = 23 - _txtWhite.textBounds.width;
        _im = currentImage();
        if (!_im) {
            Cc.error('WOTrainItem fillIt:: no such image: ' + g.allData.getResourceById(_info.id).imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
        MCScaler.scale(_im, 80, 80);
        _im.x = 45 - _im.width / 2;
        _im.y = 45 - _im.height / 2;
        source.addChild(_im);
        source.addChild(_txtWhite);
        source.addChild(_txtRed);
        source.addChild(_galo4ka);
        source.endClickCallback = onClick;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        if (isResourceLoaded) {
            _galo4ka.visible = true;
            _txtWhite.text = '';
            _txtRed.text = '';
            _txtWhite.visible = false;
            _txtRed.visible = false;
        }
            if (_info.needHelp && !_needHelp && int(_info.helpId) == 0) {
                _needHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
                source.addChild(_needHelp);
            }
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[_personBuyer.photo].create() as Bitmap;
            Cc.info('bitmap JA JA NATURLIH');
        }
        if (!bitmap) {
            Cc.error('FriendItem:: no photo for userId: ' + _personBuyerTemp.buyerSocialId + 'or ' + _personBuyer.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        if (tex) {
            Cc.info('avatar JA JA NATURLIH');
            _ava = new Image(tex);
            MCScaler.scale(_ava, 75, 75);
            _ava.x = 7;
            _ava.y = 7;
            _imageCont.addChild(_ava);
            if (_galo4ka) _galo4ka.visible = true;
            if (_needHelp) _needHelp.visible = false;
        } else {
            Cc.error('MarketItem photoFromTexture:: no texture(')
        }
    }

    public function set clickCallback(f:Function):void {
        _f = f;
    }

    public function get idFree():int {
        if (_info) return _info.id;
        else return 0;
    }

    public function get countFree():int {
        if (_info) return _info.count;
        else return 0;

    }

    public function get needHelp():Boolean {
        if (_info) return _info.needHelp;
        else return false;
    }

    public function get idWhoHelp():String {
        if (_info) return _info.helpId;
        else return ' ';
    }

    public function get trainDbId():String {
        if (_info) return _info.item_db_id;
        else return '';
    }

    public function onClickHelpMePls(b:Boolean = false):void {
        if (b) {
            _needHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
            source.addChild(_needHelp);
        } else {
            if (_needHelp) {
                source.removeChild(_needHelp);
                _needHelp = null;
            }
        }
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
        if (!_info) return false;
        else return _info.canBeFull();
    }

    public function fullIt():void {
        _galo4ka.visible = true;
        _txtWhite.visible = false;
        _txtRed.visible = false;
//        updateTextField();
        _info.fullIt(_im);
    }

    public function fullItHelp():void {
        _galo4ka.visible = true;
        _txtWhite.visible = false;
        _txtRed.visible = false;
        _needHelp.visible = false;
        _info.whoHelpId(String(g.user.userSocialId));
        _info.needHelpNow(false);
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
        if (_bg) {
            if (v) {
                _bg.filter = ManagerFilters.YELLOW_STROKE;
            } else {
                _bg.filter = null;
            }
        } else {
            Cc.error('WOTrainItem activateIt:: no _bg');
        }
    }

    public function get countXP():int {
        if (_info) return _info.countXP;
        else return 0;
    }

    public function get countCoins():int {
        if (_info) return _info.countMoney;
        else return 0;
    }

    public function currentImage():Image{
        if (g.allData.getResourceById(_info.id).buildType == BuildType.PLANT)
            return new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_info.id).imageShop + '_icon'));
        else
            return new Image(g.allData.atlas[g.allData.getResourceById(_info.id).url].getTexture(g.allData.getResourceById(_info.id).imageShop));
    }

    public function updateIt():void {
        if (_info) {
            if (!_galo4ka.visible) {
                _txtWhite.visible = true;
                _txtRed.visible = true;
                var curCount:int = g.userInventory.getCountResourceById(_info.id);
                _txtRed.text = String(g.userInventory.getCountResourceById(_info.id));
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
        if (_txtWhite) {
            source.removeChild(_txtWhite);
            _txtWhite.deleteIt();
            _txtWhite = null;
        }
        if (_txtRed) {
            source.removeChild(_txtRed);
            _txtRed.deleteIt();
            _txtRed = null;
        }
        _txtWhite = null;
        _txtRed = null;
        _f = null;
        _galo4ka = null;
        _bg.filter = null;
        _bg = null;
        source.deleteIt();
        source = null;
    }

    public function updateAvatar():void {
            if (!_personBuyer || !_personBuyer.photo) _personBuyer = g.user.getSomeoneBySocialId(_info.helpId);
            if (_personBuyer.photo == '' || _personBuyer.photo == 'unknown') _personBuyer.photo = SocialNetwork.getDefaultAvatar();
        Cc.info('updateAvatar JA JA NATURLIH');
        g.load.loadImage(_personBuyer.photo, onLoadPhoto);
    }
}
}
