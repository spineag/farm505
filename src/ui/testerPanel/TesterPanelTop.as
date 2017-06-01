/**
 * Created by andy on 6/1/17.
 */
package ui.testerPanel {
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CTextField;

public class TesterPanelTop {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _txt:CTextField;

    public function TesterPanelTop() {
        _source = new Sprite();
        _source.touchable = false;
        _txt =  new CTextField(120, 38, '');
        _txt.setFormat(CTextField.BOLD24, 24, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        _source.addChild(_txt);
        _source.x = 190;
        _source.y = 15;
        g.cont.interfaceCont.addChild(_source);
        updateText();
    }

    public function updateText():void {
        if (g.user.isTester) {
            _txt.text = 'Tester';
            _source.visible = true;
        } else if (g.user.isMegaTester) {
            _txt.text = 'MegaTester';
            _source.visible = true;
        } else {
            _txt.text = '';
            _source.visible = false;
        }
    }
}
}
