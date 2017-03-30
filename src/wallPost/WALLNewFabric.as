/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;

import loaders.PBitmap;

import manager.Vars;
import social.SocialNetworkSwitch;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import utils.DrawToBitmap;

public class WALLNewFabric {
    protected var g:Vars = Vars.getInstance();
    private var _data:Object;

    public function WALLNewFabric(callback:Function, params:Object):void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID || g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[470]), null, 'https://505.ninja/content/wall/ok/wall_OK_fabric.png');
        } else {
            _data = params;
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'wall/wall_new_fabric.jpg', onLoad);
        }
    }

    private function onLoad(bitmap:Bitmap):void {
        var source:Sprite = new Sprite();
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_fabric.jpg'].create() as Bitmap;
        source.addChild(new Image(Texture.fromBitmap(bitmap)));
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
            }
        }
        var im:Image = new Image(texture);
        im.alignPivot();
        im.x = 220;
        im.y = 295;
        source.addChild(im);
        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(Starling.current, source);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String(g.managerLanguage.allTexts[470]),bitMap,'interfaceAtlas');
        (g.pBitmaps[st + 'wall/wall_new_fabric.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[st + 'wall/wall_new_fabric.jpg'];
        _data = null;
    }
}
}

