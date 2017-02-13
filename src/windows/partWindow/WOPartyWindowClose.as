/**
 * Created by user on 2/10/17.
 */
package windows.partWindow {
import data.BuildType;
import data.DataMoney;

import flash.display.Bitmap;
import flash.geom.Point;

import manager.ManagerFilters;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Quad;

import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import temp.DropResourceVariaty;

import utils.CButton;

import utils.CTextField;

import windows.WindowMain;

public class WOPartyWindowClose extends WindowMain{
    private var _txtResource:CTextField;
    private var _txtCoin:CTextField;
    private var _txtBtn:CTextField;
    private var _btnClose:CButton;

    public function WOPartyWindowClose() {
        _woHeight = 451;
        _woWidth = 695;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/valentine_window_end.png',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'qui/valentine_window_end.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var image:Image = new Image(tex);
        image.pivotX = image.width/2;
        image.pivotY = image.height/2;
        _source.addChild(image);
        createExitButton(hideIt);
        _txtResource = new CTextField(200, 40, String(g.userInventory.getCountResourceById(168)));
        _txtResource.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR , Color.WHITE);
        _txtResource.alignH = Align.LEFT;
        _txtResource.x = -105 - _txtResource.textBounds.width/2;
        _txtResource.y = 25;
        _source.addChild(_txtResource);
        _txtCoin = new CTextField(200, 40, String(g.dataResource.objectResources[168].costMax * g.userInventory.getCountResourceById(168)));
        _txtCoin.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR , Color.WHITE);
        _txtCoin.alignH = Align.LEFT;
        _txtCoin.x = 75 - _txtCoin.textBounds.width/2;
        _txtCoin.y = 25;
        _source.addChild(_txtCoin);
//        var _quad:Quad = new Quad(3.2, 3, 0xfbaaa7);
//        _quad.x = 75;
//        _quad.y = 40;
//        _source.addChild(_quad);
        _btnClose = new CButton();
        _btnClose.addButtonTexture(172, 45, CButton.GREEN, true);
        _txtBtn = new CTextField(172, 45, "ОК");
        _txtBtn.setFormat(CTextField.BOLD18, 18,Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btnClose.addChild(_txtBtn);
        _btnClose.clickCallback = hideIt;
        _btnClose.y = 200;
        _source.addChild(_btnClose);
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override public function hideIt():void {
        var obj:Object;
        obj = {};
        obj.count = g.dataResource.objectResources[168].costMax * g.userInventory.getCountResourceById(168);
        obj.id = DataMoney.SOFT_CURRENCY;
        new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, obj);
        for (var i:int = 0; i < g.managerParty.userParty.tookGift.length; i++) {
            if (!g.managerParty.userParty.tookGift[i] && g.managerParty.userParty.countResource >= g.managerParty.dataParty.countToGift[i] ) {
                if (g.managerParty.dataParty.typeGift[i] == BuildType.DECOR_ANIMATION) {
                    obj.count = 1;
                    obj.id =  g.managerParty.dataParty.idGift[i];
                    obj.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;
                } else if (g.managerParty.dataParty.typeGift[i] == BuildType.DECOR) {
                    obj.count = 1;
                    obj.id =  g.managerParty.dataParty.idGift[i];
                    obj.type = DropResourceVariaty.DROP_TYPE_DECOR;
                } else {
                    if (g.managerParty.dataParty.idGift[i] == 1 && g.managerParty.dataParty.typeGift[i] == 1) {
                        obj.id = DataMoney.SOFT_CURRENCY;
                        obj.type = DropResourceVariaty.DROP_TYPE_MONEY;
                    }
                    else if (g.managerParty.dataParty.idGift[i] == 2 && g.managerParty.dataParty.typeGift[i] == 2) {
                        obj.id = DataMoney.HARD_CURRENCY;
                        obj.type = DropResourceVariaty.DROP_TYPE_MONEY;
                    }
                    else {
                        obj.id = g.managerParty.dataParty.idGift[i];
                        obj.type = DropResourceVariaty.DROP_TYPE_RESOURSE;
                    }
                    obj.count = g.managerParty.dataParty.countGift[i];
                }
                new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, obj);
            }
        }
        g.userInventory.addResource(168,-g.userInventory.getCountResourceById(168));
        g.managerParty.endParty();
        super.hideIt();
    }
}
}
