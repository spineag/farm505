/**
 * Created by user on 2/15/17.
 */
package manager {
public class ManagerSalePack {
    public var dataSale:Object;
    private var g:Vars = Vars.getInstance();

    public function ManagerSalePack() {
        g.directServer.getDataSalePack(startSalePack)
    }

    private function startSalePack():void {
        if (!g.user.salePack && g.userTimer.saleTimerToEnd > 0 && (g.managerSalePack.dataSale.timeToStart  - int(new Date().getTime() / 1000)) <= 0) {

        }
    }

    public function sartAfterSaleTimer():void {
        if (g.userTimer.saleTimerToStart <=0) {

        }
    }
}
}
