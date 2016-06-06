package analytic {
import analytic.google.GAFarm;
import manager.Vars;

public class AnalyticManager {
    public static var EVENT:String = 'event'; // event category
    public static var ACTION_ERROR:String = 'error';
    public static var ACTION_TUTORIAL:String = 'tutorial';
    public static var ACTION_ON_LOAD_GAME:String = 'onload';
    public static var ACTION_TEST:String = 'test';

    private var _googleAnalytic:GAFarm;
    private var g:Vars = Vars.getInstance();

    public function AnalyticManager() {
        _googleAnalytic = new GAFarm();
    }

    public function sendActivity(category:String, action:String, obj:Object):void {
        _googleAnalytic.sendActivity(category, action, obj);
    }


}
}
