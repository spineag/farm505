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

    public function changeLanguage(v:int):void {
        if (g.user.language == v) return;
        if (g.user.language == 1) g.user.language = 2;
            else g.user.language = 1;
        g.directServer.changeLanguage(g.socialNetwork.reloadGame);
    }
}
}
