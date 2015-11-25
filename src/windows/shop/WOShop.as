/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import data.BuildType;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;

import windows.WOComponents.CartonBackground;

import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOShop extends Window{
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

    public function WOShop() {
        super();
        _woWidth = 750;
        _woHeight = 590;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('bt_close'), '');
        _btnExit.x += _woWidth/2;
        _btnExit.y -= _woHeight/2;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        _shopSprite = new Sprite();
        _shopSprite.x = -_woWidth/2 + 41;
        _shopSprite.y = -_woHeight/2 + 141;
        _shopSprite.filter = BlurFilter.createDropShadow(1, 0.785, 0, 1, 1.0, 0.5);
        _source.addChild(_shopSprite);
        _contSprite = new Sprite();
        _contSprite.x = -_woWidth/2 + 41;
        _contSprite.y = -_woHeight/2 + 141;
        _source.addChild(_contSprite);
        _shopList = new ShopList(_contSprite);
        createShopTabBtns();
        curentTab = 1;
    }

    public function onClickExit(e:Event=null):void {
        _shopList.clearIt();
        hideIt();
    }

    override public function showIt():void{
        super.showIt();
        onTab(curentTab);
    }

    public function activateTab(a:int):void {
        curentTab = a;
    }

    public function createShopTabBtns():void {
        var c:CartonBackground = new CartonBackground(666, 320);
        _shopSprite.addChild(c);

        _btnTab1 = new ShopTabBtn(ShopTabBtn.VILLAGE, function():void {onTab(1)});
        _btnTab1.setPosition(7, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab1.source);
        _source.addChildAt(_btnTab1.cloneSource, 2);
        _btnTab2 = new ShopTabBtn(ShopTabBtn.ANIMAL, function():void {onTab(2)});
        _btnTab2.setPosition(7 + 133, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab2.source);
        _source.addChildAt(_btnTab2.cloneSource, 2);
        _btnTab3 = new ShopTabBtn(ShopTabBtn.FABRICA, function():void {onTab(3)});
        _btnTab3.setPosition(7 + 133*2, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab3.source);
        _source.addChildAt(_btnTab3.cloneSource, 2);
        _btnTab4 = new ShopTabBtn(ShopTabBtn.PLANT, function():void {onTab(4)});
        _btnTab4.setPosition(7 + 133*3, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab4.source);
        _source.addChildAt(_btnTab4.cloneSource, 2);
        _btnTab5 = new ShopTabBtn(ShopTabBtn.DECOR, function():void {onTab(5)});
        _btnTab5.setPosition(7 + 133*4, - 81, _shopSprite.x, _shopSprite.y);
        _shopSprite.addChild(_btnTab5.source);
        _source.addChildAt(_btnTab5.cloneSource, 2);
    }

    private function onTab(a:int):void {
        var arr:Array = [];
        var obj:Object;
        var id:String;

        curentTab = a;
        _btnTab1.activateIt(false);
        _btnTab2.activateIt(false);
        _btnTab3.activateIt(false);
        _btnTab4.activateIt(false);
        _btnTab5.activateIt(false);

        switch (a) {
            case 1: _btnTab1.activateIt(true);
                obj = g.dataBuilding.objectBuilding;
                for (id in obj) {
                    if (obj[id].buildType == BuildType.RIDGE || obj[id].buildType == BuildType.FARM || obj[id].buildType == BuildType.PET_HOUSE) {
                        arr.push(obj[id]);
                    }
                }
                break;
            case 2: _btnTab2.activateIt(true);
                obj = g.dataAnimal.objectAnimal;
                arr.push(g.managerCats.catInfo);
                for (id in obj) {
                        arr.push(obj[id]);
                }
                break;
            case 3: _btnTab3.activateIt(true);
                obj = g.dataBuilding.objectBuilding;
                for (id in obj) {
                    if (obj[id].buildType == BuildType.FABRICA) {
                        arr.push(obj[id]);
                    }
                }
                break;
            case 4: _btnTab4.activateIt(true);
                obj = g.dataBuilding.objectBuilding;
                for (id in obj) {
                    if (obj[id].buildType == BuildType.TREE) {
                        arr.push(obj[id]);
                    }
                }
                break;
            case 5: _btnTab5.activateIt(true);
                obj = g.dataBuilding.objectBuilding;
                for (id in obj) {
                    if (obj[id].buildType == BuildType.DECOR || obj[id].buildType == BuildType.DECOR_FULL_FENСE ||
                            obj[id].buildType == BuildType.DECOR_POST_FENCE || obj[id].buildType == BuildType.DECOR_TAIL) {
                        arr.push(obj[id]);
                    }
                }
                break;
        }
        _shopList.clearIt();
        _shopList.fillIt(arr);
    }
}
}
