/**
 * Created by andriy.grynkiv on 16/03/14.
 */
package {
import manager.EmbedAssets;
import manager.Vars;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class MainStarling extends Sprite {
    public static const LOADED : String = "LOADED";

    private var g:Vars = Vars.getInstance();
    private var sAssets:AssetManager;

    public function MainStarling() {}

    public function start() : void
    {
        sAssets = new AssetManager();
        sAssets.verbose = true;
        sAssets.enqueue(EmbedAssets);
        //addChild(progress);
        sAssets.loadQueue(function (ratio:Number):void {
            if (ratio == 1.0){
                dispatchEventWith(MainStarling.LOADED);
                initGame();
            }
        });
    }

    private function initGame():void {
        var embedAsset:EmbedAssets = new EmbedAssets();

        g.initInterface();
    }

}
}
