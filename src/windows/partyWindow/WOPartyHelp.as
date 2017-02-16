/**
 * Created by user on 2/8/17.
 */
package windows.partyWindow {

import flash.display.Bitmap;

import loaders.PBitmap;

import social.SocialNetworkSwitch;

import starling.display.Image;

import starling.textures.Texture;

import windows.WindowMain;


public class WOPartyHelp extends WindowMain {
    public function WOPartyHelp() {
        _woHeight = 503;
        _woWidth = 690;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/valentine_window_hint.png',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'qui/valentine_window_hint.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var image:Image = new Image(tex);
        image.pivotX = image.width/2;
        image.pivotY = image.height/2;
        _source.addChild(image);
        createExitButton(hideIt);
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override public function hideIt():void {
        super.hideIt();
    }
}
}
