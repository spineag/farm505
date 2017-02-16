/**
 * Created by user on 2/15/17.
 */
package windows.salePack {
import windows.WindowMain;
import windows.WindowsManager;

public class WOSalePack extends WindowMain{
    public function WOSalePack() {
        _woHeight = 505;
        _woWidth = 740;
        _windowType = WindowsManager.WO_SALE_PACK;
    }
    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }
}
}
