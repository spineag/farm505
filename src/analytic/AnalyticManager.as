package analytic {
import analytic.google.GAFarm;
import manager.Vars;

public class AnalyticManager {
    public static var EVENT:String = 'event'; // event category
    public static var ACTION_ERROR:String = 'error';
    public static var ACTION_TUTORIAL:String = 'tutorial';
    public static var ACTION_ON_LOAD_GAME:String = 'onload';
    public static var ACTION_TEST:String = 'test';
    public static var BUY_HARD_FOR_REAL:String = 'buy_hard_money';
    public static var BUY_SOFT_FOR_REAL:String = 'buy_soft_money';

    public static var SKIP_TIMER:String = 'skip_timer';
    public static var SKIP_TIMER_TREE_ID:String = 'tree';
    public static var SKIP_TIMER_PLANT_ID:String = 'plant';
    public static var SKIP_TIMER_FABRICA_ID:String = 'fabrica';
    public static var SKIP_TIMER_PAPER_ID:String = 'paper';
    public static var SKIP_TIMER_AERIAL_TRAM_ID:String = 'tram';
    public static var SKIP_TIMER_ANIMAL_ID:String = 'animal';
    public static var SKIP_TIMER_BUILDING_BUILD_ID:String = 'build';

    public static var BUY_RESOURCE_FOR_HARD:String = 'resource_hard';
    public static var BUY_DECOR_FOR_HARD:String = 'decor_hard';
    public static var BUY_SOFT_FOR_HARD:String = 'soft_hard';


    private var _googleAnalytic:GAFarm;
    private var g:Vars = Vars.getInstance();

    public function AnalyticManager() {
        _googleAnalytic = new GAFarm();
    }

    public function sendActivity(category:String, action:String, obj:Object):void {
        if (g.isDebug) return;
        _googleAnalytic.sendActivity(category, action, obj);
    }


}
}


//g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_HARD_FOR_REAL, {id: _packId});