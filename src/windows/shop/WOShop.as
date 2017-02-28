/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import data.BuildType;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.DropShadowFilter;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.Utils;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.HorizontalPlawka;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOShop extends WindowMain {
    public static const VILLAGE:int=1;
    public static const ANIMAL:int=2;
    public static const FABRICA:int=3;
    public static const PLANT:int=4;
    public static const DECOR:int=5;

    private var _contCoupone:Sprite;
    private var _btnTab1:ShopTabBtn;
    private var _btnTab2:ShopTabBtn;
    private var _btnTab3:ShopTabBtn;
    private var _btnTab4:ShopTabBtn;
    private var _btnTab5:ShopTabBtn;
    private var _shopList:ShopList;
    private var curentTab:int;
    private var _shopSprite:Sprite;
    private var _contSprite:Sprite;
    private var _woBG:WindowBackground;
    private var _txtHardMoney:CTextField;
    private var _txtSoftMoney:CTextField;
    private var _txtBlueMoney:CTextField;
    private var _txtGreenMoney:CTextField;
    private var _txtYellowMoney:CTextField;
    private var _txtRedMoney:CTextField;
    private var _animal:Boolean;
    private var _birka:Birka;
    private var _shopCartonBackground:CartonBackground;
    private var _pl1:HorizontalPlawka;
    private var _pl2:HorizontalPlawka;
    private var _pl3:HorizontalPlawka;
    private var _shopTabBtnCont:Sprite;
    private var _decorFilter:DecorShopFilter;
    private var _idArrowAnimal:int;
    private var _txtR:CTextField;

    public function WOShop() {
        super();
        _windowType = WindowsManager.WO_SHOP;
        _woWidth = 750;
        _woHeight = 590;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _shopTabBtnCont = new Sprite();
        _source.addChild(_shopTabBtnCont);
        _shopSprite = new Sprite();
        _shopSprite.x = -_woWidth/2 + 41;
        _shopSprite.y = -_woHeight/2 + 141;
        _shopSprite.filter = ManagerFilters.SHADOW;
        _source.addChild(_shopSprite);
        _contSprite = new Sprite();
        _contSprite.x = -_woWidth/2 + 41;
        _contSprite.y = -_woHeight/2 + 141;
        _source.addChild(_contSprite);
        _shopList = new ShopList(_contSprite, this);
        createShopTabBtns();
        curentTab = 0;
        _contCoupone = new Sprite();
        _source.addChild(_contCoupone);
        
        _decorFilter = new DecorShopFilter(this);
        createMoneyBlock();
        if (g.user.level < 17) _contCoupone.visible = false;
            else _contCoupone.visible = true;
        _birka = new Birka('МАГАЗИН', _source, _woWidth, _woHeight);
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        if (g.user.allNotification > 0) {
            switch (curentTab) {
                case VILLAGE:
                    _btnTab1.closeNotification();
                    break;
                case ANIMAL:
                    break;
                case FABRICA:
                    _btnTab3.closeNotification();
                    break;
                case PLANT:
                    _btnTab4.closeNotification();
                    break;
                case DECOR:
                    _btnTab5.closeNotification();
                    break;
            }
        }
        g.bottomPanel.updateTextNotification();
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        updateMoneyCounts();
        if (params.length) {
            if (g.user.decorShop && !g.managerCutScenes.isCutScene) onTab(DECOR);
            else onTab(params[0]);
        } else if (curentTab > 0) {
            onTab(curentTab);
        } else {
            onTab(VILLAGE);
        }
        g.user.buyShopTab = 0;
        super.showIt();
    }

    private function activateTabBtn():void {
        switch (curentTab) {
            case VILLAGE:
                _btnTab1.activateIt(true);
                _btnTab2.activateIt(false);
                _btnTab3.activateIt(false);
                _btnTab4.activateIt(false);
                _btnTab5.activateIt(false);
                break;
            case ANIMAL:
                _btnTab1.activateIt(false);
                _btnTab2.activateIt(true);
                _btnTab3.activateIt(false);
                _btnTab4.activateIt(false);
                _btnTab5.activateIt(false);
                break;
            case FABRICA:
                _btnTab1.activateIt(false);
                _btnTab2.activateIt(false);
                _btnTab3.activateIt(true);
                _btnTab4.activateIt(false);
                _btnTab5.activateIt(false);
                break;
            case PLANT:
                _btnTab1.activateIt(false);
                _btnTab2.activateIt(false);
                _btnTab3.activateIt(false);
                _btnTab4.activateIt(true);
                _btnTab5.activateIt(false);
                break;
            case DECOR:
                _btnTab1.activateIt(false);
                _btnTab2.activateIt(false);
                _btnTab3.activateIt(false);
                _btnTab4.activateIt(false);
                _btnTab5.activateIt(true);
                break;
        }
    }

    public function onChangeDecorFilter():void {
        g.user.decorShiftShop = 0;
        onTab(DECOR);
    }

    public function createShopTabBtns():void {
        _shopCartonBackground = new CartonBackground(666, 320);
        _shopSprite.addChild(_shopCartonBackground);
        _btnTab1 = new ShopTabBtn(VILLAGE, function():void {onTab(VILLAGE)}, _shopSprite, _shopTabBtnCont);
        _btnTab1.setPosition(7, -81);
        _btnTab2 = new ShopTabBtn(ANIMAL, function():void {onTab(ANIMAL)}, _shopSprite, _shopTabBtnCont);
        _btnTab2.setPosition(7 + 133, -81);
        _btnTab3 = new ShopTabBtn(FABRICA, function():void {onTab(FABRICA)}, _shopSprite, _shopTabBtnCont);
        _btnTab3.setPosition(7 + 133*2, -81);
        _btnTab4 = new ShopTabBtn(PLANT, function():void {onTab(PLANT)}, _shopSprite, _shopTabBtnCont);
        _btnTab4.setPosition(7 + 133*3, -81);
        _btnTab5 = new ShopTabBtn(DECOR, function():void {onTab(DECOR)}, _shopSprite, _shopTabBtnCont);
        _btnTab5.setPosition(7 + 133*4, -81);
    }

    private function onTab(a:int):void {
        var arr:Array = [];
        var obj:Object;
        var st:String;
        if (g.user.allNotification > 0) {
            switch (curentTab) {
                case VILLAGE:
                    _btnTab1.closeNotification();
                    break;
                case ANIMAL:
                    break;
                case FABRICA:
                    _btnTab3.closeNotification();
                    break;
                case PLANT:
                    _btnTab4.closeNotification();
                    break;
                case DECOR:
                    _btnTab5.closeNotification();
                    break;
            }
        }
        curentTab = a;
        activateTabBtn();
        if (_animal) a = 2;

        switch (a) {
            case VILLAGE:
//                obj = g.dataBuilding.objectBuilding;
                arr.push(g.managerCats.catInfo);
                    for (var i:int = 0; i < g.allData.building.length; i++) {
                        if (g.allData.building[i] && g.allData.building[i].buildType == BuildType.RIDGE || g.allData.building[i].buildType == BuildType.FARM) {
                            arr.push(Utils.objectDeepCopy(g.allData.building[i]));
                        }
                    }
//                for (st in obj) {
//                    if (obj[st].buildType == BuildType.RIDGE || obj[st].buildType == BuildType.FARM) {
//                        arr.push(Utils.objectDeepCopy(obj[st]));
//                    }
//                }
                break;
            case ANIMAL:
                obj = g.dataAnimal.objectAnimal;
                for (st in obj) {
                        arr.push(Utils.objectDeepCopy(obj[st]));
                }
                break;
            case FABRICA:
//                obj = g.dataBuilding.objectBuilding;
                for (var i:int = 0; i < g.allData.building.length; i++) {
                    if (g.allData.building[i] && g.allData.building[i].buildType == BuildType.FABRICA) {
                        arr.push(Utils.objectDeepCopy(g.allData.building[i]));
                    }
                }
//                for (st in obj) {
//                    if (obj[st].buildType == BuildType.FABRICA) {
//                        arr.push(Utils.objectDeepCopy(obj[st]));
//                    }
//                }
                break;
            case PLANT:
                for (var i:int = 0; i < g.allData.building.length; i++) {
                    if (g.allData.building[i] && g.allData.building[i].buildType == BuildType.TREE) {
                        arr.push(Utils.objectDeepCopy(g.allData.building[i]));
                    }
                }
                break;
            case DECOR:
//                obj = g.dataBuilding.objectBuilding;
                for (var i:int = 0; i < g.allData.building.length; i++) {
                    if (g.allData.building[i].buildType == BuildType.DECOR || g.allData.building[i].buildType == BuildType.DECOR_ANIMATION || g.allData.building[i].buildType == BuildType.DECOR_FULL_FENСE ||
                            g.allData.building[i].buildType == BuildType.DECOR_POST_FENCE || g.allData.building[i].buildType == BuildType.DECOR_TAIL || g.allData.building[i].buildType == BuildType.DECOR_FENCE_GATE ||
                            g.allData.building[i].buildType == BuildType.DECOR_FENCE_ARKA) {
                        if (g.user.shopDecorFilter == DecorShopFilter.FILTER_ALL || g.user.shopDecorFilter == g.allData.building[i].filterType) {
                            if (g.allData.building[i].buildType == BuildType.DECOR || g.allData.building[i].buildType == BuildType.DECOR_ANIMATION || g.allData.building[i].buildType == BuildType.DECOR_TAIL) {
                                if (g.allData.building[i].group && !g.allData.isFirstInGroupDecor(g.allData.building[i].group, obj[st].id))
                                    continue;
                            }
                            arr.push(Utils.objectDeepCopy(obj[st]));
                        }
                    }
                }
//                for (st in obj) {
//                    if (obj[st].buildType == BuildType.DECOR || obj[st].buildType == BuildType.DECOR_ANIMATION || obj[st].buildType == BuildType.DECOR_FULL_FENСE ||
//                            obj[st].buildType == BuildType.DECOR_POST_FENCE || obj[st].buildType == BuildType.DECOR_TAIL || obj[st].buildType == BuildType.DECOR_FENCE_GATE ||
//                            obj[st].buildType == BuildType.DECOR_FENCE_ARKA) {
//                        if (g.user.shopDecorFilter == DecorShopFilter.FILTER_ALL || g.user.shopDecorFilter == obj[st].filterType) {
//                            if (obj[st].buildType == BuildType.DECOR || obj[st].buildType == BuildType.DECOR_ANIMATION || obj[st].buildType == BuildType.DECOR_TAIL) {
//                                if (obj[st].group && !g.allData.isFirstInGroupDecor(obj[st].group, obj[st].id))
//                                    continue;
//                            }
//                            arr.push(Utils.objectDeepCopy(obj[st]));
//                        }
//                    }
//                }
                break;
        }
        if (curentTab == DECOR) {
            _shopList.clearIt(true);
            _decorFilter.visible = true;
        } else {
            _shopList.clearIt();
            _decorFilter.visible = false;
        }
        _shopList.fillIt(arr, g.user.animalIdArrow);
        _animal = false;
        g.user.animalIdArrow = -1;
    }

    public function onClickItemClose ():void {
        if (g.user.allNotification > 0) {
            switch (curentTab) {
                case VILLAGE:
                    _btnTab1.closeNotification();
                    break;
                case ANIMAL:
                    break;
                case FABRICA:
                    _btnTab3.closeNotification();
                    break;
                case PLANT:
                    _btnTab4.closeNotification();
                    break;
                case DECOR:
                    _btnTab5.closeNotification();
                    break;
            }
        }
        g.bottomPanel.updateTextNotification();
    }

    private function createMoneyBlock():void {
        _txtR = new CTextField(250, 40, 'Ваши сбережения:');
        _txtR.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtR.x = -_woWidth/2 + 238;
        _txtR.y = -_woHeight/2 + 461;
        _source.addChild(_txtR);

        _pl1 = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
            g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 104);
        _pl1.x = -_woWidth/2 + 63;
        _pl1.y = -_woHeight/2 + 509;
        _source.addChild(_pl1);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 46, 46);
        im.x = -_woWidth/2 + 41;
        im.y = -_woHeight/2 + 505;
        _source.addChild(im);
        var btn:CButton = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 38, 38);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 24, 24);
        im.x = im.y = 7;
        btn.addChild(im);
        btn.x = -_woWidth/2 + 163;
        btn.y = -_woHeight/2 + 528;
        _source.addChild(btn);
        var f1:Function = function ():void {
            if (g.managerCutScenes.isCutScene) return;
            if (g.managerTutorial.isTutorial) return;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
        };
        btn.clickCallback = f1;

        _pl2 = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 104);
        _pl2.x = -_woWidth/2 + 218;
        _pl2.y = -_woHeight/2 + 509;
        _source.addChild(_pl2);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(im, 48, 48);
        im.x = -_woWidth/2 + 196;
        im.y = -_woHeight/2 + 504;
        _source.addChild(im);
        btn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 38, 38);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 24, 24);
        im.x = im.y = 7;
        btn.addChild(im);
        btn.x = -_woWidth/2 + 319;
        btn.y = -_woHeight/2 + 528;
        _source.addChild(btn);
        var f2:Function = function ():void {
            if (g.managerCutScenes.isCutScene) return;
            if (g.managerTutorial.isTutorial) return;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, false);
        };
        btn.clickCallback = f2;

        _pl3 = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 310);
        _pl3.x = -_woWidth/2 + 380;
        _pl3.y = -_woHeight/2 + 509;
        _contCoupone.addChild(_pl3);
        btn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 38, 38);
        btn.addDisplayObject(im);
        btn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 24, 24);
        im.x = im.y = 7;
        btn.addChild(im);
        btn.x = -_woWidth/2 + 687;
        btn.y = -_woHeight/2 + 528;
        _contCoupone.addChild(btn);
        var f3:Function = function ():void {
            if (g.managerTutorial.isTutorial) return;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE, null);
        };
        btn.clickCallback = f3;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone'));
        MCScaler.scale(im, 45, 45);
        im.x = -_woWidth/2 + 364;
        im.y = -_woHeight/2 + 505;
        _contCoupone.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone'));
        MCScaler.scale(im, 45, 45);
        im.x = -_woWidth/2 + 439;
        im.y = -_woHeight/2 + 505;
        _contCoupone.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone'));
        MCScaler.scale(im, 45, 45);
        im.x = -_woWidth/2 + 514;
        im.y = -_woHeight/2 + 505;
        _contCoupone.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone'));
        MCScaler.scale(im, 45, 45);
        im.x = -_woWidth/2 + 589;
        im.y = -_woHeight/2 + 505;
        _contCoupone.addChild(im);

        _txtHardMoney = new CTextField(63, 33, '88888');
        _txtHardMoney.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtHardMoney.x = -_woWidth/2 + 82;
        _txtHardMoney.y = -_woHeight/2 + 511;
        _source.addChild(_txtHardMoney);
        _txtSoftMoney = new CTextField(63, 33, '88888');
        _txtSoftMoney.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtSoftMoney.x = -_woWidth/2 + 240;
        _txtSoftMoney.y = -_woHeight/2 + 511;
        _source.addChild(_txtSoftMoney);
        _txtRedMoney = new CTextField(39, 33, '888');
        _txtRedMoney.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtRedMoney.x = -_woWidth/2 + 401;
        _txtRedMoney.y = -_woHeight/2 + 511;
        _contCoupone.addChild(_txtRedMoney);
        _txtYellowMoney = new CTextField(39, 33, '888');
        _txtYellowMoney.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtYellowMoney.x = -_woWidth/2 + 476;
        _txtYellowMoney.y = -_woHeight/2 + 511;
        _contCoupone.addChild(_txtYellowMoney);
        _txtGreenMoney = new CTextField(39, 33, '888');
        _txtGreenMoney.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtGreenMoney.x = -_woWidth/2 + 551;
        _txtGreenMoney.y = -_woHeight/2 + 511;
        _contCoupone.addChild(_txtGreenMoney);
        _txtBlueMoney = new CTextField(39, 33, '888');
        _txtBlueMoney.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtBlueMoney.x = -_woWidth/2 + 626;
        _txtBlueMoney.y = -_woHeight/2 + 511;
        _contCoupone.addChild(_txtBlueMoney);
    }

    public function updateMoneyCounts():void {
        _txtHardMoney.text = String(g.user.hardCurrency);
        _txtSoftMoney.text = String(g.user.softCurrencyCount);
        _txtBlueMoney.text = String(g.user.blueCouponCount);
        _txtGreenMoney.text = String(g.user.greenCouponCount);
        _txtRedMoney.text = String(g.user.redCouponCount);
        _txtYellowMoney.text = String(g.user.yellowCouponCount);
    }

    public function get getAnimalClick():Boolean {
        return _animal;
    }

    public function set setAnimalClick(a:Boolean):void {
        _animal = a;
    }

    public function get getAnimalId():int {
        return _idArrowAnimal;
    }

    public function set setAnimalId(a:int):void {
        _idArrowAnimal = a;
    }

    public function getShopItemProperties(_id:int, addArrow:Boolean = false):Object {
        return _shopList.getShopItemProperties(_id, addArrow);
    }

    public function openOnResource(_id:int):void {
        _shopList.openOnResource(_id);
    }

    public function addArrow(_id:int):void {
        _shopList.addArrow(_id);
    }
    
    public function addArrowAtPos(n:int, t:int=0):void {
        _shopList.addArrowAtPos(n, t);
    }

    public function getShopDirectItemProperties(a:int):Object {
        return _shopList.getShopDirectItemProperties(a);
    }

    public function openCoupone(b:Boolean):void {
        _contCoupone.visible = b;
    }

    override protected function deleteIt():void {
        if (_txtHardMoney) {
            _source.removeChild(_txtHardMoney);
            _txtHardMoney.deleteIt();
            _txtHardMoney = null;
        }
        if (_txtSoftMoney) {
            _source.removeChild(_txtSoftMoney);
            _txtSoftMoney.deleteIt();
            _txtSoftMoney = null;
        }
        if (_txtBlueMoney) {
            _contCoupone.removeChild(_txtBlueMoney);
            _txtBlueMoney.deleteIt();
            _txtBlueMoney = null;
        }
        if (_txtGreenMoney) {
            _contCoupone.removeChild(_txtGreenMoney);
            _txtGreenMoney.deleteIt();
            _txtGreenMoney = null;
        }
        if (_txtYellowMoney) {
            _contCoupone.removeChild(_txtYellowMoney);
            _txtYellowMoney.deleteIt();
            _txtYellowMoney = null;
        }
        if (_txtRedMoney) {
            _contCoupone.removeChild(_txtRedMoney);
            _txtRedMoney.deleteIt();
            _txtRedMoney = null;
        }
        if (_txtR) {
            _txtR.deleteIt();
            _txtR = null;
        }
        if (_decorFilter) _decorFilter.deleteIt();
        if (_decorFilter) _decorFilter = null;
        if (_contCoupone) _contCoupone = null;
        if (_btnTab1) _btnTab1.deleteIt();
        if (_btnTab2) _btnTab2.deleteIt();
        if (_btnTab3) _btnTab3.deleteIt();
        if (_btnTab4) _btnTab4.deleteIt();
        if (_btnTab5) _btnTab5.deleteIt();
        if (_btnTab1) _btnTab1 = _btnTab2 = _btnTab3 = _btnTab4 = _btnTab5 = null;
        if (_shopList) _shopList.deleteIt();
        if (_shopList) _shopList = null;
        if (_source) _source.removeChild(_woBG);
        if (_woBG) _woBG.deleteIt();
        if (_woBG) _woBG = null;
        if (_source) _source.removeChild(_pl1);
        if (_pl1) _pl1.deleteIt();
        if (_pl1) _pl1 = null;
        if (_source) _source.removeChild(_pl2);
        if (_pl2) _pl2.deleteIt();
        if (_pl2) _pl2 = null;
        if (_source) _source.removeChild(_pl3);
        if (_pl3) _pl3.deleteIt();
        if (_pl3) _pl3 = null;
        if (_shopSprite) _shopSprite.removeChild(_shopCartonBackground);
        if (_shopCartonBackground) _shopCartonBackground.deleteIt();
        if (_shopCartonBackground) _shopCartonBackground = null;
        if (_source) _source.removeChild(_birka);
        if (_birka) _birka.deleteIt();
        if (_birka) _birka = null;
        if (_shopSprite) _shopSprite = null;
        if (_contSprite) _contSprite = null;
        super.deleteIt();
    }
}
}
