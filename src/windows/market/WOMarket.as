/**
 * Created by user on 7/23/15.
 */
package windows.market {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import manager.ManagerFilters;
import media.SoundConst;
import social.SocialNetworkEvent;
import starling.animation.Tween;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Color;
import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;
import utils.Utils;

import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOMarket  extends WindowMain {
    private var _woBG:WindowBackground;
    private var _shopSprite:Sprite;
    private var _contRect:Sprite;
    private var _contItem:Sprite;
    private var _cont:Sprite;
    private var _contItemCell:Sprite;
    private var _btnRefresh:CSprite;
    private var _leftBtn:CSprite;
    private var _rightBtn:CSprite;
    private var _contPaper:Sprite;
    private var _btnFriends:CButton;
    private var _btnPaper:CButton;
    private var _arrItems:Array;
    private var _arrItemsTemp:Array;
    private var _arrItemsFriend:Array;
    private var _arrFriends:Array;
    private var _txtName:CTextField;
    private var _txtNumberPage:CTextField;
    private var _txtTimerPaper:CTextField;
//    private var _imCheck:Image;
    private var _curUser:Someone;
    private var _item:MarketFriendItem;
    private var _item2:MarketFriendItem;
    private var _item3:MarketFriendItem;
    private var _ma:MarketAllFriend;
    private var _shiftFriend:int = 0;
    private var _shift:int;
    private var _countPage:int;
    private var _countAllPage:int;
    private var _panelBool:Boolean;
    private var _booleanPaper:Boolean;
    private var _callback:Function;
    private var _birka:Birka;
    private var _timer:int;
    private var _txtAllFriends:CTextField;
    private var _txtPaper:CTextField;
    private var _txtToPaper:CTextField;

    public function WOMarket() {
        super();
        SOUND_OPEN = SoundConst.OPEN_MARKET_WINDOW;
        _windowType = WindowsManager.WO_MARKET;
        _cont = new Sprite();
        _contItem = new CSprite();
        _arrItemsFriend = [];
        _arrItems = [];
        _shopSprite = new Sprite();
        _woWidth = 750;
        _woHeight = 520;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _source.addChild(_contItem);
        _contItem.filter = ManagerFilters.SHADOW;
        _btnFriends = new CButton();
        _btnFriends.addButtonTexture(96, 40, CButton.GREEN, true);
        _btnFriends.x = _woWidth/2 - 97;
        _btnFriends.y = _woHeight/2 - 58;
        _source.addChild(_cont);
        var c:CartonBackground = new CartonBackground(550, 445);
        c.x = -_woWidth/2 + 43;
        c.y = -_woHeight/2 + 40;
        _cont.filter = ManagerFilters.SHADOW;
        _cont.addChild(c);
        _txtAllFriends = new CTextField(96, 24, 'Все друзья');
        _txtAllFriends.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtAllFriends.y = 6;
        _btnFriends.addChild(_txtAllFriends);
        _source.addChild(_btnFriends);
        _btnFriends.clickCallback = btnFriend;
        _countPage = 1;
        _contRect = new Sprite();
        _contRect.mask = new Quad(500, 400);
        _contRect.mask.x = -305;
        _contRect.mask.y = -200;

        _source.addChild(_contRect);
        _contItemCell = new Sprite();
        _contRect.addChild(_contItemCell);

        _btnRefresh = new CSprite();
        var ref:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('refresh_icon'));
        _btnRefresh.addChild(ref);
        _btnRefresh.x = -320;
        _btnRefresh.y = 155;
//        _source.addChild(_btnRefresh);
//        _btnRefresh.endClickCallback = makeRefresh;
        _btnRefresh.hoverCallback =  function():void { };
        _callbackClickBG = hideIt;
//        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        _birka = new Birka('РЫНОК', _source, _woWidth, _woHeight);
        _panelBool = false;

        _leftBtn = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left_mini'));
        _leftBtn.addChild(im);
        MCScaler.scale(_leftBtn, 40, 40);
        _leftBtn.x = -280;
        _leftBtn.y = 158;
        _source.addChild(_leftBtn);
        _leftBtn.endClickCallback = onLeft;
        _leftBtn.hoverCallback = function():void { if (_leftBtn.filter == null)_leftBtn.filter = ManagerFilters.BUILDING_HOVER_FILTER; };
        _leftBtn.outCallback = function():void { if (_leftBtn.filter == ManagerFilters.BUILDING_HOVER_FILTER)_leftBtn.filter = null; };

        _rightBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left_mini'));
        im.scaleX = -1;
        im.x = im.width;
        _rightBtn.addChild(im);
        MCScaler.scale(_rightBtn, 40, 40);
        _rightBtn.x = -200;
        _rightBtn.y = 158;
        _source.addChild(_rightBtn);
        _rightBtn.endClickCallback = onRight;
        _rightBtn.hoverCallback = function():void { if (_rightBtn.filter == null) _rightBtn.filter = ManagerFilters.BUILDING_HOVER_FILTER; };
        _rightBtn.outCallback = function():void { if (_rightBtn.filter == ManagerFilters.BUILDING_HOVER_FILTER) _rightBtn.filter = null; };
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka7'));
        MCScaler.scale(im,35,44);
        im.x = -250;
        im.y = 165;
        _source.addChild(im);
        _txtNumberPage = new CTextField(50, 50, '');
        _txtNumberPage.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtNumberPage.x = -253;
        _txtNumberPage.y = 152;
        _source.addChild(_txtNumberPage);

        _contPaper = new Sprite();
        _source.addChild(_contPaper);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka7'));
        im.x = 58;
        im.y = 164;
        _contPaper.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_icon_small'));
        MCScaler.scale(im,im.height/2+5, im.width/2+5);
        im.x = 12;
        im.y = 156;
        _contPaper.addChild(im);

        _btnPaper = new CButton();
        _btnPaper.addButtonTexture(70,30,CButton.GREEN,true);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
//        MCScaler.scale(im,30,30);
        im.x = 35;
        _btnPaper.addChild(im);
        _txtPaper = new CTextField(30,30,'1');
        _txtPaper.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtPaper.x = 10;
        _btnPaper.addChild(_txtPaper);
        _btnPaper.x = 153;
        _btnPaper.y = 180;
        _btnPaper.clickCallback = onClickPaper;
        _contPaper.addChild(_btnPaper);

//        _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
//        _imCheck.x = 95;
//        _imCheck.y = 165;
//        _contPaper.addChild(_imCheck);
//        _imCheck.visible = false;

        _txtToPaper = new CTextField(200,30,'Выставить в газету:');
        _txtToPaper.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtToPaper.x = 12;
        _txtToPaper.y = 135;
        _contPaper.addChild(_txtToPaper);

        _txtTimerPaper = new CTextField(80,30,'');
        _txtTimerPaper.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtTimerPaper.x = 46;
        _txtTimerPaper.y = 165;
        _contPaper.addChild(_txtTimerPaper);
        _contPaper.visible = false;
    }

    private function fillFriends(e:SocialNetworkEvent=null):void {
        _arrFriends = g.user.arrFriends.slice();

        for (var i:int = 0; i <_arrFriends.length; i++) {
            if (_arrFriends[i].level < 5 || _arrFriends[i].level == 0) {
                _arrFriends.splice(i,1);
                i--;
            }
        }
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        _txtName = new CTextField(300, 30, '');
        _txtName.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtName.y = -200;
        _txtName.x = -195;
        _ma = new MarketAllFriend(_arrFriends, this, btnFriend);
        _source.addChild(_ma.source);
    }

    override public function showItParams(f:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        _arrFriends = [];
        fillFriends();
        _countPage = 1;
        _callback = f;
        if (params[0]) {
            _curUser = params[0];
            for (var i:int=0; i < _arrFriends.length; i++) {
                if (_arrFriends[i].userSocialId == _curUser.userSocialId){
                    _shiftFriend = i;
                }
            }
//            if (_shiftFriend == 0 && _curUser.userSocialId == g.user.userSocialId)
            if(_shiftFriend == 0)  {
                if (_curUser.userSocialId == g.user.userSocialId) createMarketTabBtns();
                else createMarketTabBtns(true);
            }
            else createMarketTabBtns();
            checkPapperTimer();
            choosePerson(_curUser);
        }
        _timer = 15;
        g.gameDispatcher.addToTimer(refreshMarketTemp);
        onWoShowCallback = onShow;
        super.showIt();
    }

    private function onShow():void {
        if (_curUser is NeighborBot) Utils.createDelay(.5, g.managerMiniScenes.atNeighborBuyInstrument);
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        _timer = 15;
        g.gameDispatcher.removeFromTimer(refreshMarketTemp);
        super.hideIt();
    }

    public function get curUser():Someone {
        return _curUser;
    }

    private function clearItems():void {
        while (_contItemCell.numChildren) {
            _contItemCell.removeChildAt(0);
        }
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
    }

    private function addItems():void {
        var item:MarketItem;
//        clearItems();

        if (_curUser.marketCell <= 0) {
            _curUser.marketCell = 6;
            if (_curUser == g.user) g.directServer.updateUserMarketCell(0, null);
        }

        var marketCellCount:int = _curUser.marketCell;
        if (g.user == _curUser) {
            marketCellCount += 1;
            if (marketCellCount > 40) marketCellCount = 40;
        }

        for (var i:int=0; i < marketCellCount; i++) {
            if (i+1 > _curUser.marketCell) item = new MarketItem(i, true, this);
                else item = new MarketItem(i, false, this);
            if (i+1 <= 8) {
                item.source.x = 125*(_arrItems.length%4) - 300;
                _countAllPage = 1;
            } else if (i+1 <= 16) {
                item.source.x = 125*(_arrItems.length%4)+200;
                _countAllPage = 2;
            } else if (i+1 <= 24) {
                item.source.x = 125*(_arrItems.length%4)+700;
                _countAllPage = 3;
            } else if (i+1 <= 32) {
                item.source.x = 125*(_arrItems.length%4)+1200;
                _countAllPage = 4;
            } else if (i+1 <= 40) {
                item.source.x = 125*(_arrItems.length%4)+1700;
                _countAllPage = 5;
            }

            if (i+1 <= 4) {
                item.source.y = -160;
            }  else if (i+1 <= 8) {
                item.source.y = -10;
            } else if (i+1 <= 12) {
                item.source.y = -160;
            } else if (i+1 <= 16) {
                item.source.y = -10;
            } else if (i+1 <= 20) {
                item.source.y = -160;
            } else if (i+1 <= 24) {
                item.source.y = -10;
            } else if (i+1 <= 28) {
                item.source.y = -160;
            } else if (i+1 <= 32) {
                item.source.y = -10;
            } else if (i+1 <= 36) {
                item.source.y = -160;
            } else if (i+1 <= 40) {
                item.source.y = -10;
            }
            _contItemCell.addChild(item.source);
            _arrItems.push(item);
        }
        checkArrow();
    }

    public function addItemsRefresh():void {
        if (_arrItems.length == 40) return;
        var item:MarketItem;
        item = new MarketItem(_arrItems.length, true, this);

        if (_arrItems.length  <= 7) {
            item.source.x = 125*(_arrItems.length%4) - 300;
            _countAllPage = 1;
        } else  if (_arrItems.length  <= 15) {
            item.source.x = 125*(_arrItems.length%4)+200;
            _countAllPage = 2;
        } else if (_arrItems.length  <= 23) {
            item.source.x = 125*(_arrItems.length%4)+700;
            _countAllPage = 3;
        } else if (_arrItems.length  <= 31) {
            item.source.x = 125*(_arrItems.length%4)+1200;
            _countAllPage = 4;
        } else if (_arrItems.length <= 39) {
            item.source.x = 125*(_arrItems.length%4)+1700;
            _countAllPage = 5;
        }

        if (_arrItems.length  <= 3) {
            item.source.y = -160;
        }  else if (_arrItems.length  <= 7) {
            item.source.y = -10;
        } else if (_arrItems.length  <= 11) {
            item.source.y = -160;
        } else if (_arrItems.length  <= 15) {
            item.source.y = -10;
        } else if (_arrItems.length  <= 19) {
            item.source.y = -160;
        } else if (_arrItems.length  <= 23) {
            item.source.y = -10;
        } else if (_arrItems.length  <= 27) {
            item.source.y = -160;
        } else if (_arrItems.length  <= 31) {
            item.source.y = -10;
        } else if (_arrItems.length  <= 35) {
            item.source.y = -160;
        } else if (_arrItems.length  <= 39) {
            item.source.y = -10;
        }
        _contItemCell.addChild(item.source);
        _arrItems.push(item);
        checkArrow();
    }

    private function fillItems():void {
        var i:int;
        if (_curUser is NeighborBot) {
            for (i = 0; i < _arrItems.length; i++) {
                _arrItems[i].friendAdd();
                if (_curUser.marketItems[i]) {
                    if (_curUser == g.user.neighbor && _curUser.marketItems[i].resourceId == -1) continue;
                    _arrItems[i].fillFromServer(_curUser.marketItems[i], _curUser);
                }
            }
        } else {
            for (i = 0; i < _arrItems.length; i++) {
                if (_curUser == g.user) _arrItems[i].friendAdd(true);
                else _arrItems[i].friendAdd(false);
            }
            for (i = 0; i < _curUser.marketItems.length; i++) {
                if (_curUser.marketItems[i].numberCell == _arrItems.length) {
                    _arrItems[_curUser.marketItems[i].numberCell-1].fillFromServer(_curUser.marketItems[i], _curUser);
                } else {
                    _arrItems[_curUser.marketItems[i].numberCell].fillFromServer(_curUser.marketItems[i], _curUser);
                }
            }
            if (_shiftFriend != 0) goToItemFromPaper();
        }
    }

    private function goToItemFromPaper():void {
        for (var i:int = 0; i < _curUser.marketItems.length; i++) {
            if (_curUser.marketItems[i].resourceId == _curUser.idVisitItemFromPaper && _curUser.marketItems[i].inPapper) {
                if (_curUser.marketItems[i].numberCell <= 8) {
                    _countPage = 1;
                    _shift = 0;
                } else if (_curUser.marketItems[i].numberCell+1 <= 16) {
                    _countPage = 2;
                    _shift = 4;
                } else if (_curUser.marketItems[i].numberCell+1 <= 24) {
                    _countPage = 3;
                    _shift = 8;
                } else if (_curUser.marketItems[i].numberCell+1 <= 32) {
                    _countPage = 4;
                    _shift = 12;
                } else if (_curUser.marketItems[i].numberCell+1 <= 40) {
                    _shift = 16;
                    _countPage = 5;
                }
                break;
            }
        }
        new TweenMax(_contItemCell, .5, {x: -_shift * 125});
        checkArrow();
    }

    private function makeRefresh():void {
        if (g.managerCutScenes.isCutScene || g.managerTutorial.isTutorial) return;
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
        g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
    }

    public function refreshItemWhenYouBuy ():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
        fillItems();
    }

    public function refreshMarket():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            if(!_arrItems[i].number) {
                break;
            }
            _arrItems[i].unFillIt();
        }
        g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
        createMarketTabBtns();
        _countPage = 1;
        checkArrow();
    }

    private function onClickPaper():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.user.hardCurrency < 1) {
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.windowsManager.cashWindow = this;
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_BUY_FOR_HARD, callbacKPapperBtn, 'market');
    }

    private function callbacKPapperBtn():void {
        g.userInventory.addMoney(1,-1);
        g.userTimer.papperTimerAtMarket = 0;
        g.directServer.skipUserInPaper(null);
        g.gameDispatcher.removeFromTimer(onTimer);
        _txtTimerPaper.text = '';
        _btnPaper.visible = false;
        _booleanPaper = true;
        _contPaper.visible = false;
        for (var i:int = 0; i < _curUser.marketItems.length; i++) {
            _arrItems[_curUser.marketItems[i].numberCell].visiblePapperTimer();
        }
//        for (var i:int = 0; i < _arrItems.length; i++) {
//            _arrItems[i].visiblePapperTimer();
//        }
    }

    public function get booleanPaper():Boolean {
        return _booleanPaper;
    }

    public function startPapperTimer():void {
        g.userTimer.startUserMarketTimer(300);
        _booleanPaper = false;
        for (var i:int = 0; i < _curUser.marketItems.length; i++) {
            _arrItems[_curUser.marketItems[i].numberCell].visiblePapperTimer();
        }
//        for (var i:int = 0; i < _arrItems.length; i++) {
//            _arrItems[i].visiblePapperTimer();
//        }
        checkPapperTimer();
    }

    private function checkPapperTimer():void {
        if (g.userTimer.papperTimerAtMarket > 0) {
            _txtTimerPaper.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.papperTimerAtMarket);
            g.userTimer.startUserMarketTimer(g.userTimer.papperTimerAtMarket);
            g.gameDispatcher.addToTimer(onTimer);
            _booleanPaper = false;
            _contPaper.visible = true;
            _btnPaper.visible = true;
        } else {
            _booleanPaper = true;
            _contPaper.visible = false;
            _btnPaper.visible = false;
            _txtTimerPaper.text = '';
            g.gameDispatcher.removeFromTimer(onTimer);
        }
    }

    private function onTimer():void {
        if (g.userTimer.papperTimerAtMarket > 0) {
            if (_txtTimerPaper) _txtTimerPaper.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.papperTimerAtMarket);
        } else {
                _btnPaper.visible = false;
                _booleanPaper = true;
                _contPaper.visible = false;
                if (_txtTimerPaper) _txtTimerPaper.text = '';
                g.gameDispatcher.removeFromTimer(onTimer);
                for (var i:int = 0; i < _curUser.marketItems.length; i++) {
                    if (_arrItems.length == 0 || _curUser != g.user) break;
                    else _arrItems[_curUser.marketItems[i].numberCell].visiblePapperTimer();
                }
//            for (var i:int = 0; i < _arrItems.length; i++) {
//                _arrItems[i].visiblePapperTimer();
//            }
            }
    }

    public function addAdditionalUser(ob:Object):void {
        _curUser = g.user.getSomeoneBySocialId(ob.userSocialId);
    }

    public function createMarketTabBtns(paper:Boolean = false):void {
        var c:CartonBackground;
        if (_arrFriends == null) {
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'Обнови сиды и сикреты');
            return;
        }
        if (_curUser.userSocialId == g.user.userSocialId) {
            _txtName.text = 'Вы продаете:';
        } else {
            if (paper) {
                if (_curUser.name == null ) _txtName.text = 'Игрок продает:';
                else _txtName.text = _curUser.name + ' продает:';
            } else {
                if (_arrFriends[_shiftFriend].name == null ) _txtName.text = 'Игрок продает:';
                else _txtName.text = _arrFriends[_shiftFriend].name + ' продает:';
            }
        }
        _source.addChild(_txtName);

        if (_arrFriends.length <= 2) {
            _item = new MarketFriendItem(_arrFriends[_shiftFriend], this, _shiftFriend);
            _item.source.y = -180;
            if (g.isAway) {
                if (_arrFriends[_shiftFriend].userSocialId == g.visitedUser.userSocialId) _item.visitBtn.visible = false;
            } else {
                if (_arrFriends[_shiftFriend] == g.user) {
                    _item.visitBtn.visible = false;
                } else _item.visitBtn.visible = true;
            }
            c = new CartonBackground(125, 115);
            c.x = 208 - 5;
            c.y = -185;
            _cont.addChild(c);
            _source.addChild(_item.source);
            if (_shiftFriend == 1) {
                _shiftFriend = -1;
            }
            if (_arrFriends[_shiftFriend + 1] == null && paper)  _item2 = new MarketFriendItem(g.user, this, _shiftFriend + 1);
            else _item2 = new MarketFriendItem(_arrFriends[_shiftFriend + 1], this, _shiftFriend + 1);
            _item2.source.y = 1 * 120 - 177;
            c = new CartonBackground(120, 110);
            c.x = 208 - 5;
            c.y = 1 * 120 - 185;
            _contItem.addChild(c);
            _source.addChild(_item2.source);
            _item2.source.width = _item2.source.height = 100;
            return;
        }
        if (paper) {
            _item = new MarketFriendItem(_curUser, this, 0);
            _item.source.y = -180;
            if (g.visitedUser) {
                if (_curUser.userSocialId == g.visitedUser.userSocialId) _item.visitBtn.visible = false;
                else _item.visitBtn.visible = true;
            } else _item.visitBtn.visible = true;
            c = new CartonBackground(125, 115);
            c.x = 208 - 5;
            c.y = -185;
            _cont.addChild(c);
            _source.addChild(_item.source);
            if (_shiftFriend + 2 >= _arrFriends.length) {
                _shiftFriend = -1;
            }
        } else {
            _item = new MarketFriendItem(_arrFriends[_shiftFriend], this, _shiftFriend);
            _item.source.y = -180;
            if (g.isAway) {
                if (_arrFriends[_shiftFriend] == g.visitedUser)  _item.visitBtn.visible = false;
                else _item.visitBtn.visible = true;
            } else {
                if (_arrFriends[_shiftFriend] == g.user) _item.visitBtn.visible = false;
                else _item.visitBtn.visible = true;
            }
            c = new CartonBackground(125, 115);
            c.x = 208 - 5;
            c.y = -185;
            _cont.addChild(c);
            _source.addChild(_item.source);
            if (_shiftFriend + 2 >= _arrFriends.length) {
                _shiftFriend = -1;
            }
        }
        _item2 = new MarketFriendItem(_arrFriends[_shiftFriend + 1], this, _shiftFriend + 1);
        _item2.source.y = 1 * 120 - 177;
        c = new CartonBackground(120, 110);
        c.x = 208 - 5;
        c.y = 1 * 120 - 185;
        _contItem.addChild(c);
        _source.addChild(_item2.source);
        _item2.source.width = _item2.source.height = 100;

        _item3 = new MarketFriendItem(_arrFriends[_shiftFriend + 2],this,_shiftFriend + 2);
        _item3.source.y = 2 * 120-182;
        c = new CartonBackground(120, 110);
        c.x = 208-5;
        c.y = 2 * 120-190;
        _contItem.addChild(c);
        _source.addChild(_item3.source);
        _item3.source.width = _item3.source.height = 100;
    }

    public function choosePerson(_person:Someone):void {
        if (!_person) {
            Cc.error('WOMarket choosePerson:: no _person');
            return;
        }
        clearItems();
        _shift = 0;
        if (_contItemCell) {
            new TweenMax(_contItemCell, .5, {x: -_shift * 125, ease: Linear.easeNone});
        }
        _countPage = 1;
        _curUser = _person;
        _timer = 15;
        g.gameDispatcher.addToTimer(refreshMarketTemp);
        if (_curUser.marketCell < 0 || _curUser != g.user) {
            if (_curUser is NeighborBot) {
                g.directServer.getUserNeighborMarket(onChoosePerson);
            } else {
                g.directServer.getUserMarketItem(_curUser.userSocialId, onChoosePerson);
            }
        } else {
            onChoosePerson();
        }
    }

    private function onChoosePerson():void {
        if (_curUser == g.user) {
            if (g.userTimer.papperTimerAtMarket > 0) _contPaper.visible = true;
            else _contPaper.visible = false;
        } else _contPaper.visible = false;
        addItems();
        fillItems();
    }

    public function onChooseFriendOnPanel(p:Someone, shift:int):void {
        choosePerson(p);
        _shiftFriend = shift;
        deleteFriends();
        createMarketTabBtns();
        closePanelFriend();
    }

    public function set shiftFriend(a:int):void  {
        _shiftFriend = a;
    }

    public function deleteFriends():void {
        if (_item) {
            _source.removeChild(_item.source);
            _item.deleteIt();
            _item = null;
        }
        if (_item2) {
            _source.removeChild(_item2.source);
            _item2.deleteIt();
            _item2 = null;
        }
        if (_item3) {
            _source.removeChild(_item3.source);
            _item3.deleteIt();
            _item3 = null;
        }
        _source.removeChild(_txtName);
    }

    private function btnFriend (hideCallback:Boolean = false):void {
        if (g.managerTutorial.isTutorial) return;
        if (g.managerCutScenes.isCutScene) return;
        if (hideCallback) {
            _ma.hideIt();
            _panelBool = false;
            return;
        }
        if (!_panelBool){
            _ma.showIt();
            _panelBool = true;
        } else if (_panelBool) {
            _ma.hideIt();
            _panelBool = false;
        }
    }

    public function closePanelFriend():void {
        if (_ma) _ma.hideIt();
        _panelBool = false;
    }

    public function callbackState():void {
        if (_callback != null) {
            _callback.apply(null);
            _callback = null;
        }
    }

    private function onLeft():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_shift <=0 ) return;
        var tween:Tween = new Tween(_leftBtn, 0.2);
        tween.scaleTo(.6);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(1);
        g.starling.juggler.add(tween);
        if (_shift > 0) {
            _shift -= 4;
            if (_shift<0) _shift = 0;
            new TweenMax(_contItemCell, .5, {x:-_shift*125, ease:Linear.easeNone ,onComplete: function():void {}});
            _countPage--;

        }
        checkArrow();
    }

    private function onRight():void {
        if (g.managerCutScenes.isCutScene) return;
        if ((_shift+4)*2 >= _arrItems.length) return;
        var tween:Tween = new Tween(_rightBtn, 0.2);
        tween.scaleTo(.6);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(1);
        g.starling.juggler.add(tween);
        var l:int = _arrItems.length;
        _shift += 4;
        if (_shift + 4 <= l - 1) {
            new TweenMax(_contItemCell, .5, {x:-_shift*125, ease:Linear.easeNone ,onComplete: function():void {}});
            _countPage++;
        }
        checkArrow();
    }

    public function checkArrow():void {
        _txtNumberPage.text = String(_countPage + '/' + _countAllPage);
        if (_shift == 0) {
            if (_leftBtn) _leftBtn.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        } else {
            if (_leftBtn) _leftBtn.filter = null;
        }
        if ((_shift+4)*2 >= _arrItems.length) {
            if (_rightBtn) _rightBtn.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        } else {
            if (_rightBtn) _rightBtn.filter = null;
        }
    }

    public function getItemProperties(a:int):Object {
        if (_arrItems && _arrItems.length) {
            return (_arrItems[a-1] as MarketItem).getItemProperties();
        } else {
            return {};
        }
    }
    
    public function getTimerProperties():Object {
        var ob:Object = {};
        ob.x = _txtTimerPaper.x;
        ob.y = _txtTimerPaper.y;
        ob.width = 80;
        ob.height = 30;
        return ob;
    } 

    public function onItemClickAndOpenWOChoose(item:MarketItem):void {
        g.windowsManager.cashWindow = this;
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_MARKET_CHOOSE, callbackFromMarketChoose, item);
    }

    private function callbackFromMarketChoose(item:MarketItem, a:int, level:int = 1, count:int = 0, cost:int = 0, inPapper:Boolean = false):void {
        if (a>0) {
            item.onChoose(a, level, count, cost, inPapper);
        }
    }

    private function refreshMarketTemp():void {
        if (_curUser is NeighborBot) {
            _timer = 15;
            g.gameDispatcher.removeFromTimer(refreshMarketTemp);
            return;
        }
        _timer--;
        if (_timer <= 0) {
            _arrItemsTemp = _curUser.marketItems;
            g.directServer.getUserMarketItem(_curUser.userSocialId, onRefreshTemp);
            g.gameDispatcher.removeFromTimer(refreshMarketTemp);
        }
    }

    private function onRefreshTemp():void {
        var b:Boolean = false;
        var i:int;
        if (_curUser is NeighborBot) {
            g.gameDispatcher.removeFromTimer(refreshMarketTemp);
            return;
        }
        if (_arrItems.length == 0 || !_arrItems) {
            return;
        }
        if (!_curUser.marketItems) return; // нужно чтобы не выполнялся этот ретурн
        if (_arrItemsTemp.length != _curUser.marketItems.length) {
            for (i=0; i< _arrItems.length; i++) {
                _arrItems[i].unFillIt();
            }
            fillItems();
        } else {
            for (i= 0; i < _curUser.marketItems.length; i++) {
                if (_arrItemsTemp[i].buyerId != _curUser.marketItems[i].buyerId || _arrItemsTemp[i].id != _curUser.marketItems[i].id) {
                   b = true;
                    break;
                }
            }
            if (b) {
                for (i = 0; i < _arrItems.length; i++) {
                    _arrItems[i].unFillIt();
                }
                fillItems();
            }
        }
        _timer = 15;
        g.gameDispatcher.addToTimer(refreshMarketTemp);
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        var i:int;
        if (_txtName) {
            _source.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
        if (_txtAllFriends) {
            _btnFriends.removeChild(_txtAllFriends);
            _txtAllFriends.deleteIt();
            _txtAllFriends = null;
        }
        if (_txtNumberPage) {
            _source.removeChild(_txtNumberPage);
            _txtNumberPage.deleteIt();
            _txtNumberPage = null;
        }
        if (_txtPaper) {
            _btnPaper.removeChild(_txtPaper);
            _txtPaper.deleteIt();
            _txtPaper = null;
        }
        if (_txtTimerPaper) {
            _contPaper.removeChild(_txtTimerPaper);
            _txtTimerPaper.deleteIt();
            _txtTimerPaper = null;
        }
        if (_txtToPaper) {
            _contPaper.removeChild(_txtToPaper);
            _txtToPaper.deleteIt();
            _txtToPaper = null;
        }

        deleteFriends();
        if (_arrItems) {
            for (i=0; i< _arrItems.length; i++) {
                _contItemCell.removeChild(_arrItems[i].source);
                _arrItems[i].deleteIt();
            }
            _arrItems.length = 0;
        }
        if (_ma) {
            _source.removeChild(_ma.source);
            _ma.deleteIt();
            _ma = null;
        }
        _source.removeChild(_leftBtn);
        _leftBtn.deleteIt();
        _leftBtn = null;
        _source.removeChild(_rightBtn);
        _rightBtn.deleteIt();
        _rightBtn = null;
        callbackState();
        super.deleteIt();
    }
}
}
