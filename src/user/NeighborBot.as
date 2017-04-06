/**
 * Created by andy on 10/13/15.
 */
package user {
import manager.Vars;

public class NeighborBot extends Someone{
    private var g:Vars = Vars.getInstance();

    public function NeighborBot() {
        userSocialId = '1';
        name = String(g.managerLanguage.allTexts[987]);
        lastName = '';
        photo = 'neighbor';
    }
}
}
