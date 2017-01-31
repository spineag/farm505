/**
 * Created by user on 1/30/17.
 */
package windows.eventWindow {
import windows.WindowMain;
import windows.WindowsManager;

public class WOEventWindow extends WindowMain{
    public function WOEventWindow() {
        _windowType = WindowsManager.WO_EVENT;

    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override protected function deleteIt():void {
        super.deleteIt();
    }
}
}
