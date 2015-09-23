/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import data.BuildType;

import starling.display.Image;
import starling.events.Event;

import windows.Window;

public class WOShop extends Window{
    private var _btnTab1:ShopTabBtn;
    private var _btnTab2:ShopTabBtn;
    private var _btnTab3:ShopTabBtn;
    private var _btnTab4:ShopTabBtn;
    private var _btnTab5:ShopTabBtn;
    private var _shopList:ShopList;

    public function WOShop() {
        super();
        _woHeight = 784;
        _woWidth = 572;
        createBG();
        _shopList = new ShopList(_source);
        createShopTabBtns();
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x = 370;
        _btnExit.y = -205;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
    }

    private function createBG():void {
        var im:Image;

        im = new Image(g.interfaceAtlas.getTexture('board_shop_part'));
        im.x = -im.width;
        im.y = -im.height/2;
        _source.addChild(im);
        im = new Image(g.interfaceAtlas.getTexture('board_shop_part'));
        im.scaleX = -1;
        im.x = im.width;
        im.y = -im.height/2;
        _source.addChild(im);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    private function createShopTabBtns():void {
        var w:int;

        _btnTab1 = new ShopTabBtn('Двор', function():void {onTab(1)});
        w = _btnTab1.source.width;
        _btnTab1.source.x = -2.5 * w - 10;
        _btnTab1.source.y = -190;
        _source.addChild(_btnTab1.source);
        _btnTab2 = new ShopTabBtn('Животные', function():void {onTab(2)});
        _btnTab2.source.x = -1.5 * w - 5;
        _btnTab2.source.y = -190;
        _source.addChild(_btnTab2.source);
        _btnTab3 = new ShopTabBtn('Фабрики', function():void {onTab(3)});
        _btnTab3.source.x = -.5 * w;
        _btnTab3.source.y = -190;
        _source.addChild(_btnTab3.source);
        _btnTab4 = new ShopTabBtn('Растения', function():void {onTab(4)});
        _btnTab4.source.x = .5 * w + 5;
        _btnTab4.source.y = -190;
        _source.addChild(_btnTab4.source);
        _btnTab5 = new ShopTabBtn('Декор', function():void {onTab(5)});
        _btnTab5.source.x = 1.5 * w + 10;
        _btnTab5.source.y = -190;
        _source.addChild(_btnTab5.source);

        onTab(1);
    }

    private function onTab(a:int):void {
        var arr:Array = [];
        var obj:Object;
        var id:String;

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
                for (id in obj) {
                    //if (obj[id].buildType == BuildType.ANIMAL) {
                        arr.push(obj[id]);
                    //}
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

        _shopList.fillIt(arr);
    }
}
}
