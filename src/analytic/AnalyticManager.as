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
    public static var SKIP_TIMER_TREE_TYPE:String = 'tree';
    public static var SKIP_TIMER_RIDGE_TYPE:String = 'ridge';
    public static var SKIP_TIMER_FABRICA_TYPE:String = 'fabrica';
    public static var SKIP_TIMER_FABRICA_PAPER:String = 'paper';
    public static var SKIP_TIMER_FABRICA_AERIAL_TRAM:String = 'tram';
    public static var SKIP_TIMER_FABRICA_ANIMAL:String = 'animal';
    public static var SKIP_TIMER_FABRICA_BUILDING_BUILD:String = 'build';

    public static var BUY_RESOURCE_FOR_HARD:String = 'resource_hard';
    public static var BUY_DECOR_FOR_HARD:String = 'decor_hard';


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


//g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_HARD_FOR_REAL, {id: _packId});