/**
 * Created by user on 11/28/16.
 */
package tutorial.newTuts {
import manager.Vars;

public class TutorialTextsNew {
    private var _objText:Object;
    private var g:Vars = Vars.getInstance();

    public function TutorialTextsNew() {
        _objText = {};
        _objText['next'] = String(g.managerLanguage.allTexts[541]);
        _objText['ok'] = String(g.managerLanguage.allTexts[532]);

        _objText[2] = {};
        _objText[2][0] = String(g.managerLanguage.allTexts[542]);

        _objText[4] = {};
        _objText[4][0] = String(g.managerLanguage.allTexts[543]);

        _objText[6] = {};
        _objText[6][0] = String(g.managerLanguage.allTexts[544]);

        _objText[7] = {};
        _objText[7][0] = String(g.managerLanguage.allTexts[545]);

        _objText[9] = {};
        _objText[9][0] = String(g.managerLanguage.allTexts[546]);

        _objText[11] = {};
        _objText[11][0] = String(g.managerLanguage.allTexts[547]);

        _objText[12] = {};
        _objText[12][0] = String(g.managerLanguage.allTexts[548]);

        _objText[15] = {};
        _objText[15][0] = String(g.managerLanguage.allTexts[549]);

        _objText[16] = {};
        _objText[16][0] = String(g.managerLanguage.allTexts[550]);
    }

    public function get objText():Object { return _objText }
}
}
