/**
 * Created by user on 6/24/15.
 */
package windows.market {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import data.StructureDataResource;
import data.StructureMarketItem;

import flash.display.Bitmap;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.Vars;

import quest.ManagerQuest;

import resourceItem.CraftItem;
import resourceItem.DropItem;
import resourceItem.DropPartyResource;
import resourceItem.ResourceItem;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import temp.DropResourceVariaty;
import tutorial.TutorialAction;
import tutorial.managerCutScenes.ManagerCutScenes;
import tutorial.miniScenes.ManagerMiniScenes;

import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;
import windows.WindowsManager;

public class MarketItem {
    public var source:CSprite;
    public var buyCont:Sprite;
    private var _costTxt:CTextField;
    private var _countTxt:CTextField;
    private var _txtPlawka:CTextField;
    private var _txtAdditem:CTextField;
    private var _bg:CartonBackgroundIn;
    private var quad:Quad;
    private var isFill:int;   //0 - пустая, 1 - заполненная, 2 - купленная  , 3 - недоступна по лвлу
    private var _callback:Function;
    private var _data:Object;
    private var _dataFromServer:StructureMarketItem;
    private var _countResource:int;
    private var _countMoney:int;
    private var _plawkaSold:Image;
    private var _plawkaLvl:Image;
    private var _plawkaBuy:Image;
    private var _coin:Image;
    private var _plawkaCoins:Sprite;
    private var _isUser:Boolean;
    private var _imageCont:Sprite;
    private var _person:Someone;
    private var _personBuyer:Someone;
    private var _personBuyerTempItem:StructureMarketItem;
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
    private var _txtBuyNewPlace:CTextField;
    private var _txtBuyCell:CTextField;
    private var _txtGo:CTextField;
    private var _photoUrl:String;
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
        quad = new Quad(_woWidth, _woHeight,Color.WHITE);
        quad.alpha = 0;
        source.addChild(quad);
        isFill = 0;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _txtAdditem = new CTextField(80,70,String(g.managerLanguage.allTexts[388]));
        _txtAdditem.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtAdditem.cacheIt = false;
        _txtAdditem.x = 15;
        _txtAdditem.y = 30;
        source.addChild(_txtAdditem);
        _txtAdditem.visible = true;

        _costTxt = new CTextField(122, 30, '');
        _costTxt.setFormat(CTextField.BOLD18, 15, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _costTxt.cacheIt = false;
        _costTxt.y = 99;
        _costTxt.pivotX = _costTxt.width/2;
        _costTxt.x = _bg.width/2 - 5;

        _countTxt = new CTextField(30, 30, ' ');
        _countTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _countTxt.cacheIt = false;
        _countTxt.x = 77;
        _countTxt.y = 3;
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

        _txtPlawka = new CTextField(100,60, String(g.managerLanguage.allTexts[389]));
        _txtPlawka.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.GRAY_HARD_COLOR);
        _txtPlawka.cacheIt = false;
        _txtPlawka.y = 85;
//        _txtPlawka.x = -30;
        _txtPlawka.visible = false;
        source.addChild(_txtPlawka);

        _plawkaCoins = new Sprite();
        source.addChild(_plawkaCoins);
        _plawkaBuy = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_back'));
        _plawkaBuy.x = 5;
        _plawkaBuy.y = 100;
        _plawkaCoins.addChild(_plawkaBuy);
        _coin  = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(_coin,25,25);
        _coin.y = 102;
        _coin.x = _bg.width/2 + 15;
        _plawkaCoins.addChild(_coin);
        _plawkaCoins.addChild(_costTxt);
        _plawkaCoins.visible = false;

        _papperBtn = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_icon_small'));
        MCScaler.scale(im,im.height/2+5, im.width/2+5);
        _papperBtn.addDisplayObject(im);
        _papperBtn.setPivots();
        _papperBtn.x = 20;
        _papperBtn.y = 10;
        _papperBtn.alpha = 1;
        source.addChild(_papperBtn);
        _papperBtn.clickCallback = onPaper;
        _papperBtn.hoverCallback = function ():void {
            if (_inPapper || isFill == 2) return;
            g.hint.showIt(String(g.managerLanguage.allTexts[390]),'market_paper');
        };
        _papperBtn.outCallback = function ():void {
            g.hint.hideIt();
        };
        _papperBtn.visible = false;

        _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _imCheck.x = 8;
        _imCheck.y = -3;
        MCScaler.scale(_imCheck,25,25);
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
            if (g.marketHint.isShowed) g.marketHint.hideIt();
            g.hint.showIt(String(g.managerLanguage.allTexts[391]),'market_delete');
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
            _txtBuyNewPlace = new CTextField(100,90,String(g.managerLanguage.allTexts[392]));
            _txtBuyNewPlace.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
            _txtBuyNewPlace.cacheIt = false;
            _txtBuyNewPlace.x = 5;
            _txtBuyNewPlace.y = 0;
            buyCont.addChild(_txtBuyNewPlace);
            _btnBuyCont = new CButton();
            _btnBuyCont.addButtonTexture(90,34,CButton.GREEN, true);
            _txtBuyCell = new CTextField(30,30,String(String(_countBuyCell)));
            _txtBuyCell.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _txtBuyCell.cacheIt = false;
            _txtBuyCell.x = 15;
            _txtBuyCell.y = 3;
            _btnBuyCont.addChild(_txtBuyCell);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            im.x = 55;
            im.y = 6;
            MCScaler.scale(im,25,25);
            _btnBuyCont.addChild(im);
            _btnBuyCont.y = 110;
            _btnBuyCont.x = 55;
            _btnBuyCont.clickCallback = onClickBuy;
            buyCont.addChild(_btnBuyCont);
            _txtAdditem.visible = false;
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
        _txtAdditem.visible = false;
        _countResource = count;
        _countMoney = cost;
        _countTxt.text = String(_countResource);
        _countTxt.visible = true;

        _plawkaCoins.visible = true;
        _costTxt.text = String(cost);
        _coin.y = 102;
        _coin.x = _bg.width/2 + 15;
        _txtPlawka.x = 5;
        _txtPlawka.y = 85;
        _costTxt.y = 99;
        _costTxt.pivotX = _costTxt.width/2;
        _costTxt.x = _bg.width/2 - 5;
        if (_isUser) {
            visiblePapperTimer();
        }
    }

    public function onChoose(id:int, level:int, count:int, cost:int, inPapper:Boolean):void {
        if (isFill == 1) return;
        isFill = 1;
        g.directServer.addUserMarketItem(id, level, count, inPapper, cost, number, onAddToServer);
        g.userInventory.addResource(id, -count);
        fillIt(g.allData.getResourceById(id),count, cost);
        _txtAdditem.visible = false;
        if(inPapper) {
            if (_papperBtn) {
                _papperBtn.visible = true;
            }
            if (_imCheck) _imCheck.visible = true;
            _wo.startPapperTimer();
//            g.directServer.updateMarketPapper(number, true, null);
            _inPapper = true;
        } else if (_wo.booleanPaper) g.managerCutScenes.checkCutSceneForAddToPapper(this);

    }

    private function onAddToServer(ob:Object):void {
        _dataFromServer = new StructureMarketItem(ob);
        g.user.marketItems.push(_dataFromServer);
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
        _btnBuyCont.clickCallback = null;
        g.userInventory.addMoney(1,-_countBuyCell);
        var f1:Function = function ():void {
            g.user.marketCell++;
            _txtAdditem.visible = true;
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
        if (g.managerCutScenes.isCutScene) {
            if (g.managerCutScenes.curCutSceneProperties.reason == ManagerCutScenes.REASON_ADD_TO_PAPPER) {
                g.managerCutScenes.checkCutSceneCallback();
            } else return;
        }
        if (_inPapper || !_wo.booleanPaper) return;
        _inPapper = true;
        _dataFromServer.inPapper = true;
        _papperBtn.visible = true;
        _imCheck.visible = true;
        _papperBtn.alpha = .8;
        g.managerAchievement.addAll(11,1);
        g.hint.hideIt();
        _dataFromServer.timeInPapper = int(new Date().getTime() / 1000);
        _wo.startPapperTimer();
        g.directServer.updateMarketPapper(number,true,null);
        g.managerQuest.onActionForTaskType(ManagerQuest.SET_IN_PAPER);
    }

    public function visiblePapperTimer():void {
        if (isFill == 0 || isFill == 2) return;
        if (_inPapper) {
            if ((int(new Date().getTime() / 1000) - _dataFromServer.timeInPapper) * (-1) <= 10800) {
                if (_papperBtn) {
                    _papperBtn.visible = true;
                    _papperBtn.alpha = .8;
                }
                if (_imCheck) _imCheck.visible = true;
            } else {
                if (_papperBtn) {
                    _papperBtn.visible = false;
                    _papperBtn.alpha = 1;
                }
                _imCheck.visible = false;
                g.directServer.updateMarketPapper(number, false, null);
            }
        } else {
            if (_papperBtn) _papperBtn.visible = _wo.booleanPaper;
        }
    }

    private function onDelete():void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;

        var f1:Function = function():void {
            for (var i:int = 0; i < g.user.marketItems.length; i++) {
                if (g.user.marketItems[i].numberCell == number) {
                    if (g.user.marketItems[i].buyerId > 0) {
                        _wo.refreshItemWhenYouBuy();
                        return;
                    }
                    else break;
                }
            }
            g.windowsManager.cashWindow = _wo;
            _wo.hideIt();
            g.marketHint.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_MARKET_DELETE_ITEM, deleteCallback, _data, _countResource);
        };
        g.directServer.getUserMarketItem(g.user.userSocialId, f1);
    }

    private function deleteCallback():void {
        _papperBtn.visible = false;
        _imCheck.visible = false;
        _papperBtn.alpha = 1;
        _inPapper = false;
        g.userInventory.addMoney(1,-1);
        g.userInventory.addResource(_data.id, _countResource);
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
                    new FlyMessage(p, String(g.managerLanguage.allTexts[393]));
                    return;
                }
                var d:Object = g.allData.getResourceById(_dataFromServer.resourceId);
                if (d.placeBuild == BuildType.PLACE_AMBAR) {
                    if (g.userInventory.currentCountInAmbar + _dataFromServer.resourceCount > g.user.ambarMaxCount) {
                        p = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        new FlyMessage(p,String(g.managerLanguage.allTexts[394]));
                        return;
                    }
                } else if (d.placeBuild == BuildType.PLACE_SKLAD) {
                    if (g.userInventory.currentCountInSklad + _dataFromServer.resourceCount > g.user.skladMaxCount) {
                        p = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        new FlyMessage(p, String(g.managerLanguage.allTexts[395]));
                        return;
                    }
                }
                if (g.managerTutorial.isTutorial) {
                    if (g.managerTutorial.currentAction == TutorialAction.VISIT_NEIGHBOR)
                        g.managerTutorial.checkTutorialCallback();
                }
                if (g.managerMiniScenes.isMiniScene && g.managerMiniScenes.isReason(ManagerMiniScenes.BUY_INSTRUMENT)) g.managerMiniScenes.checkMiniSceneCallback();

                isFill = 2;
                g.directServer.getUserMarketItem(_person.userSocialId, checkItemWhenYouBuy);
                g.managerQuest.onActionForTaskType(ManagerQuest.BUY_PAPER);
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
                g.managerAchievement.addAll(2,_countMoney);
                if (g.managerParty.eventOn && g.managerParty.typeParty == 3 && g.managerParty.typeBuilding == BuildType.MARKET && g.allData.atlas['partyAtlas']&&g.managerParty.levelToStart <= g.user.level) new DropPartyResource(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
                animCoin();
                isFill = 0;
                unFillIt();
            }
        }
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.marketHint.hideIt();
    }

    private function checkItemWhenYouBuy():void {
        var b:Boolean = true;
        var bDelete:Boolean = true;
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.marketHint.hideIt();
        if (!_person) {
            Cc.error('MarketItem checkItemWhenYouBuy:: no _person');
            return;
        }
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
            new FlyMessage(p, String(g.managerLanguage.allTexts[396]));
            _wo.refreshItemWhenYouBuy();
            return;
        }
        if (!b) {
            p = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            new FlyMessage(p, String(g.managerLanguage.allTexts[397]));
            _wo.refreshItemWhenYouBuy();
        } else {
            g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataFromServer.cost);
            var d:StructureDataResource = g.allData.getResourceById(_dataFromServer.resourceId);
            showFlyResource(d, _dataFromServer.resourceCount);
            g.managerAchievement.addAll(24,_dataFromServer.cost);
            _plawkaCoins.visible = false;
            _plawkaSold.visible = true;
            _txtPlawka.visible = true;
            _papperBtn.visible = false;
            if (_person == g.user.neighbor) {
                g.directServer.buyFromNeighborMarket(_dataFromServer.id, null);
                _dataFromServer.resourceId = -1;
            } else {
                _dataFromServer.userSocialId = _person.userSocialId;
                g.directServer.buyFromMarket(_dataFromServer, null);
                _dataFromServer.buyerId = g.user.userId;
                _dataFromServer.inPapper = false;
                _dataFromServer.buyerSocialId = g.user.userSocialId;
                g.managerPaper.onBuyAtMarket(_dataFromServer);
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
        _papperBtn.alpha = 1;

    }

    public function unFillIt():void {
        if (_closeCell) return;
        clearImageCont();
//        isFill = 0;
        _countMoney = 0;
        _countResource = 0;
        if (_costTxt) _costTxt.text = '';
        if(_countTxt) {
            _countTxt.text = '';
            _countTxt.visible = false;
        }
        if (_isUser) _txtAdditem.visible = true;
        else _txtAdditem.visible = false;
        if (_data) _data = null;
        if (_personBuyerTempItem) _personBuyerTempItem = null;
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
        if (_plawkaBuy) _plawkaBuy.visible = true;
        if (_plawkaCoins) _plawkaCoins.visible = false;
        if (_plawkaSold) _plawkaSold.visible = false;
        if (_plawkaLvl) _plawkaLvl.visible = false;
        if (_txtPlawka) _txtPlawka.visible = false;
        if (_delete) _delete.visible = false;
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.marketHint.hideIt();
    }

    public function fillFromServer(obj:StructureMarketItem, p:Someone):void {
        if (_closeCell) return;
        _person = p;
        _dataFromServer = obj;
        if (_dataFromServer.buyerId != 0) {
            isFill = 2;
            _inPapper = _dataFromServer.inPapper;
            if (_person.userSocialId == g.user.userSocialId) { //sale yours item
                _plawkaSold.visible = false;
                _txtPlawka.visible = false;
//                _quadGreen.visible = true;
//                fillIt(g.dataResource.objectResources[_dataFromServer.resourceId],_dataFromServer.resourceCount, _dataFromServer.cost, true);
                try {
                    showSaleImage(g.allData.getResourceById(_dataFromServer.resourceId), _dataFromServer.cost);
                } catch (e:Error) {
                    Cc.error('at showSaleImage');
                }
                _plawkaBuy.visible = false;
                _txtAdditem.visible = false;
            } else { // sale anyway item
                _txtAdditem.visible = false;
                fillIt(g.allData.getResourceById(_dataFromServer.resourceId), _dataFromServer.resourceCount, _dataFromServer.cost);
                _plawkaCoins.visible = false;
                _plawkaLvl.visible = false;
                _plawkaSold.visible = true;
                _txtPlawka.visible = true;
            }
        } else { //have Item
            isFill = 1;
            if (_person is NeighborBot) {
                if (g.allData.getResourceById(_dataFromServer.resourceId).buildType == BuildType.INSTRUMENT) {
                    _dataFromServer.resourceCount = 1;
                    _dataFromServer.cost *= 3;
                }
            }

            _inPapper = _dataFromServer.inPapper;
            fillIt(g.allData.getResourceById(_dataFromServer.resourceId), _dataFromServer.resourceCount, _dataFromServer.cost);
            if (g.allData.getResourceById(_dataFromServer.resourceId).blockByLevel > g.user.level) { //have item but your level so small
                _plawkaCoins.visible = false;
                _plawkaLvl.visible = true;
                _plawkaLvl.y = 50;
                _txtPlawka.visible = true;
                _txtPlawka.y = 75;
                _txtPlawka.text = String(String(g.managerLanguage.allTexts[398]) + " " + g.allData.getResourceById(_dataFromServer.resourceId).blockByLevel);
                _txtAdditem.visible = false;
                isFill = 3;
            }
        }
    }

    public function set isUser(value:Boolean):void {
        _isUser = value;
    }

    private function showFlyResource(d:StructureDataResource, count:int):void {
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
        if(_papperBtn) _papperBtn.visible = false;
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
            if (_imageCont) _imageCont.addChild(im);
        } else {
            Cc.error('MarketItem fillIt:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketItem');
            return;
        }
        if (_txtPlawka) {
            _txtPlawka.visible = true;
            _txtPlawka.y = 45;
        }
        if (_txtAdditem) _txtAdditem.visible = false;
        _countMoney = cost;
        if (_coin) {
            _coin.y = 85;
            _coin.x = _bg.width / 2;
        }
        if (_costTxt) {
            _costTxt.y = 105;
            _costTxt.x = _bg.width / 2 + 12;
        }
        if (_plawkaCoins) _plawkaCoins.visible = true;
        if (_costTxt) _costTxt.text = String(cost);
        if (_isUser) {
            visiblePapperTimer();
        }
//        _costTxt.text = String(_dataFromServer.cost); ?? double
        if (_dataFromServer.buyerSocialId == '1') {
            _personBuyer = g.user.neighbor;
            _personBuyerTempItem = null;
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
                        _personBuyerTempItem = g.user.marketItems[i];
                        break;
                    }
                }
            }
        }
        if (_personBuyer && _personBuyer is NeighborBot && !_personBuyerTempItem) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (!_imageCont) {
                Cc.error('MarketItem:: showScaleImage:: no _imageCont');
                return;
            }
            if (!_personBuyer) {
                _avaDefault = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                if (_avaDefault) {
                    MCScaler.scale(_avaDefault, 75, 75);
                    _avaDefault.pivotX = _avaDefault.width/2;
                    _avaDefault.pivotY = _avaDefault.height/2;
                    _avaDefault.x = _bg.width/2 - 9;
                    _avaDefault.y = _bg.height/2 - 30;
                    _imageCont.addChild(_avaDefault);
                } else {
                    Cc.error('MarketItem:: no default_avatar_big');
                }
                if (_personBuyerTempItem && _personBuyerTempItem.buyerSocialId) {
                    g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                    g.socialNetwork.getTempUsersInfoById([_personBuyerTempItem.buyerSocialId]);
                }
                else Cc.error('MarkertItem:: No _personBuyerTemp || _personBuyerTemp.buyerSocialId');
            } else {
                if (_personBuyer.photo) {
                    _avaDefault = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                    if (_avaDefault) {
                        MCScaler.scale(_avaDefault, 75, 75);
                        _avaDefault.pivotX = _avaDefault.width/2;
                        _avaDefault.pivotY = _avaDefault.height/2;
                        _avaDefault.x = _bg.width/2 - 9;
                        _avaDefault.y = _bg.height/2 - 30;
                        _imageCont.addChild(_avaDefault);
                    } else {
                        Cc.error('MarketItem:: no default_avatar_big');
                    }
                    if (_personBuyer && _personBuyer.photo) g.load.loadImage(_personBuyer.photo, onLoadPhoto);
                    else Cc.error('MarkertItem:: No _personBuyer || _personBuyer.buyerSocialId');
                } else {
                    var t:Texture = g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big');
                    if (t) {
                        _avaDefault = new Image(t);
                        if (_avaDefault) {
                            MCScaler.scale(_avaDefault, 75, 75);
                            _avaDefault.pivotX = _avaDefault.width / 2;
                            _avaDefault.pivotY = _avaDefault.height / 2;
                            _avaDefault.x = _bg.width / 2 - 9;
                            _avaDefault.y = _bg.height / 2 - 30;
                            _imageCont.addChild(_avaDefault);
                        } else {
                            Cc.error('MarketItem:: no default_avatar_big');
                        }
                    } else {
                        Cc.error('MarketItem:: no default_avatar_big texture');
                    }
                    if (_personBuyer && _personBuyer.userSocialId) {
                        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                        g.socialNetwork.getTempUsersInfoById([_personBuyer.userSocialId]);
                    }
                    else Cc.error('MarkertItem:: No _personBuyer || _personBuyer.buyerSocialId');
                }
            }
        }

        _btnGoAwaySaleItem = new CButton();
        _btnGoAwaySaleItem.addButtonTexture(76, 29, CButton.BLUE, true);
        _txtGo = new CTextField(70, 30, String(g.managerLanguage.allTexts[386]));
        _txtGo.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtGo.x = 3;
        _btnGoAwaySaleItem.addChild(_txtGo);
        source.addChild(_btnGoAwaySaleItem);

//
//        _btnGoAwaySaleItem = new CButton();
//        _btnGoAwaySaleItem.addButtonTexture(70,30,CButton.BLUE, true);
//        var txt:TextField = new TextField(60,30,'посетить',g.allData.fonts['BloggerBold'], 14, Color.WHITE);
//        txt.x = 4;
////        txt.y = 5;
//        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        Cc.info('showScaleImage 19');
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
                person = g.user.getSomeoneBySocialId(_personBuyerTempItem.buyerSocialId);
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
           if (_btnGoAwaySaleItem) _btnGoAwaySaleItem.visible = true;
        }
    }

    private function onOut():void {
        _onHover = false;
        if (isFill == 0 && _isUser) {
            _bg.filter = null;
        } else if (isFill == 1) {
            _delete.visible = false;
            g.gameDispatcher.removeFromTimer(onEnterFrame);
        }

        if (_isUser && isFill == 2) {
            _btnGoAwaySaleItem.visible = false;
        }
        g.marketHint.hideIt();
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
        if (!user)_txtAdditem.visible = false;
        else {
            if (isFill == 1 ||  isFill == 2 ) {
                _txtAdditem.visible = false;
            } else _txtAdditem.visible = true;
        }
        _isUser = user;
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        if (!_personBuyer) {
            if (_personBuyerTempItem) _photoUrl = g.user.getSomeoneBySocialId(_personBuyerTempItem.buyerSocialId).photo;
            if ( _personBuyerTempItem && _photoUrl) {
                g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                g.load.loadImage(_photoUrl, onLoadPhoto);
            }
        }  else {
            if (!_personBuyer.name) _personBuyer = g.user.getSomeoneBySocialId(_personBuyer.userSocialId);
            if (_personBuyer.photo) {
                g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                g.load.loadImage(_personBuyer.photo, onLoadPhoto);
            }
        }
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            if (!_personBuyer)  bitmap = g.pBitmaps[_photoUrl].create() as Bitmap;
            else bitmap = g.pBitmaps[_personBuyer.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('FriendItem:: no photo for userId: ' + _personBuyerTempItem.buyerSocialId + 'or ' + _personBuyer.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        if (_avaDefault) {
            if (source && source.contains(_avaDefault)) source.removeChild(_avaDefault);
            _avaDefault.dispose();
            _avaDefault = null;
        }
        if (tex) {
            _ava = new Image(tex);
            MCScaler.scale(_ava, 75, 75);
            if (_bg) _ava.x = _bg.width/2 - _ava.width/2;
            if (_bg) _ava.y = _bg.height/2 - _ava.height/2 - 20;
            _imageCont.addChild(_ava);
        } else {
            Cc.error('MarketItem photoFromTexture:: no texture(')
        }
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
        _personBuyerTempItem = null;
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
        if (_costTxt) {
            _plawkaCoins.removeChild(_costTxt);
            _costTxt.deleteIt();
            _costTxt = null;
        }
        if (_countTxt) {
            source.removeChild(_countTxt);
            _countTxt.deleteIt();
            _countTxt = null;
        }
        if (_txtPlawka) {
            source.removeChild(_txtPlawka);
            _txtPlawka.deleteIt();
            _txtPlawka = null;
        }
        if (_txtAdditem) {
            source.removeChild(_txtAdditem);
            _txtAdditem.deleteIt();
            _txtAdditem = null;
        }
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

    public function get woMarket():WOMarket {
        return _wo;
    }
}
}
