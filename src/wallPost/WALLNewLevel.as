/**
 * Created by user on 5/23/16.
 */
package wallPost {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.display.Bitmap;

import flash.external.ExternalInterface;

import manager.Vars;

import social.vk.SN_Vkontakte;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class WALLNewLevel {
    protected var g:Vars = Vars.getInstance();
    private var _arrItems:Array;
    private var _contImage:Sprite;

    public function WALLNewLevel() {
        _arrItems = [];
    }

    public function showItParams(callback:Function, params:Array):void {
        var obj:Object;
        var id:String;

//        _arrItems = Array(params);
//        for (var i:int = 0; i < _arrItems.length; i++) {
//            if (_arrItems[i].buildType == BuildType.FARM) {
//                obj = g.dataAnimal.objectAnimal;
//                for (id in obj) {
//                    if (obj[id].buildId == _arrItems[i].id){
//                        _arrItems.push(obj[id]);
//                    }
//                }
//            }
//            createItem(_arrItems[i],true, true, 3);
////            im = new WOLevelUpItem(arr[i],true, true, 3);
//            im.source.x = int(i) * (90);
//            _arrCells.push(im);
//            _contImage.addChild(im.source);
//        }
//        if (_arrCells.length == 1) {
//            _contImage.x = 200;
//        } else if (_arrCells.length == 2) {
//            _contImage.x = 160;
//        } else if (_arrCells.length == 3) {
//            _contImage.x = 100;
//        } else if (_arrCells.length == 4) {
//            _contImage.x = 50;
//        } else if (_arrCells.length == 5) {
//            _contImage.x = 3;
//        }
//        g.socialNetwork.makeScreenShot();
        var network:SN_Vkontakte = new SN_Vkontakte(g.flashVars,g.dataPath.getMainPath());
        var bitMap:Bitmap = g.socialNetwork.makeScreenShot();
        network.wallPostBitmap(String(g.user.userSocialId),String('Поздровляю'),bitMap,'buildAtlas');//g.allData.atlas['interfaceAtlas'].getTexture('newlevel_window_fon'));






//        var bitMap:Bitmap;
////        var loader:URLLoader = new URLLoader();
//
//        bitMap = g.makeLevelScreenShot.getScreenShot();
//        if (!bitMap) {
//            g.makeLevelScreenShot.onError();
//            return;
//        }
//        Cc.obj("social", e, "before loading", 5);
//        var form:Multipart = new Multipart(e.upload_url);
//        var enc:JPGEncoder = new JPGEncoder(80);
//        var jpg:ByteArray = enc.encode(bitMap.bitmapData);
//        form.addFile("file1", jpg, "application/octet-stream", "Screenshot.jpg");
//
//        loader.addEventListener(Event.COMPLETE, photoLoadedToVkAlbum);
//        try {
//            Cc.ch("social", "after loading screenshot to VK", 5);
//            loader.load(form.request);
//        } catch (error:Error) {
//            g.makeLevelScreenShot.onError();
//            Cc.ch("social", "Problem with save screenshot to album on VK: " + error.message, 9);
//        }



    }

    public function createItem(ob:Object, boNew:Boolean, boCount:Boolean, count:int = 0):void {

    }
}
}
