/**
 * Created by user on 6/24/15.
 */
package windows.market {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import flash.display.Bitmap;

import flash.filters.GlowFilter;
import flash.geom.Point;
import hint.FlyMessage;

import manager.ManagerFilters;
import manager.Vars;
import resourceItem.ResourceItem;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import user.NeighborBot;

import user.Someone;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.CartonBackgroundIn;


public class MarketItem {
    public var source:CSprite;
    public var buyCont:Sprite;
    private var _costTxt:TextField;
    private var _countTxt:TextField;
    private var _txtPlawka:TextField;
    private var _txtAdditem:TextField;
    private var _bg:CartonBackgroundIn;
    private var quad:Quad;
    private var isFill:int;   //0 - пустая, 1 - заполненная, 2 - купленная  , 3 - недоступна по лвлу
    private var _callback:Function;
    private var _data:Object;
    private var _dataFromServer:Object;
    private var _countResource:int;
    private var _countMoney:int;
    private var _plawkaSold:Image;
    private var _plawkaLvl:Image;
    private var _plawkabuy:Image;
    private var _plawkaCoins:Sprite;
    private var _isUser:Boolean;
    private var _imageCont:Sprite;
    private var _person:Someone;
    private var _personBuyer:Someone;
    private var _personBuyerTemp:Object;
    public var number:int;
    private var _woWidth:int;
    private var _woHeight:int;
    private var _onHover:Boolean;
    private var _closeCell:Boolean;
    private var _quadGreen:Quad;
    private var _ava:Image;
    private var _countBuyCell:int;
    private var _papper:CButton;
    private var _inPapper:Boolean;
    private var _inDelete:Boolean;
    private var _delete:CButton;
    private var _imCheck:Image;

    private var g:Vars = Vars.getInstance();

    public function MarketItem(numberCell:int, close:Boolean) {
        _closeCell = close;
        number = numberCell;
        source = new CSprite();
        _onHover = false;
        _woWidth = 110;
        _woHeight = 133;
        _bg = new CartonBackgroundIn(_woWidth, _woHeight);
        source.addChild(_bg);
        quad = new Quad(_woWidth, _woHeight,Color.WHITE ,false);
        quad.alpha = 0;
        source.addChild(quad);
        isFill = 0;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _txtAdditem = new TextField(70,70,'',g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtAdditem.x = 20;
        _txtAdditem.y = 30;
        _txtAdditem.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        source.addChild(_txtAdditem);
        var im:Image;

        if (close) {
            buyCont = new Sprite();
            if (numberCell == 5) _countBuyCell = 5;
            else _countBuyCell = (numberCell - 5) * 2 + 5;
            source.addChild(buyCont);
            var txt:TextField = new TextField(100,90,'Докупить торговое место',g.allData.fonts['BloggerBold'], 14, Color.WHITE);
            txt.x = 5;
            txt.y = 20;
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
            buyCont.addChild(txt);
            var btn:CButton = new CButton();
            btn.addButtonTexture(90,30,CButton.GREEN, true);
            txt = new TextField(30,30,String(String(_countBuyCell)),g.allData.fonts['BloggerBold'], 16, Color.WHITE);
            txt.x = 10;
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
            btn.addChild(txt);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            im.x = 55;
            im.y = 3;
            MCScaler.scale(im,25,25);
            btn.addChild(im);
            btn.y = 110;
            btn.x = 55;
            btn.clickCallback = onClickBuy;
            buyCont.addChild(btn);
//            buyCont.x = 25;
//            buyCont.y = 30;
//            var quad11 = new Quad(buyCont.width, buyCont.height,Color.WHITE ,false);
//            buyCont.addChild(quad11);
            return;
        }

        _txtAdditem.text = 'Добавить товар';
        _quadGreen = new Quad(_woWidth,40,Color.GREEN,false);
        _quadGreen.y = 100;
        source.addChild(_quadGreen);
        _quadGreen.visible = false;


        _costTxt = new TextField(122, 30, '', g.allData.fonts['BloggerBold'], 15, Color.WHITE);
        _costTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _costTxt.y = 101;
        _costTxt.pivotX = _costTxt.width/2;
        _costTxt.x = _bg.width/2;

        _countTxt = new TextField(30, 30, '', g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        _countTxt.x = 77;
        _countTxt.y = 7;
        _countTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        source.addChild(_countTxt);

        _imageCont = new Sprite();
        source.addChild(_imageCont);

        _plawkaSold = new Image(g.allData.atlas['interfaceAtlas'].getTexture('roadside_shop_tabl'));
        _plawkaSold.pivotX = _plawkaSold.width/2;
        _plawkaSold.x = _bg.width/2;
        _plawkaSold.y = 70;
        source.addChild(_plawkaSold);
        _plawkaSold.visible = false;

        _plawkaLvl = new Image(g.allData.atlas['interfaceAtlas'].getTexture('available_on_level'));
        _plawkaLvl.pivotX = _plawkaLvl.width/2;
        _plawkaLvl.x = _bg.width/2;
        source.addChild(_plawkaLvl);

        _plawkaLvl.visible = false;

        _txtPlawka = new TextField(90,60, 'Продано', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        _txtPlawka.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtPlawka.x = 10;
        _txtPlawka.y = 85;
        _txtPlawka.visible = false;
        source.addChild(_txtPlawka);

        source.endClickCallback = onClick;

        _plawkaCoins = new Sprite();
        source.addChild(_plawkaCoins);
        _plawkabuy = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_back'));
        _plawkabuy.x = 5;
        _plawkabuy.y = 100;
        _plawkaCoins.addChild(_plawkabuy);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(im,25,25);
        im.y = 102;
        im.x = _bg.width/2 + 15;
        _plawkaCoins.addChild(im);
        _plawkaCoins.addChild(_costTxt);
        _plawkaCoins.visible = false;

        _papper = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_icon_small'));
        _papper.addDisplayObject(im);
        _papper.setPivots();
        _papper.x = 10;
        _papper.y = 10;
        source.addChild(_papper);
        _papper.clickCallback = onPaper;
        _papper.visible = false;

        _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        MCScaler.scale(_imCheck,20,20);
//        _imCheck.x = 5;
//        _imCheck.y = 5;
        source.addChild(_imCheck);
        _imCheck.visible = false;

        _delete = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_decline'));
        _delete.addDisplayObject(im);
        _delete.setPivots();
        _delete.x = 10;
        _delete.y = 110;
        source.addChild(_delete);
        _delete.clickCallback = onDelete;
        _delete.visible = false;
    }

    private function fillIt(data:Object, count:int,cost:int, isFromServer:Boolean = false):void {
        if (_imageCont) unFillIt();
        var im:Image;
        isFill = 1;
        _data = data;
        if (_data) {
            if (_data.buildType == BuildType.PLANT) {
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
            } else {
                im = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
            }
            if (!im) {
                Cc.error('MarketItem fillIt:: no such image: ' + _data.imageShop);
                g.woGameError.showIt();
                return;
            }
            MCScaler.scale(im, 80, 80);
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = _bg.width/2 - 10;
            im.y = _bg.height/2 - 15;
            _imageCont.addChild(im);
        } else {
            Cc.error('MarketItem fillIt:: empty _data');
            g.woGameError.showIt();
            return;
        }
        _txtAdditem.text = '';
        _countResource = count;
        _countMoney = cost;
        if (!isFromServer) g.userInventory.addResource(_data.id, -_countResource);
        _countTxt.text = String(_countResource);
        _plawkaCoins.visible = true;
        _costTxt.text = String(cost);
    }

    public function clearImageCont():void {
        if (!_imageCont) return;
        while (_imageCont.numChildren) {
            _imageCont.removeChildAt(0);
        }
    }

    private function onClickBuy():void {
        if (_countBuyCell > g.user.hardCurrency) {
            g.woBuyCurrency.showItMenu(true);
            return;
        }
        g.userInventory.addMoney(1,-_countBuyCell);
        g.directServer.updateUserMarketCell(1,null);
        g.user.marketCell++;
        _txtAdditem.text = 'Добавить товар';
        source.endClickCallback = onClick;
        g.woMarket.addItemsRefresh();
        _closeCell = false;
        while (buyCont.numChildren) {
            buyCont.removeChildAt(0);
        }
    }

    private function onPaper ():void {
        var b:Boolean = g.woMarket.booleanPaper;
        if (_inPapper || !b) return;
        _inPapper = true;
        _imCheck.visible = true;
        g.woMarket.startTimer();
        g.directServer.updateMarketPapper(number,true,null);
    }

    private function onDelete ():void {
        if (g.user.hardCurrency < 1) {
            g.woBuyCurrency.showItMenu(true);
            return;
        }
        _papper.visible = false;
        _imCheck.visible = false;
        _inPapper = false;
        g.userInventory.addMoney(1,-1);
        g.directServer.deleteUserMarketItem(_dataFromServer.id, null);
        for (var i:int = 0; i < g.user.marketItems.length; i++) {
            if (g.user.marketItems[i].id == _dataFromServer.id) {
                g.user.marketItems.splice(i, 1);
                break;
            }
        }
        unFillIt();
    }

    private function onClick():void {
        _onHover = false;
        g.marketHint.hideIt();
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        var i:int;
        if (isFill == 1) {//заполненная
            if (_isUser) {
                //тут нужно показать поп-ап про то что за 1 диамант забираем ресурсы с базара
//                    trace(_dataFromServer.numberCell)
            } else {
                if (_plawkaSold.visible == true) return;
                var p:Point;
                if (g.user.softCurrencyCount < _dataFromServer.cost) {
                    p = new Point(source.x, source.y);
                    p = source.parent.localToGlobal(p);
                    new FlyMessage(p, "Недостаточно денег");
                    return;
                }
                var d:Object = g.dataResource.objectResources[_dataFromServer.resourceId];
                if (d.placeBuild == BuildType.PLACE_AMBAR) {
                    if (g.userInventory.currentCountInAmbar + _dataFromServer.resourceCount >= g.user.ambarMaxCount) {
                        p = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        new FlyMessage(p, "Амбар заполнен");
                        return;
                    }
                } else if (d.placeBuild == BuildType.PLACE_SKLAD) {
                    if (g.userInventory.currentCountInSklad + _dataFromServer.resourceCount >= g.user.skladMaxCount) {
                        p = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        new FlyMessage(p, "Склад заполнен");
                        return;
                    }
                }
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataFromServer.cost);

                showFlyResource(d, _dataFromServer.resourceCount);
                _plawkaCoins.visible = false;
                _plawkaSold.visible = true;
                _txtPlawka.visible = true;
                if (_person == g.user.neighbor) {
                    g.directServer.buyFromNeighborMarket(_dataFromServer.id, null);
                    _dataFromServer.resourceId = -1;
                } else {
                    g.directServer.buyFromMarket(_dataFromServer.id, null);
                    var arr:Array = g.user.arrFriends.concat(g.user.arrTempUsers);
                    for (var j:int = 0; j< arr.length; j++) {
                        if (!arr[j].marketItems) continue;
                        for (i = 0; i < arr[j].marketItems.length; i++) {
                            if (arr[j].marketItems[i].id == _dataFromServer.id) {
                                arr[j].marketItems[i].buyerId = g.user.userId;
                                arr[j].marketItems[i].inPapper = false;
                                arr[j].marketItems[i].buyerSocialId = g.user.userSocialId;
                                return;
                            }
                        }
                    }
                }
                isFill = 2;
            }
        } else if (isFill == 0) { // пустая
            if (_isUser) {
                g.woMarket.hideIt();
                g.woMarket.marketChoose.callback = onChoose;
                g.woMarket.marketChoose.showIt();
                _onHover = false;
                _bg.filter = null;
            }
        } else if (isFill == 3){ // недоступна по лвлу

        } else {
            if (_isUser) { // купленная
                g.userInventory.addMoney(2,_dataFromServer.cost);
                g.directServer.deleteUserMarketItem(_dataFromServer.id, null);
                for (i=0; i<g.user.marketItems.length; i++) {
                    if (g.user.marketItems[i].id == _dataFromServer.id) {
                        g.user.marketItems.splice(i, 1);
                        break;
                    }
                }
                animCoin();
                unFillIt();
            }
        }
    }

    private var counter:int;
    private function onChoose(a:int, count:int = 0, cost:int = 0, inPapper:Boolean = false):void {
        g.woMarket.showIt();
        if (a > 0) {
            fillIt(g.dataResource.objectResources[a],count, cost);
            _txtAdditem.text = '';
            g.directServer.addUserMarketItem(a, count, inPapper, cost, number, onAddToServer);
        }
    }

    private function onAddToServer(ob:Object):void {
        var obj:Object = {};
        obj.id = int(ob.id);
        obj.buyerId = ob.buyer_id;
        obj.cost = int(ob.cost);
        obj.inPapper = Boolean(ob.in_papper);
        obj.resourceCount = int(ob.resource_count);
        obj.resourceId = int(ob.resource_id);
        obj.timeSold = ob.time_sold;
        obj.timeStart = ob.time_start;
        obj.numberCell = ob.number_cell;
        _dataFromServer = obj;
        g.user.marketItems.push(obj);
    }

    public function set callbackFill(f:Function):void {
        _callback = f;
    }

    private function animCoin():void {
        var eP:Point = g.softHardCurrency.getSoftCurrencyPoint();
        var s:Sprite = new Sprite();
        s.addChild(new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins')));
        MCScaler.scale(s, 50, 50);
        s.pivotX = s.width / 2;
        s.pivotY = s.height / 2;
        var sP:Point = new Point(80, 110);
        sP = source.localToGlobal(sP);
        s.x = sP.x;
        s.y = sP.y;
        g.cont.animationsResourceCont.addChild(s);

        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(s);
            s.dispose();
            s = null;
            _countMoney = 0;
            _countResource = 0;
        };
        new TweenMax(s, 1, {x:eP.x, y:eP.y, ease:Linear.easeOut ,onComplete: f1});
    }

    public function unFillIt():void {
        if(_closeCell) return;
        clearImageCont();
        isFill = 0;
        _countMoney = 0;
        _countResource = 0;
        _costTxt.text = '';
        _countTxt.text = '';
        if (_isUser)_txtAdditem.text = 'Добавить товар';
        else _txtAdditem.text = '';
        _data = null;
        _personBuyerTemp = null;
        _quadGreen.visible = false;
        source.removeChild(_ava);
        _plawkabuy.visible = true;
        _plawkaCoins.visible = false;
        _plawkaSold.visible = false;
        _plawkaLvl.visible = false;
        _txtPlawka.visible = false;
        _delete.visible = false;
//        _papper.visible = false;
        g.marketHint.hideIt();
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
    }

    public function fillFromServer(obj:Object, p:Someone):void {
        if (_closeCell) return;
        _person = p;
        _isUser = Boolean(p == g.user);
        _dataFromServer = obj;
        if (_dataFromServer.buyerId != '0') {
            if (_person.userSocialId == g.user.userSocialId) {
                _plawkaSold.visible = false;
                _txtPlawka.visible = false;
                _quadGreen.visible = true;
                fillIt(g.dataResource.objectResources[_dataFromServer.resourceId],_dataFromServer.resourceCount, _dataFromServer.cost, true);
                showSaleImage();
                _plawkabuy.visible = false;
                _txtAdditem.text = '';
            }
            else {
                _txtAdditem.text = '';
                fillIt(g.dataResource.objectResources[_dataFromServer.resourceId],_dataFromServer.resourceCount, _dataFromServer.cost, true);
                _plawkaCoins.visible = false;
                _plawkaLvl.visible = false;
                _plawkaSold.visible = true;
                _txtPlawka.visible = true;
            }
            isFill = 2;
        } else {
            _inPapper = _dataFromServer.inPapper;
            if (_inPapper) {
                _papper.visible = true;
                _imCheck.visible = true;
            }
            isFill = 1;
            fillIt(g.dataResource.objectResources[_dataFromServer.resourceId],_dataFromServer.resourceCount, _dataFromServer.cost, true);
            if (g.dataResource.objectResources[_dataFromServer.resourceId].blockByLevel > g.user.level) {
                _plawkaCoins.visible = false;
                _plawkaLvl.visible = true;
                _plawkaLvl.y = 50;
                _txtPlawka.visible = true;
                _txtPlawka.y = 75;
                _txtPlawka.text = String("Доступно на уровне: " + g.dataResource.objectResources[_dataFromServer.resourceId].blockByLevel);
                _txtAdditem.text = '';
                isFill = 3;
                return;
            }
        }
    }

    public function set isUser(value:Boolean):void {
        _isUser = value;
    }

    private function showFlyResource(d:Object, count:int):void {
        var im:Image;
        if (!d) {
            Cc.error('MarketItem showFlyResource:: empty data');
            g.woGameError.showIt();
            return;
        }
        if (_data.buildType == BuildType.PLANT) {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
        } else {
            im = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
        }
        if (!im) {
            Cc.error('MarketItem showFlyResource:: no such image: ' + d.imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(im, 100, 100);
        var p:Point = new Point(0, 0);
        p = source.localToGlobal(p);
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        im.x = p.x;
        im.y = p.y;
        g.cont.animationsResourceCont.addChild(im);
        g.craftPanel.showIt(d.placeBuild);
        p = g.craftPanel.pointXY();
        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(im);
            im.dispose();
            g.userInventory.addResource(d.id, count);
            var item:ResourceItem = new ResourceItem();
            item.fillIt(d);
            g.craftPanel.afterFly(item);
        };
        new TweenMax(im, .5, {x:p.x, y:p.y, ease:Linear.easeOut ,onComplete: f1});
    }

    private function showSaleImage():void {
        var i:int;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('sale'));
        im.pivotY = im.height/2;
        im.x = 3;
        im.y = _bg.height/2 -15;
        _imageCont.addChild(im);
        _quadGreen.visible = true;
        _costTxt.text = String(_dataFromServer.cost);
        if (_dataFromServer.buyerSocialId == 1) {
            _personBuyer = g.user.neighbor;
        } else {
            for (i = 0; i < g.user.arrFriends.length; i++) {
                if (_dataFromServer.buyerSocialId == g.user.arrFriends[i].userSocialId) {
                    _personBuyer = g.user.arrFriends[i];
                    break;
                }
            }
            if (!_personBuyer) {

                for (i = 0; i < g.user.marketItems.length; i++) {
                    if (_dataFromServer.buyerSocialId == g.user.marketItems[i].buyerSocialId) {
                        _personBuyerTemp = g.user.marketItems[i];
                        break;
                    }
                }
            }
        }
        if (_personBuyer is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (!_personBuyer) g.socialNetwork.getTempUsersInfoById([_personBuyerTemp.buyerSocialId], onGettingUserInfo);
            else {
                if (_personBuyer.photo) {
                    g.load.loadImage(_personBuyer.photo, onLoadPhoto);
                } else {
                    g.socialNetwork.getTempUsersInfoById([_personBuyer.userSocialId], onGettingUserInfo);
                }
            }
        }
    }

    private function onHover():void {
        if (isFill == 0 &&_isUser) {
            if (_onHover) return;
            _onHover = true;
            _bg.filter = ManagerFilters.BUILD_STROKE;
        }
        if (isFill == 1) {
            if (_onHover) return;
            _onHover = true;
            var b:Boolean = g.woMarket.booleanPaper;
            if (!_inPapper || !b) _papper.visible = true;
            _delete.visible = true;
            count = 0;
            g.gameDispatcher.addEnterFrame(onEnterFrame);
        }
    }

    private function onOut():void {
        if (isFill == 0 &&_isUser) {
            _onHover = false;
            _bg.filter = null;
        }
        if (isFill == 1) {
            _onHover = false;
            if (!_inPapper) _papper.visible = false;
            _delete.visible = false;
            g.marketHint.hideIt();
            g.gameDispatcher.removeEnterFrame(onEnterFrame);
        }
    }

    private var count:int;
    private function onEnterFrame():void {
        count++;
        if (count >= 10) {
            if (!g.resourceHint.isShowed && _onHover)
                g.marketHint.showIt(_data.id,source.x,source.y,source);
            g.gameDispatcher.removeEnterFrame(onEnterFrame);
            count = 0;
        }
    }

    public function friendAdd(user:Boolean = false):void {
        if(_closeCell) return;
        if (!user)_txtAdditem.text = '';
        else {
            if (isFill == 1 ||  isFill == 2 ) {
                _txtAdditem.text = '';
            }else _txtAdditem.text = 'Добавить товар';
        }
    }

    private function onGettingUserInfo(ar:Array):void {
        if (!_personBuyer) {
            _personBuyerTemp.photo = ar[0].photo_100;
            g.load.loadImage(_personBuyerTemp.photo, onLoadPhoto);
        }
        else {
            _personBuyer.photo = ar[0].photo_100;
            g.load.loadImage(_personBuyer.photo, onLoadPhoto);
        }

    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            if (!_personBuyer)  bitmap = g.pBitmaps[_personBuyerTemp.photo].create() as Bitmap;
            else bitmap = g.pBitmaps[_personBuyer.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('FriendItem:: no photo for userId: ' + _personBuyerTemp.buyerSocialId + 'or ' + _personBuyer.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _ava = new Image(tex);
        _ava.visible = true;
        MCScaler.scale(_ava, 35, 35);
        _ava.x = 2;
        _ava.y = 102;
        source.addChild(_ava);
    }
}
}
