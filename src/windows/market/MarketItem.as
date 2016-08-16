/**
 * Created by user on 6/24/15.
 */
package windows.market {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.display.Bitmap;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.Vars;
import resourceItem.CraftItem;
import resourceItem.DropItem;
import resourceItem.ResourceItem;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import temp.DropResourceVariaty;
import tutorial.TutorialAction;
import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;
import windows.WindowsManager;

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
    private var _coin:Image;
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
    private var _ava:Image;
    private var _avaDefault:Image;
    private var _countBuyCell:int;
    private var _papperBtn:CButton;
    private var _inPapper:Boolean;
    private var _inDelete:Boolean;
    private var _delete:CButton;
    private var _imCheck:Image;
    private var _btnBuyCont:CButton;
    private var _wo:WOMarket;
    private var _btnGoAwaySaleItem:CButton;
    private var g:Vars = Vars.getInstance();

    public function MarketItem(numberCell:int, close:Boolean, wo:WOMarket) {
        _wo = wo;
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

        _costTxt = new TextField(122, 30, '', g.allData.fonts['BloggerBold'], 15, Color.WHITE);
        _costTxt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _costTxt.y = 101;
        _costTxt.pivotX = _costTxt.width/2;
        _costTxt.x = _bg.width/2 - 5;

        _countTxt = new TextField(30, 30, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
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

        _plawkaCoins = new Sprite();
        source.addChild(_plawkaCoins);
        _plawkabuy = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_back'));
        _plawkabuy.x = 5;
        _plawkabuy.y = 100;
        _plawkaCoins.addChild(_plawkabuy);
        _coin  = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(_coin,25,25);
        _coin.y = 102;
        _coin.x = _bg.width/2 + 15;
        _plawkaCoins.addChild(_coin);
        _plawkaCoins.addChild(_costTxt);
        _plawkaCoins.visible = false;

        _papperBtn = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_icon_small'));
        _papperBtn.addDisplayObject(im);
        _papperBtn.setPivots();
        _papperBtn.x = 15;
        _papperBtn.y = 10;
        source.addChild(_papperBtn);
        _papperBtn.clickCallback = onPaper;
        _papperBtn.hoverCallback = function ():void {
            if (_inPapper || isFill == 2) return;
            g.hint.showIt('Поместить объявление в газету','market_paper');
        };
        _papperBtn.outCallback = function ():void {
            g.hint.hideIt();
        };
        _papperBtn.visible = false;

        _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _imCheck.x = 3;
        MCScaler.scale(_imCheck,20,20);
        source.addChild(_imCheck);
        _imCheck.visible = false;

        _delete = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_decline'));
        _delete.addDisplayObject(im);
        _delete.setPivots();
        _delete.x = 15;
        _delete.y = 110;
        source.addChild(_delete);
        _delete.clickCallback = onDelete;
        _delete.hoverCallback = function ():void {
            if (g.marketHint.isShowed)g.marketHint.hideIt();
            g.hint.showIt('забрать товар','market_delete');
        };
        _delete.outCallback = function ():void {
            g.hint.hideIt();
        };
        _delete.visible = false;

        if (_closeCell) {
            buyCont = new Sprite();
            if (numberCell == 5) _countBuyCell = 5;
            else _countBuyCell = (numberCell - 5) * 2 + 5;
            source.addChild(buyCont);
            var txt:TextField = new TextField(100,90,'Докупить торговое место',g.allData.fonts['BloggerBold'], 14, Color.WHITE);
            txt.x = 5;
            txt.y = 20;
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
            buyCont.addChild(txt);
            var _btnBuyCont:CButton = new CButton();
            _btnBuyCont.addButtonTexture(90,30,CButton.GREEN, true);
            txt = new TextField(30,30,String(String(_countBuyCell)),g.allData.fonts['BloggerBold'], 16, Color.WHITE);
            txt.x = 10;
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
            _btnBuyCont.addChild(txt);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            im.x = 55;
            im.y = 3;
            MCScaler.scale(im,25,25);
            _btnBuyCont.addChild(im);
            _btnBuyCont.y = 110;
            _btnBuyCont.x = 55;
            _btnBuyCont.clickCallback = onClickBuy;
            buyCont.addChild(_btnBuyCont);
            _txtAdditem.text = '';
        } else {
            source.endClickCallback = onClick;
        }
    }

    private function fillIt(data:Object, count:int,cost:int):void {
        if (_imageCont) unFillIt();
        var im:Image;
        _data = data;
        if (_data) {
            if (_data.buildType == BuildType.PLANT) {
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
            } else {
                im = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
            }
            if (!im) {
                Cc.error('MarketItem fillIt:: no such image: ' + _data.imageShop);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketItem');
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
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketItem');
            return;
        }
        _txtAdditem.text = '';
        _countResource = count;
        _countMoney = cost;
        _countTxt.text = String(_countResource);
        _plawkaCoins.visible = true;
        _costTxt.text = String(cost);
        _coin.y = 102;
        _coin.x = _bg.width/2 + 15;
        _txtPlawka.x = 10;
        _txtPlawka.y = 85;
        _costTxt.y = 101;
        _costTxt.pivotX = _costTxt.width/2;
        _costTxt.x = _bg.width/2 - 5;
        if (_isUser) {
            visiblePapperTimer();
        }
    }

    public function onChoose(a:int, count:int, cost:int, inPapper:Boolean):void {
        isFill = 1;
        g.directServer.addUserMarketItem(a, count, inPapper, cost, number, onAddToServer);
        g.userInventory.addResource(g.dataResource.objectResources[a].id, -count);
        fillIt(g.dataResource.objectResources[a],count, cost);
        _txtAdditem.text = '';
        g.managerCutScenes.checkCutSceneForAddToPapper(this);
    }

    private function onAddToServer(ob:Object):void {
        var obj:Object = {};
        obj.id = int(ob.id);
        obj.buyerId = ob.buyer_id;
        obj.cost = int(ob.cost);
        obj.inPapper = false;
        obj.resourceCount = int(ob.resource_count);
        obj.resourceId = int(ob.resource_id);
        obj.timeSold = ob.time_sold;
        obj.timeStart = ob.time_start;
        obj.timeInPapper = ob.time_in_papper;
        obj.numberCell = ob.number_cell;
        _dataFromServer = obj;
        g.user.marketItems.push(obj);
    }

    public function clearImageCont():void {
        if (!_imageCont) return;
        while (_imageCont.numChildren) {
            _imageCont.removeChildAt(0);
        }
    }

    private function onClickBuy():void {
        if (_countBuyCell > g.user.hardCurrency) {
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(1,-_countBuyCell);
        var f1:Function = function ():void {
            g.user.marketCell++;
            _txtAdditem.text = 'Добавить товар';
            source.endClickCallback = onClick;
            _wo.addItemsRefresh();
            _closeCell = false;
            _isUser = true;
            while (buyCont.numChildren) {
                buyCont.removeChildAt(0);
            }
        };
        g.directServer.updateUserMarketCell(1,f1);
    }

    private function onPaper():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_inPapper || !_wo.booleanPaper) return;
        _inPapper = true;
        _dataFromServer.inPapper = true;
        _papperBtn.visible = true;
        _imCheck.visible = true;
        g.hint.hideIt();
        _dataFromServer.timeInPapper = int(new Date().getTime() / 1000);
        _wo.startPapperTimer();
        g.directServer.updateMarketPapper(number,true,null);
    }

    public function visiblePapperTimer():void {
        if (isFill == 0 || isFill == 2) return;
        if (_inPapper) {
            if ((int(new Date().getTime() / 1000) - _dataFromServer.timeInPapper) * (-1) <= 10800) {
                _papperBtn.visible = true;
                _imCheck.visible = true;
            } else {
                _papperBtn.visible = false;
                _imCheck.visible = false;
                g.directServer.updateMarketPapper(number, false, null);
            }
        } else _papperBtn.visible = _wo.booleanPaper;
    }

    private function onDelete():void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        g.windowsManager.cashWindow = _wo;
        _wo.hideIt();
        g.marketHint.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_MARKET_DELETE_ITEM, deleteCallback, _data, _countResource);
    }

    private function deleteCallback():void {
        _papperBtn.visible = false;
        _imCheck.visible = false;
        _inPapper = false;
        g.userInventory.addMoney(1,-1);
        g.userInventory.addResource(_data.id, _data.count);
        g.gameDispatcher.removeFromTimer(onEnterFrame);
        g.directServer.deleteUserMarketItem(_dataFromServer.id, null);
        for (var i:int = 0; i < g.user.marketItems.length; i++) {
            if (g.user.marketItems[i].id == _dataFromServer.id) {
                g.user.marketItems.splice(i, 1);
                break;
            }
        }
        isFill = 0;
        unFillIt();
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_closeCell) return;
        if (g.managerTutorial.isTutorial) {
            if (!_data || !g.managerTutorial.isTutorialResource(_data.id)) return;
        }
        _onHover = false;
        g.marketHint.hideIt();
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        var i:int;
        if (isFill == 1) {//заполненная
            if (_isUser) {
                if (g.managerTutorial.isTutorial) return;
                //тут нужно показать поп-ап про то что за 1 диамант забираем ресурсы с базара
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
                    if (g.userInventory.currentCountInAmbar + _dataFromServer.resourceCount > g.user.ambarMaxCount) {
                        p = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        new FlyMessage(p, "Амбар заполнен");
                        return;
                    }
                } else if (d.placeBuild == BuildType.PLACE_SKLAD) {
                    if (g.userInventory.currentCountInSklad + _dataFromServer.resourceCount > g.user.skladMaxCount) {
                        p = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        new FlyMessage(p, "Склад заполнен");
                        return;
                    }
                }
                if (g.managerTutorial.isTutorial) {
                    if (g.managerTutorial.currentAction == TutorialAction.VISIT_NEIGHBOR)
                        g.managerTutorial.checkTutorialCallback();
                } else {
                    g.directServer.getUserMarketItem(_person.userSocialId, checkItemWhenYouBuy);
                }
            }
        } else if (isFill == 0) { // пустая
            if (g.managerTutorial.isTutorial) return;
            if (_isUser) {
                _wo.onItemClickAndOpenWOChoose(this);
                _onHover = false;
                _bg.filter = null;
            }
        } else if (isFill == 3){ // недоступна по лвлу

        } else {
            if (g.managerTutorial.isTutorial) return;
            if (_isUser) { // купленная
                g.directServer.deleteUserMarketItem(_dataFromServer.id, null);
                for (i=0; i<g.user.marketItems.length; i++) {
                    if (g.user.marketItems[i].id == _dataFromServer.id) {
                        g.user.marketItems.splice(i, 1);
                        break;
                    }
                }
                animCoin();
                isFill = 0;
                unFillIt();
            }
        }
        g.marketHint.hideIt();
    }

    private function checkItemWhenYouBuy():void {
        var b:Boolean = true;
        var bDelete:Boolean = true;
        for (var i:int = 0; i < _person.marketItems.length; i++) {
            if (number == _person.marketItems[i].numberCell && _person.marketItems[i].buyerId > 0) {
                b = false;
                break;
            }
        }
        if (b) {
            for (i = 0; i < _person.marketItems.length; i++) {
                if (number == _person.marketItems[i].numberCell) {
                    bDelete = true;
                    break;
                } else bDelete = false;
            }
        }
        if (_person.marketItems.length == 0) bDelete = false;
        if (_person is NeighborBot) bDelete = true;
        var p:Point;
        if (!bDelete) {
            p = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            new FlyMessage(p, "товар был забран игроком");
            _wo.refreshItemWhenYouBuy();
            return;
        }
        if (!b) {
            p = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            new FlyMessage(p, "товар был куплен другим игроком");
            _wo.refreshItemWhenYouBuy();
        } else {
            g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataFromServer.cost);
            var d:Object = g.dataResource.objectResources[_dataFromServer.resourceId];
            showFlyResource(d, _dataFromServer.resourceCount);
            _plawkaCoins.visible = false;
            _plawkaSold.visible = true;
            _txtPlawka.visible = true;
            _papperBtn.visible = false;
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
    }

    public function set callbackFill(f:Function):void {
        _callback = f;
    }

    private function animCoin():void {
        var x:Number;
        var y:Number;
        x = _imageCont.width/2;
        y = _imageCont.height/2;
        var p:Point = new Point(x, y);
        p = _imageCont.localToGlobal(p);
        var prise:Object = {};
        prise.id = DataMoney.SOFT_CURRENCY;
        prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
        prise.count = _countMoney;
        new DropItem(p.x, p.y, prise);
        _countMoney = 0;
        _countResource = 0;
        _inPapper = false;
        _papperBtn.visible = false;
        _imCheck.visible = false;
    }

    public function unFillIt():void {
        if (_closeCell) return;
        clearImageCont();
//        isFill = 0;
        _countMoney = 0;
        _countResource = 0;
        _costTxt.text = '';
        _countTxt.text = '';
        if (_isUser)_txtAdditem.text = 'Добавить товар';
        else _txtAdditem.text = '';
        _data = null;
        _personBuyerTemp = null;
        if (_btnGoAwaySaleItem) {
            source.removeChild(_btnGoAwaySaleItem);
            _btnGoAwaySaleItem.deleteIt();
            _btnGoAwaySaleItem = null;
        }
//        _quadGreen.visible = false;

//        if (_avaDefault) {
//            _avaDefault = null;
//            source.removeChild(_avaDefault);
//        }
//
//        if (_ava) {
//            _ava = null;
//        }
//        source.removeChild(_ava);
        _plawkabuy.visible = true;
        _plawkaCoins.visible = false;
        _plawkaSold.visible = false;
        _plawkaLvl.visible = false;
        _txtPlawka.visible = false;
        _delete.visible = false;
        g.marketHint.hideIt();
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
    }

    public function fillFromServer(obj:Object, p:Someone):void {
        if (_closeCell) return;
        _person = p;
        _dataFromServer = obj;
        if (_dataFromServer.buyerId != '0') {
            isFill = 2;
            _inPapper = _dataFromServer.inPapper;
            if (_person.userSocialId == g.user.userSocialId) { //sale yours item
                _plawkaSold.visible = false;
                _txtPlawka.visible = false;
//                _quadGreen.visible = true;
//                fillIt(g.dataResource.objectResources[_dataFromServer.resourceId],_dataFromServer.resourceCount, _dataFromServer.cost, true);
                showSaleImage(g.dataResource.objectResources[_dataFromServer.resourceId],_dataFromServer.cost);
                _plawkabuy.visible = false;
                _txtAdditem.text = '';
            } else { // sale anyway item
                _txtAdditem.text = '';
                fillIt(g.dataResource.objectResources[_dataFromServer.resourceId],_dataFromServer.resourceCount, _dataFromServer.cost);
                _plawkaCoins.visible = false;
                _plawkaLvl.visible = false;
                _plawkaSold.visible = true;
                _txtPlawka.visible = true;
            }
        } else { //have Item
            isFill = 1;
            _inPapper = _dataFromServer.inPapper;
            fillIt(g.dataResource.objectResources[_dataFromServer.resourceId],_dataFromServer.resourceCount, _dataFromServer.cost);
            if (g.dataResource.objectResources[_dataFromServer.resourceId].blockByLevel > g.user.level) { //have item but your level so small
                _plawkaCoins.visible = false;
                _plawkaLvl.visible = true;
                _plawkaLvl.y = 50;
                _txtPlawka.visible = true;
                _txtPlawka.y = 75;
                _txtPlawka.text = String("Доступно на уровне: " + g.dataResource.objectResources[_dataFromServer.resourceId].blockByLevel);
                _txtAdditem.text = '';
                isFill = 3;
            }
        }
    }

    public function set isUser(value:Boolean):void {
        _isUser = value;
    }

    private function showFlyResource(d:Object, count:int):void {
        var resource:ResourceItem = new ResourceItem();
        resource.fillIt(d);
        var item:CraftItem = new CraftItem(0,0,resource,source,count);
        item.flyIt(false,false);
    }

    private function showSaleImage(data:Object, cost:int):void {
        var i:int;
        if (_imageCont) unFillIt();
        var im:Image;
        _data = data;
        _papperBtn.visible = false;
        if (_data) {
            if (_data.buildType == BuildType.PLANT) {
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
            } else {
                im = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
            }
            if (!im) {
                Cc.error('MarketItem fillIt:: no such image: ' + _data.imageShop);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketItem');
                return;
            }
            MCScaler.scale(im, 45, 45);
            im.x = 2;
            im.y = 90;
            _imageCont.addChild(im);
        } else {
            Cc.error('MarketItem fillIt:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketItem');
            return;
        }
        _txtPlawka.visible = true;
        _txtPlawka.y = 45;
        _txtAdditem.text = '';
        _countMoney = cost;
        _coin.y = 85;
        _coin.x = _bg.width/2;

        _costTxt.y = 105;
        _costTxt.x = _bg.width/2 + 12;
        _plawkaCoins.visible = true;
        _costTxt.text = String(cost);
        if (_isUser) {
            visiblePapperTimer();
        }
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
        if (_personBuyer is NeighborBot && !_personBuyerTemp) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (!_personBuyer) {
                if (_person.photo) {
                    _avaDefault = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                    MCScaler.scale(_avaDefault, 75, 75);
                    _avaDefault.pivotX = _avaDefault.width/2;
                    _avaDefault.pivotY = _avaDefault.height/2;
                    _avaDefault.x = _bg.width/2 - 9;
                    _avaDefault.y = _bg.height/2 - 30;
//                    source.addChildAt(_avaDefault,1);
                    _imageCont.addChild(_avaDefault);
                }
                g.socialNetwork.getTempUsersInfoById([_personBuyerTemp.buyerSocialId], onGettingUserInfo);
            }
            else {
                if (_personBuyer.photo) {
                    if (_person.photo) {
                        _avaDefault = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                        MCScaler.scale(_avaDefault, 75, 75);
                        _avaDefault.pivotX = _avaDefault.width/2;
                        _avaDefault.pivotY = _avaDefault.height/2;
                        _avaDefault.x = _bg.width/2 - 9;
                        _avaDefault.y = _bg.height/2 - 30;
//                        source.addChildAt(_avaDefault,1);
                        _imageCont.addChild(_avaDefault);

                    }
                    g.load.loadImage(_personBuyer.photo, onLoadPhoto);
                } else {
                    if (_person.photo) {
                        _avaDefault = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                        MCScaler.scale(_avaDefault, 75, 75);
                        _avaDefault.pivotX = _avaDefault.width/2;
                        _avaDefault.pivotY = _ava.height/2;
                        _avaDefault.x = _bg.width/2 - 9;
                        _avaDefault.y = _bg.height/2 - 30;
//                        source.addChildAt(_avaDefault,1);
                        _imageCont.addChild(_avaDefault);

                    }
                    g.socialNetwork.getTempUsersInfoById([_personBuyer.userSocialId], onGettingUserInfo);
                }
            }
        }


        _btnGoAwaySaleItem = new CButton();
        _btnGoAwaySaleItem.addButtonTexture(70, 24, CButton.BLUE, true);
        var txt:TextField = new TextField(60, 30, 'посетить', g.allData.fonts['BloggerBold'], 14, Color.WHITE);
        txt.x = 4;
        txt.y = -4;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnGoAwaySaleItem.addChild(txt);
        source.addChild(_btnGoAwaySaleItem);

//
//        _btnGoAwaySaleItem = new CButton();
//        _btnGoAwaySaleItem.addButtonTexture(70,30,CButton.BLUE, true);
//        var txt:TextField = new TextField(60,30,'посетить',g.allData.fonts['BloggerBold'], 14, Color.WHITE);
//        txt.x = 4;
////        txt.y = 5;
//        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnGoAwaySaleItem.x = 55;
        _btnGoAwaySaleItem.y = 10;
        source.addChild(_btnGoAwaySaleItem);
        _btnGoAwaySaleItem.visible = false;
        var f1:Function = function ():void {

            if (_personBuyer) {
                if (g.visitedUser && g.visitedUser == _personBuyer) return;
                g.townArea.goAway(_personBuyer);
            }
            else {
                var person:Someone;
                person = new Someone();
                person = g.user.getSomeoneBySocialId(_personBuyerTemp.buyerSocialId);
                person.level = 15;
                if (g.visitedUser && g.visitedUser == person) return;
                g.townArea.goAway(person);
            }
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
        };
        _btnGoAwaySaleItem.clickCallback = f1;
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;

        if (isFill == 0 &&_isUser) {
            _bg.filter = ManagerFilters.BUILD_STROKE;
        } else if (isFill == 1 && !_isUser) {
            count = 1;
            g.gameDispatcher.addToTimer(onEnterFrame);
        }
        if (isFill == 1 && _isUser)_delete.visible = true;
        if (_isUser && isFill == 2) {
            _btnGoAwaySaleItem.visible = true;
        }
    }

    private function onOut():void {
        _onHover = false;
        if (isFill == 0 && _isUser) {
            _bg.filter = null;
        } else if (isFill == 1) {
            _delete.visible = false;
            g.marketHint.hideIt();
            g.gameDispatcher.removeFromTimer(onEnterFrame);
        }

        if (_isUser && isFill == 2) {
            _btnGoAwaySaleItem.visible = false;
        }
    }

    private var count:int;
    private function onEnterFrame():void {
        count--;
        if (count >= 0) {
            g.gameDispatcher.removeFromTimer(onEnterFrame);
            if (!g.resourceHint.isShowed && _onHover)
            if (_data && source) g.marketHint.showIt(_data.id,source.x,source.y,source);
        }
    }

    public function friendAdd(user:Boolean = false):void {
        if(_closeCell) return;
        if (!user)_txtAdditem.text = '';
        else {
            if (isFill == 1 ||  isFill == 2 ) {
                _txtAdditem.text = '';
            } else _txtAdditem.text = 'Добавить товар';
        }
        _isUser = user;
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
        if (_avaDefault) _avaDefault = null;
        if (source) source.removeChild(_avaDefault);
        _ava = new Image(tex);
        _ava.visible = true;
        MCScaler.scale(_ava, 75, 75);
        _ava.pivotX = _ava.width/2;
        _ava.pivotY = _ava.height/2;
        _ava.x = _bg.width/2 - 9;
        _ava.y = _bg.height/2 - 30;
//        source.addChildAt(_ava,1);
        _imageCont.addChild(_ava);
    }

    public function getItemProperties():Object {
        var ob:Object = {};
        ob.x = 0;
        ob.y = 0;
        var p:Point = new Point(ob.x, ob.y);
        p = source.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = _woWidth;
        ob.height = _woHeight;
        return ob;
    }

    public function deleteIt():void {
        if (buyCont && _btnBuyCont) {
            buyCont.removeChild(_btnBuyCont);
            _btnBuyCont.deleteIt();
            _btnBuyCont = null;
            buyCont = null;
        }
        source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        _callback = null;
        _data = null;
        _dataFromServer = null;
        _person = null;
        _personBuyer = null;
        _personBuyerTemp = null;
//        _quadGreen = null;
        _ava = null;
        if (_papperBtn) {
            source.removeChild(_papperBtn);
            _papperBtn.deleteIt();
            _papperBtn = null;
        }
        if (_delete) {
            source.removeChild(_delete);
            _delete.deleteIt();
            _delete = null;
        }
        if (_btnGoAwaySaleItem) {
            source.removeChild(_btnGoAwaySaleItem);
            _btnGoAwaySaleItem.deleteIt();
            _btnGoAwaySaleItem = null;
        }
        _imCheck = null;
        _costTxt = null;
        _countTxt = null;
        _txtPlawka = null;
        _txtAdditem = null;
        _wo = null;
        source.dispose();
        source = null;
    }

    public function getBoundsProperties(s:String):Object {
        var obj:Object;
        var p:Point = new Point();
        switch (s) {
            case 'papperIcon':
                obj = {};
                p.x = _papperBtn.x - _papperBtn.width/2;
                p.y = _papperBtn.y - _papperBtn.height/2;
                p = source.localToGlobal(p);
                obj.x = p.x;
                obj.y = p.y;
                obj.width = _papperBtn.width;
                obj.height = _papperBtn.height;
                break;
        }
        return obj;
    }
}
}
