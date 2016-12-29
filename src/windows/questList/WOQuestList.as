/**
 * Created by andy on 12/29/16.
 */
package windows.questList {
import windows.WOComponents.Birka;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOQuestList extends WindowMain{
    private var _woBG:WindowBackground;
    private var _birka:Birka;
    private var _items:Array; 

    public function WOQuestList() {
        super();
        _windowType = WindowsManager.WO_BUY_PLANT;
        _woWidth = 580;
        _woHeight = 134;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _callbackClickBG = onClickExit;

        _birka = new Birka('Задания', _source, _woWidth, _woHeight);
        _birka.flipIt();
        _birka.source.rotation = Math.PI/2;
        _birka.source.x = 80;
        _birka.source.y = -250;
    }
    
    override public function showIt():void {
//        var ar:Array = g.managerQuest.
        
        super.showIt();
    }

    private function onClickExit():void {
        super.hideIt();
    }

}
}
