/**
 * Created by andriy.grynkiv on 16/03/14.
 */
package {
import data.AllData;
import loaders.DataPath;
import loaders.EmbedAssets;
import loaders.LoadAnimationManager;
import loaders.LoadComponents;
import loaders.LoaderManager;
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
        g.load = LoaderManager.getInstance();
        g.pBitmaps = {};
        g.pXMLs = {};
        g.loadAnimation = new LoadAnimationManager();

        sAssets = new AssetManager();
        sAssets.verbose = true;
        sAssets.enqueue(EmbedAssets);

        var max:int = 5;
        var cur:int;
        sAssets.loadQueue(function (ratio:Number):void {
            cur = int(max * ratio);
            g.startPreloader.setProgress(cur);
            if (ratio == 1.0){
                loadComponents();
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
        dispatchEventWith(MainStarling.LOADED);
        g.initInterface();
    }

}
}
