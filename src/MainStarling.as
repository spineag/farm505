/**
 * Created by andriy.grynkiv on 16/03/14.
 */
package {
import com.junkbyte.console.Cc;

import manager.AllData;
import manager.DataPath;
import manager.EmbedAssets;
import manager.LoadAnimationManager;
import manager.LoadComponents;
import manager.LoaderManager;
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
        g.dataPath = new DataPath();
        g.allData = new AllData();
        g.load = LoaderManager.getInstance();
        g.pBitmaps = {};
        g.pXMLs = {};
        g.loadAnimation = new LoadAnimationManager();

        sAssets = new AssetManager();
        sAssets.verbose = true;
        sAssets.enqueue(EmbedAssets);

        var max:int = 80;
        var cur:int;
        sAssets.loadQueue(function (ratio:Number):void {
            cur = int(max * ratio);
            g.startPreloader.setProgress(cur);
            if (ratio == 1.0){
                initGame();
            }
        });
    }

    private function initGame():void {
        new EmbedAssets(loadComponents);
    }

    private function loadComponents():void {
        new LoadComponents(onAllLoaded);
    }

    private function onAllLoaded():void {
        Cc.info('on all loaded');
        dispatchEventWith(MainStarling.LOADED);
        g.initInterface();
    }

}
}
