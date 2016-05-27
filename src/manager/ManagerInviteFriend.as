/**
 * Created by user on 5/26/16.
 */
package manager {
public class ManagerInviteFriend {
    private var g:Vars = Vars.getInstance();

    public function ManagerInviteFriend() {
    }

    public function create():void {
        g.socialNetwork.showInviteWindow();

    }
}
}
