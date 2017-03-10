/**
 * Created by user on 3/7/16.
 */
package tutorial {
import manager.Vars;

public class TutorialTexts {
    private var _objText:Object;
    private var g:Vars = Vars.getInstance();

    public function TutorialTexts() {
        _objText = {};
        _objText['next'] = String(g.managerLanguage.allTexts[541]);
        _objText['ok'] = String(g.managerLanguage.allTexts[532]);
        _objText['lookAround'] = String(g.managerLanguage.allTexts[488]);

        _objText[1] = {};
        _objText[1][1] = String(g.managerLanguage.allTexts[551]);
        _objText[1][2] = String(g.managerLanguage.allTexts[552]);
        _objText[1][3] = String(g.managerLanguage.allTexts[553]);
        _objText[1][4] = String(g.managerLanguage.allTexts[554]);

        _objText[2] = {};
        _objText[2][0] = String(g.managerLanguage.allTexts[555]);
        _objText[2][1] = String(g.managerLanguage.allTexts[556]);

        _objText[3] = {};
        _objText[3][1] = String(g.managerLanguage.allTexts[557]);

        _objText[4] = {};
        _objText[4][0] = String(g.managerLanguage.allTexts[558]);
        _objText[4][5] = String(g.managerLanguage.allTexts[559]);

        _objText[5] = {};
        _objText[5][1] = String(g.managerLanguage.allTexts[560]);
        _objText[5][3] = String(g.managerLanguage.allTexts[561]);
        _objText[5][6] = String(g.managerLanguage.allTexts[562]);

        _objText[6] = {};
        _objText[6][0] = String(g.managerLanguage.allTexts[563]);

        _objText[7] = {};
        _objText[7][0] = String(g.managerLanguage.allTexts[564]);
        _objText[7][5] = String(g.managerLanguage.allTexts[565]);

        _objText[8] = {};
        _objText[8][0] = String(g.managerLanguage.allTexts[566]);
        _objText[8][5] = String(g.managerLanguage.allTexts[567]);

        _objText[9] = {};
        _objText[9][0] = String(g.managerLanguage.allTexts[568]);

        _objText[10] = {};
        _objText[10][1] = String(g.managerLanguage.allTexts[569]);

        _objText[11] = {};
        _objText[11][1] = String(g.managerLanguage.allTexts[570]);

        _objText[12] = {};
        _objText[12][1] = String(g.managerLanguage.allTexts[571]);
        _objText[12][2] = String(g.managerLanguage.allTexts[572]);
        _objText[12][8] = String(g.managerLanguage.allTexts[573]);
        _objText[12][9] = String(g.managerLanguage.allTexts[574]);

        _objText[13] = {};
        _objText[13][0] = String(g.managerLanguage.allTexts[575]);

        _objText[14] = {};
        _objText[14][1] = String(g.managerLanguage.allTexts[576]);

        _objText[15] = {};
        _objText[15][0] = String(g.managerLanguage.allTexts[577]);

        _objText[16] = {};
        _objText[16][1] = String(g.managerLanguage.allTexts[578]);

        _objText[17] = {};
        _objText[17][1] = String(g.managerLanguage.allTexts[579]);

        _objText[18] = {};
        _objText[18][0] = String(g.managerLanguage.allTexts[580]);

        _objText[19] = {};
        _objText[19][0] = String(g.managerLanguage.allTexts[581]);

        _objText[20] = {};
        _objText[20][0] = String(g.managerLanguage.allTexts[582]);

        _objText[21] = {};
        _objText[21][0] = String(g.managerLanguage.allTexts[583]);

        _objText[22] = {};
        _objText[22][1] = String(g.managerLanguage.allTexts[584]);

        _objText[23] = {};
        _objText[23][0] = String(g.managerLanguage.allTexts[585]);

        _objText[24] = {};
        _objText[24][0] = String(g.managerLanguage.allTexts[586]);
        _objText[24][3] = String(g.managerLanguage.allTexts[587]);
        _objText[24][6] = String(g.managerLanguage.allTexts[588]);
        _objText[24][7] = String(g.managerLanguage.allTexts[589]);
        _objText[24][8] = String(g.managerLanguage.allTexts[590]);

        _objText[25] = {};
        _objText[25][0] = String(g.managerLanguage.allTexts[591]);

        _objText[26] = {};
        _objText[26][1] = String(g.managerLanguage.allTexts[592]);
    }

    public function get objText():Object { return _objText }
}
}
