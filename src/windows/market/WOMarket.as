/**
 * Created by user on 7/23/15.
 */
package windows.market {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import manager.ManagerFilters;
import social.SocialNetworkEvent;
import starling.animation.Tween;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;
import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;
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
    private var _arrItemsFriend:Array;
    private var _arrFriends:Array;
    private var _txtName:TextField;
    private var _txtNumberPage:TextField;
    private var _txtTimerPaper:TextField;
    private var _imCheck:Image;
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
    private var _SHADOW:BlurFilter;

    public function WOMarket() {
        super();
        _windowType = WindowsManager.WO_MARKET;
        _cont = new Sprite();
        _contItem = new CSprite();
        _arrItemsFriend = [];
        _shopSprite = new Sprite();
        _woWidth = 750;
        _woHeight = 520;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _source.addChild(_contItem);
        _SHADOW = ManagerFilters.getShadowFilter();
        _contItem.filter = _SHADOW;
        _btnFriends = new CButton();
        _btnFriends.addButtonTexture(96, 40, CButton.GREEN, true);
        _btnFriends.x = _woWidth/2 - 97;
        _btnFriends.y = _woHeight/2 - 58;
        _source.addChild(_cont);
        var c:CartonBackground = new CartonBackground(550, 445);
        c.x = -_woWidth/2 + 43;
        c.y = -_woHeight/2 + 40;
        _cont.filter = _SHADOW;
        _cont.addChild(c);
        var txt:TextField = new TextField(80, 25, 'Все друзья', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x4b3600, 1, 4, 4, 5)];
        txt.x = 8;
        txt.y = 8;
        _btnFriends.addChild(txt);
        _source.addChild(_btnFriends);
        _btnFriends.clickCallback = btnFriend;
        _countPage = 1;
        _contRect = new Sprite();
        _contRect.clipRect = new Rectangle(-305, -200, 500, 400);

        _source.addChild(_contRect);
        _contItemCell = new Sprite();
        _contRect.addChild(_contItemCell);

        _btnRefresh = new CSprite();
        var ref:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('refresh_icon'));
        _btnRefresh.addChild(ref);
        _btnRefresh.x = -320;
        _btnRefresh.y = 155;
        _source.addChild(_btnRefresh);
        _btnRefresh.endClickCallback = makeRefresh;
        _callbackClickBG = hideIt;
//        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        _birka = new Birka('РЫНОК', _source, _woWidth, _woHeight);
        _panelBool = false;

        _leftBtn = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        _leftBtn.addChild(im);
        MCScaler.scale(_leftBtn, 40, 40);
        _leftBtn.x = -274;
        _leftBtn.y = 158;
        _source.addChild(_leftBtn);
        _leftBtn.endClickCallback = onLeft;
        _leftBtn.hoverCallback = function():void { if (_leftBtn.filter == null)_leftBtn.filter = ManagerFilters.BUILDING_HOVER_FILTER; };
        _leftBtn.outCallback = function():void { if (_leftBtn.filter == ManagerFilters.BUILDING_HOVER_FILTER)_leftBtn.filter = null; };

        _rightBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
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
        _txtNumberPage = new TextField(50, 50, '', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtNumberPage.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN_BIG;
        _txtNumberPage.x = -253;
        _txtNumberPage.y = 153;
        _source.addChild(_txtNumberPage);

        _contPaper = new Sprite();
        _source.addChild(_contPaper);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka7'));
        im.x = 80;
        im.y = 164;
        _contPaper.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_icon_small'));
        im.x = 50;
        im.y = 160;
        _contPaper.addChild(im);

        _btnPaper = new CButton();
        _btnPaper.addButtonTexture(70,30,CButton.GREEN,true);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im,30,30);
        im.x = 35;
        _btnPaper.addChild(im);
        txt = new TextField(30,30,'1',g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.x = 10;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnPaper.addChild(txt);
        _btnPaper.x = 175;
        _btnPaper.y = 180;
        _btnPaper.clickCallback = onClickPaper;
        _contPaper.addChild(_btnPaper);

        _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _imCheck.x = 95;
        _imCheck.y = 165;
        _contPaper.addChild(_imCheck);
        _imCheck.visible = false;

        txt = new TextField(200,30,'Выставить в газету:',g.allData.fonts['BloggerBold'], 12, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 30;
        txt.y = 135;
        _contPaper.addChild(txt);

        _txtTimerPaper = new TextField(80,30,'',g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtTimerPaper.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtTimerPaper.x = 68;
        _txtTimerPaper.y = 165;
        _contPaper.addChild(_txtTimerPaper);
        _contPaper.visible = false;
    }

    private function fillFriends(e:SocialNetworkEvent=null):void {
//        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, fillFriends);
        _arrFriends = g.user.arrFriends.slice();
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        _txtName = new TextField(300, 30, '', g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtName.y = -200;
        _txtName.x = -195;
        _ma = new MarketAllFriend(_arrFriends,this,btnFriend);
        _source.addChild(_ma.source);
    }

    override public function showItParams(f:Function, params:Array):void {
        _arrFriends = [];
        fillFriends();
        _countPage = 1;
        _callback = f;
        if (params[0]) {
            for (var i:int=0; i < _arrFriends.length; i++) {
                if (_arrFriends[i].userSocialId == params[0].userSocialId){
                    _shiftFriend = i;
                }
            }

            _curUser = params[0];
            if(_shiftFriend == 0) {
                createMarketTabBtns(true);
            } else createMarketTabBtns();
            choosePerson(params[0]);
            checkPapperTimer();
        }
        super.showIt();
        if (params[0].marketItems != null) {
            for (i = 0; i < params[0].marketItems.length; i++) {
                if (params[0].marketItems[i].visitItem) {
                    if (params[0].marketItems[i].numberCell <= 8) {
                        _countPage = 1;
                        _shift = 0;
                    } else if (params[0].marketItems[i].numberCell <= 16) {
                        _countPage = 2;
                        _shift = 4;
                    } else if (params[0].marketItems[i].numberCell <= 24) {
                        _countPage = 3;
                        _shift = 8;
                    } else if (params[0].marketItems[i].numberCell <= 32) {
                        _countPage = 4;
                        _shift = 12;
                    } else if (params[0].marketItems[i].numberCell <= 40) {
                        _shift = 16;
                        _countPage = 5;
                    }
                    new TweenMax(_contItemCell, .5, {
                        x: -_shift * 125,
                        ease: Linear.easeNone,
                        onComplete: function ():void {
                        }
                    });
                    checkArrow();
                    break;
                }
            }
        }
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        super.hideIt();
    }

    public function set curUser(p:Someone):void {
        _curUser = p;
        fillItemsByUser(_curUser);
    }

    public function get curUser():Someone {
        return _curUser;
    }

    private function clearItems():void {
        while (_contItemCell.numChildren) {
            _contItemCell.removeChildAt(0);
        }
        _arrItems.length = 0;
    }

    private function addItems(newVisit:Boolean = false):void {
        var item:MarketItem;
        _arrItems = [];
        if (newVisit) {
            clearItems();
        }

        if (g.user.marketCell == 0) {
            g.directServer.updateUserMarketCell(5, null);
            g.user.marketCell = 5;
        }

        var marketCellCount:int;
        if (g.user.marketCell == 40) marketCellCount = g.user.marketCell;
            else  marketCellCount = g.user.marketCell + 2;

        for (var i:int=0; i < marketCellCount; i++) {
            if (i+1 > g.user.marketCell)  item = new MarketItem(i,true, this);
                else  item = new MarketItem(i,false, this);
            if (i+1 <= 8) {
             item.source.x = 125*(_arrItems.length%4) - 300;
                _countAllPage = 1;
            } else  if (i+1 <= 16) {
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
            item.callbackFill = callbackItem;
            _arrItems.push(item);
        }
        if (newVisit) checkArrow();
    }

    private function addItemsFriend(callback:Boolean = false,_person:Someone = null):void {
        if (!callback) g.directServer.getFriendsMarketCell(int(_person.userSocialId),_person, addItemsFriend);
        if (!_arrItems) _arrItems = [];
        else clearItems();

        if (_person.marketCell == 0) {
            _person.marketCell = 5;
        }
        var item:MarketItem;

        for (var i:int=0; i < _person.marketCell; i++) {
            item = new MarketItem(i,false, this);
            if (i+1 <= 8) {
                item.source.x = 125*(_arrItems.length%4) - 300;
                _countAllPage = 1;
            } else  if (i+1 <= 16) {
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
            item.callbackFill = callbackItem;
            _arrItems.push(item);
        }
        checkArrow();
    }

    public function addItemsRefresh():void {
        if (_arrItems.length == 40) return;
        var item:MarketItem;
        item = new MarketItem(_arrItems.length + 1, true, this);

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
        item.callbackFill = callbackItem;
        checkArrow();
    }

    private function callbackItem():void { }

    public function fillItemsByUser(p:Someone):void {
        _curUser = p;
        if (p is NeighborBot) {
            g.directServer.getUserNeighborMarket(fillItems);
        } else {
            g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
        }
    }

    public function unFillItems():void {
        if (!_arrItems) return;
        for (var i:int=0; i< _arrItems.length; i++) {
            if (!_arrItems[i].number) return;
            _arrItems[i].unFillIt();
        }
    }

    private function fillItems():void {
        var i:int;
        try {
        if (_curUser.marketItems == null) g.directServer.getUserMarketItem(_curUser.userSocialId, null);
            var n:int = 0;
            if (_curUser is NeighborBot) {
                for (i = 0; i < _arrItems.length; i++) {
                    _arrItems[i].friendAdd();
                    if (_curUser.marketItems[i]) {
                        if (_curUser == g.user.neighbor && _curUser.marketItems[i].resourceId == -1) continue;
                        _arrItems[i].fillFromServer(_curUser.marketItems[i], _curUser);
                    }
                }
                return;
            }
            for (i=0; i < _arrItems.length; i++) {
                if (_curUser.marketItems[i]) {
                    n = 0;
                    if (_curUser == g.user.neighbor && _curUser.marketItems[i].resourceId == -1) continue;
                    n = _curUser.marketItems[i].numberCell;
                    _arrItems[n].fillFromServer(_curUser.marketItems[i], _curUser);
                    _arrItems[i].isUser = _curUser == g.user;
                } else {
                    _arrItems[i].isUser = _curUser == g.user;
                }
                if (_curUser != g.user) _arrItems[i].friendAdd();
                if (_curUser == g.user)  _arrItems[i].friendAdd(true);
            }
        } catch (e:Error) {
            Cc.error('WOMarket fillItems:: error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woMarket');
        }
    }

    private function makeRefresh():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
        g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
    }

    public function refreshMarket():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            if(!_arrItems[i].number) break;
            _arrItems[i].unFillIt();
        }
        g.directServer.getUserMarketItem(_curUser.userSocialId, fillItems);
        createMarketTabBtns();
        _countPage = 1;
        checkArrow();
    }

    private function onClickPaper():void {
        if (g.user.hardCurrency < 1) {
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(1,-1);
        g.user.papperTimerAtMarket = 0;
        g.directServer.skipUserInPaper(null);
        g.gameDispatcher.removeFromTimer(onTimer);
        _txtTimerPaper.text = '';
        _btnPaper.visible = false;
        _booleanPaper = true;
        _imCheck.visible = true;
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].visiblePaper(true);
        }
    }

    public function get booleanPaper():Boolean {
        return _booleanPaper;
    }

    public function startPapperTimer():void {
        g.user.startUserPapperTimer();
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].visiblePaper(false);
        }
    }

    private function checkPapperTimer():void {
        if (g.user.papperTimerAtMarket > 0) {
            _txtTimerPaper.text = TimeUtils.convertSecondsToStringClassic(g.user.papperTimerAtMarket);
            g.gameDispatcher.addToTimer(onTimer);
        } else {
            _booleanPaper = false;
            _imCheck.visible = false;
            _btnPaper.visible = true;
        }
    }

    private function onTimer():void {
        if (g.user.papperTimerAtMarket > 0) _txtTimerPaper.text = TimeUtils.convertSecondsToStringClassic(g.user.papperTimerAtMarket);
        else {
            _btnPaper.visible = false;
            _booleanPaper = true;
            _imCheck.visible = true;
            _txtTimerPaper.text = '';
            g.gameDispatcher.removeFromTimer(onTimer);
            for (var i:int = 0; i < _arrItems.length; i++) {
                _arrItems[i].visiblePaper(true);
            }
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
            if (paper) _txtName.text = _curUser.name + ' продает:';
            else _txtName.text = _arrFriends[_shiftFriend].name + ' продает:';
        }
        _source.addChild(_txtName);

        if (_arrFriends.length <= 2) {
            _item = new MarketFriendItem(_arrFriends[_shiftFriend], this, _shiftFriend);
            _item.source.y = -180;
            if (_arrFriends[_shiftFriend] == g.user) {
                _item._visitBtn.visible = false;
            } else _item._visitBtn.visible = true;
            c = new CartonBackground(125, 115);
            c.x = 208 - 5;
            c.y = -185;
            _cont.addChild(c);
            _source.addChild(_item.source);
            if (_shiftFriend == 1) {
                _shiftFriend = -1;
            }
            _item2 = new MarketFriendItem(_arrFriends[_shiftFriend + 1], this, _shiftFriend + 1);
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
            _item._visitBtn.visible = true;
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
            if (_arrFriends[_shiftFriend] == g.user) {
                _item._visitBtn.visible = false;
            } else _item._visitBtn.visible = true;
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
        unFillItems();
        _shift = 0;
        new TweenMax(_contItemCell, .5, {x:-_shift*125, ease:Linear.easeNone});
        _countPage = 1;
        if (_person.userSocialId == g.user.userSocialId) {
            addItems(true);
            _contPaper.visible = true;
        } else {
            addItemsFriend(false,_person);
            _contPaper.visible = false;
        }
        fillItemsByUser(_person);
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
        var tween:Tween = new Tween(_leftBtn, 0.2);
        tween.scaleTo(0.2);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(0.4);
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
        if (_rightBtn.filter == ManagerFilters.BUTTON_DISABLE_FILTER) return;
        var tween:Tween = new Tween(_rightBtn, 0.2);
        tween.scaleTo(0.2);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(0.4);
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
//            _txtNumberPage.text = '1';
            _leftBtn.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        } else {
            _leftBtn.filter = null;
        }
        if ((_shift+4)*2 >= _arrItems.length) {
            _rightBtn.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        } else {
            _rightBtn.filter = null;
        }
    }

    public function getItemProperties(a:int):Object {
        if (_arrItems && _arrItems.length) {
            return (_arrItems[a-1] as MarketItem).getItemProperties();
        } else {
            return {};
        }
    }

    public function onItemClickAndOpenWOChoose(item:MarketItem):void {
        g.windowsManager.cashWindow = this;
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_MARKET_CHOOSE, callbackFromMarketChoose, item);
    }

    private function callbackFromMarketChoose(item:MarketItem, a:int, count:int = 0, cost:int = 0, inPapper:Boolean = false):void {
        if (a>0) {
            item.onChoose(a, count, cost, inPapper);
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        var i:int;
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
        callbackState();
        super.deleteIt();
        _SHADOW.dispose();
        _SHADOW = null;
    }
}
}
