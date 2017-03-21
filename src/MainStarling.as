/**
 * Created by andriy.grynkiv on 16/03/14.
 */
package {
import loaders.DataPath;
import loaders.EmbedAssets;
import loaders.LoadAnimationManager;
import loaders.LoadComponents;
import loaders.LoaderManager;
import loaders.allLoadMb.AllLoadMb;

import manager.Vars;
import manager.hitArea.ManagerHitArea;
import server.DirectServer;

import social.SocialNetwork;
import social.SocialNetworkSwitch;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class MainStarling extends Sprite {
    public static const LOADED : String = "LOADED";

    private var g:Vars = Vars.getInstance();
    private var sAssets:AssetManager;

    public function MainStarling() {}

    public function start():void {
        g.dataPath = new DataPath();
        g.loadMb = new AllLoadMb();
        g.load = LoaderManager.getInstance();
        g.pXMLs = {};
        g.pJSONs = {};
        g.loadAnimation = new LoadAnimationManager();
        g.managerHitArea = new ManagerHitArea();

        sAssets = new AssetManager();
        sAssets.verbose = true;
        sAssets.enqueue(EmbedAssets);

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
        g.directServer = new DirectServer();
        g.version = {};
        g.socialNetwork = new SocialNetwork(g.flashVars);
        if (g.isDebug) {
            g.socialNetworkID = SocialNetworkSwitch.SN_VK_ID;
        } else {
            g.socialNetworkID = int(g.flashVars['channel']);
        }
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
