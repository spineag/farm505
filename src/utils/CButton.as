/**
 * Created by user on 5/21/15.
 */
package utils {
import starling.display.Button;
import starling.textures.Texture;

public class CButton extends Button{

    public function CButton(upState:Texture,text:String = "",downState:Texture = null) {
        super (upState,text,downState);

    }
}
}
