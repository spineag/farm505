package com.vk {
import flash.events.Event;

/**
 * @author Andrew Rogozov
 */
public class CustomEvent extends Event {
    public static const CONN_INIT:String = 'onConnectionInit';
    public static const WINDOW_BLUR:String = 'onWindowBlur';
    public static const WINDOW_FOCUS:String = 'onWindowFocus';
    public static const APP_ADDED:String = 'onApplicationAdded';
    public static const WALL_SAVE:String = 'onWallPostSave';
    public static const WALL_CANCEL:String = 'onWallPostCancel';
    public static const PHOTO_SAVE:String = 'onProfilePhotoSave';
    public static const PHOTO_CANCEL:String = 'onProfilePhotoCancel';
    public static const BALANCE_CHANGED:String = 'onBalanceChanged';
    public static const ORDER_SUCCESS:String = 'onOrderSuccess';
    public static const ORDER_FAIL:String = 'onOrderFail';
    public static const ORDER_CANCEL:String = 'onOrderCancel';
    public static const SETTINGS_CHANGED:String = 'onSettingsChanged';
    public static const REQUEST_COMPLETE:String = 'onRequestSuccess';
    public static const REQUEST_CANCEL:String = 'onRequestCancel';
    public static const REQUEST_FAIL:String = 'onRequestFail';

    private var _data:Object = {};
    private var _params:Array = [];

    public function CustomEvent(eventtype:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(eventtype, bubbles, cancelable);
    }

    public function get data():Object {
        return _data;
    }

    public function set data(value:Object):void {
        _data = value;
    }

    public function get params():Array {
        return _params;
    }

    public function set params(value:Array):void {
        _params = value;
    }
}
}