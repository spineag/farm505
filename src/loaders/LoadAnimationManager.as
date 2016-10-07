/**
 * Created by andy on 5/19/16.
 */
package loaders {
import manager.*;

import com.junkbyte.console.Cc;

import loaders.LoadAnimation;

public class LoadAnimationManager {
    private var additionalQueue:Object = new Object();
    private static const COUNT_PARALEL_LOADERS:int = 8;
    private var _currentLoad:Array;
    private var _waitForLoad:Array;
    private var g:Vars = Vars.getInstance();

    public function LoadAnimationManager() {
        additionalQueue = {};
        _currentLoad = [];
        _waitForLoad = [];
    }

    public function load(url:String, name:String, f:Function, ...callbackParams):void {
        url = g.dataPath.getGraphicsPath() + url;
        if (!additionalQueue[url]) {
            additionalQueue[url] = [];
            var l:LoadAnimation = new LoadAnimation(url, name, onLoad);
            if (_currentLoad.length >= COUNT_PARALEL_LOADERS) {
                _waitForLoad.push(l);
            } else {
                _currentLoad.push(l);
                l.startLoad();
            }
        }
        additionalQueue[url].push({callback: f, callbackParams: callbackParams});
    }

    private function onLoad(url:String, l:LoadAnimation):void {
        var i:int;
        if (additionalQueue[url] && additionalQueue[url].length) {
            for (i = 0; i < additionalQueue[url].length; i++) {
                if (i>50) break;
                if (additionalQueue[url][i].callback != null) {
                    additionalQueue[url][i].callback.apply(null, additionalQueue[url][i].callbackParams);
                }
            }
            delete additionalQueue[url];
        }
        i = _currentLoad.indexOf(l);
        if (i > -1) {
            _currentLoad.splice(i, 1);
        } else {
            Cc.error('LoadAnimationManager:: not in _currentLoad');
        }
        if (_waitForLoad.length) {
            l = _waitForLoad.shift();
            _currentLoad.push(l);
            l.startLoad();
        }
    }
}
}
