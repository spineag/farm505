/**
 * Created by user on 1/30/17.
 */
package windows.partWindow {
import windows.WindowMain;
import windows.WindowsManager;

public class WOPartyWindow extends WindowMain{
    public function WOPartyWindow() {
        _windowType = WindowsManager.WO_PARTY;

    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override protected function deleteIt():void {
        super.deleteIt();
    }
}
}
