/**
 * Created by andriy.grynkiv on 16/03/14.
 */
package {
import loaders.EmbedAssets;
import loaders.LoadComponents;
import manager.Vars;
import manager.hitArea.ManagerHitArea;
import starling.display.Sprite;
import starling.utils.AssetManager;

public class MainStarling extends Sprite {
    public static const LOADED : String = "LOADED";

    private var g:Vars = Vars.getInstance();
    private var sAssets:AssetManager;

    public function MainStarling() {}

    public function start():void {
        g.managerHitArea = new ManagerHitArea();

        sAssets = new AssetManager();
        sAssets.verbose = true;
        sAssets.enqueue(EmbedAssets);
        g.startPreloader.setProgress(4);

        var max:int = 5;
        var cur:int;
        sAssets.loadQueue(function (ratio:Number):void {
            cur = int(max * ratio);
            g.startPreloader.setProgress(cur);
            if (ratio == 1.0){
                loadVersion();
            }
        });
    }

    private function loadVersion():void {
        g.startPreloader.setProgress(5);
        g.directServer.getVersion(loadComponents);
        g.directServer.getTextHelp(null);
    }

    private function loadComponents():void {
        new LoadComponents(onAllLoaded);
    }

    private function onAllLoaded():void {
        dispatchEventWith(MainStarling.LOADED);
        g.startUserLoad();
    }

}
}
