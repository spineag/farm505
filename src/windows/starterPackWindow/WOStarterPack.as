/**
 * Created by user on 12/28/16.
 */
package windows.starterPackWindow {
import data.BuildType;

import flash.display.Bitmap;

import manager.ManagerFilters;

import manager.Vars;


import starling.display.Image;
import starling.events.Event;

import starling.textures.Texture;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import windows.WindowMain;
import windows.WindowsManager;

public class WOStarterPack extends WindowMain{

    public function WOStarterPack() {
        super();
        _windowType = WindowsManager.WO_STARTER_PACK;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/sp_back_empty.png',onLoad);
        g.directServer.getStarterPack(callbackServer);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'qui/sp_back_empty.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var image:Image = new Image(tex);
        image.pivotX = image.width/2;
        image.pivotY = image.height/2;
        _source.addChild(image);
    }

    private function callbackServer(ob:Object):void {
        var txt:CTextField;
        var im:Image;

        txt = new CTextField(77, 40, String(ob.soft_count));
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR);
        _source.addChild(txt);

        txt = new CTextField(77, 40, String(ob.hard_count));
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR);
        _source.addChild(txt);

        txt = new CTextField(77, 40, 'Монеты');
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR);
        _source.addChild(txt);

        txt = new CTextField(77, 40, "Рубины");
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR);
        _source.addChild(txt);

       if (ob.object_type == BuildType.RESOURCE || ob.object_type == BuildType.INSTRUMENT || ob.object_type == BuildType.PLANT) {
           im = new Image(g.allData.atlas[g.dataResource.objectResources[ob.object_id].url].getTexture(g.dataResource.objectResources[ob.object_id].shopImage))
       } else if (ob.object_type == BuildType.DECOR_ANIMATION) {

       } else if (ob.object_type) {

       }

    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    private function onClickExit(e:Event = null):void {
        if (g.user.level >= 5 && g.user.dayDailyGift == 0) g.directServer.getDailyGift(null);
        else {
            var todayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
            var today:Date = new Date();
            if (g.user.level >= 5 && todayDailyGift.date != today.date) {
                g.directServer.getDailyGift(null);
            }
        }
        super.hideIt();
    }

    override protected function deleteIt():void {
        super.deleteIt();
    }

}
}
