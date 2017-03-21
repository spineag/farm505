/**
 * Created by user on 3/20/17.
 */
package achievement {
public class ManagerAchievement {

    public static const TAKE_PRODUCTS:int = 1; // +Собрать продукты
    public static const OTHER:int = 0; // +Купи декораций для фермы на n монет
    public var dataAchievement:Array;
    public var userAchievement:Array;


    public function ManagerAchievement() {
        dataAchievement = [];
        userAchievement = [];
    }
}
}
