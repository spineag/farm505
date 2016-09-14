/**
 * Created by andy on 9/14/16.
 */
package server {
import manager.Vars;

public class ManagerPendingRequest {
    private var g:Vars = Vars.getInstance();
    private var _isActive:Boolean;
    private var _tempResourceIds:Array;

    public function ManagerPendingRequest() {
        _isActive = false;
        _tempResourceIds = [];
    }

    public function get isActive():Boolean { return _isActive; }
    public function activateIt():void { _isActive = true; }
    
    public function disActivateIt():void {
        _isActive = false;
        for (var i:int=0; i<_tempResourceIds.length; i++) {
            g.directServer.addUserResource(_tempResourceIds[i], g.userInventory.getCountResourceById(_tempResourceIds[i]), null);
        }
        _tempResourceIds.length = 0;
    }

    public function updateResource(id:int):void {
        if (_tempResourceIds.indexOf(id) < 0) _tempResourceIds.push(id);
    }

}
}
