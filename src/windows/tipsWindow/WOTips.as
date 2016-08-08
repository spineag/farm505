/**
 * Created by user on 8/8/16.
 */
package windows.tipsWindow {
import manager.ManagerFilters;
import starling.text.TextField;
import starling.utils.Color;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTips  extends WindowMain {
    private var _woBG:WindowBackground;
    private var _carton:CartonBackground;

    public function WOTips() {
        super();
        _windowType = WindowsManager.WO_TIPS;
        _woWidth = 580;
        _woHeight = 520;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        var txt:TextField = new TextField(420,80,'Якби текст zr',g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        txt.autoScale = true;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -210;
        txt.y = -130;
        txt.touchable = false;
        _source.addChild(txt);

        _carton = new CartonBackground(470, 440);
        _carton.x = -235;
        _carton.y = -220;
        _source.addChild(_carton);
    }

    override protected function deleteIt():void {

    }

}
}
