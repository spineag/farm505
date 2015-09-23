/**
 * Created by user on 9/23/15.
 */
package heroes {
import manager.Vars;

import utils.CSprite;

public class BasicCat {
    public static const MAN:int = 1;
    public static const WOMAN:int = 2;

    protected var _posX:int;
    protected var _posY:int;
    protected var _source:CSprite;
    protected var g:Vars = Vars.getInstance();

    public function BasicCat() {

    }

    public function setToFreeCell():void {

    }
}
}
