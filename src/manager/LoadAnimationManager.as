/**
 * Created by andy on 5/19/16.
 */
package manager {
public class LoadAnimationManager {
    private var additionalQueue:Object = new Object();
    private var g:Vars = Vars.getInstance();

    public function LoadAnimationManager() {
        additionalQueue = {};
    }

    public function load(url:String, name:String, f:Function):void {
        url = g.dataPath.getGraphicsPath() + url;
        if (!additionalQueue[url]) {
            additionalQueue[url] = [];
            new LoadAnimation(url, name, onLoad);
        }
        additionalQueue[url].push({callback: f});
    }

    private function onLoad(url:String):void {
        if (additionalQueue[url] && additionalQueue[url].length) {
            for (var i:int = 0; i < additionalQueue[url].length; i++) {
                if (additionalQueue[url][i].callback != null) {
                    additionalQueue[url][i].callback.apply();
                }
            }
            delete additionalQueue[url];
        }
    }
}
}
