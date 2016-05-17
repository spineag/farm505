/**
 * Created by andriy.grynkiv on 16/03/14.
 */
package {
import manager.AllData;
import manager.DataPath;
import manager.EmbedAssets;
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
        g.allData = new AllData();
        g.load = LoaderManager.getInstance();
        g.dataPath = new DataPath();
        g.pBitmaps = {};
        g.pXMLs = {};

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
        new LoadComponents(onLoad);
    }

    private function onLoad():void {
        dispatchEventWith(MainStarling.LOADED);
        g.initInterface();
    }

}
}
