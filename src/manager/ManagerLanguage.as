/**
 * Created by user on 3/8/17.
 */
package manager {
import windows.WindowsManager;

public class ManagerLanguage {
    public var allTexts:Object;
    private var g:Vars = Vars.getInstance();
    private var _callback:Function;

    public function ManagerLanguage(f:Function) {
        allTexts = {};
        _callback = f;
        g.directServer.getAllTexts(callbackLoad);
    }

    private function callbackLoad():void {
        if (_callback != null) {
            _callback.apply();
        }
    }

    public function changeLanguage():void {
        g.directServer.changeLanguage(null);
        g.windowsManager.openWindow(WindowsManager.WO_RELOAD_GAME,null);
    }
}
}
