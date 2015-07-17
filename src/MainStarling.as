/**
 * Created by andriy.grynkiv on 16/03/14.
 */
package {
import com.junkbyte.console.Cc;

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

        var max:int = 89;
        var cur:int;
        sAssets.loadQueue(function (ratio:Number):void {
            cur = int(max * ratio);
            g.startPreloader.setProgress(cur);
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
