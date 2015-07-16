package server {
import com.junkbyte.console.Cc;
import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.net.NetConnection;
import flash.net.Responder;
import flash.utils.getTimer;
import manager.Vars;

public class Server extends EventDispatcher {
    public static const INQ_START:String = 'data_start';
    public static const INQ_DATA_QUEST:String = 'data_active_quest';
    public static const INQ_BUILD_BUILDING:String = 'buy';
    public static const INQ_SALE_BUILDING:String = 'sale';
    public static const INQ_UPDATE_POSITION_BUILDING:String = 'update_position_building';
    public static const INQ_WATERING_TREE:String = 'watering_tree';
    public static const INQ_HARVEST_TREE:String = 'harvest_tree';

    public static const COMMAND_GAME:String = 'Game.execute';
    public static const COMMAND_START:String = 'Start.execute';
    public static const COMMAND_PLOT:String = 'Plot.execute';
    public static const COMMAND_GIFT:String = 'Gift.execute';
    public static const COMMAND_BUY_SPECIAL:String = 'Buy_spec.execute';
    public static const COMMAND_BUILDING:String = 'Building.execute';
    public static const COMMAND_LEVEL_UP:String = 'LevelUp.execute';

    public static const ERROR_OPEN_IN_OTHER_WINDOW:uint = 999;
    public static const ERROR_TRY_HACKED:uint = 666;

    private var _nc:NetConnection;
    private var _resp:Responder;
    private var _queue:Array;
    private var _timeError:int;
    private var _countSendRequest:uint;

    private var _callbacks:Object;

    private var _gameVersion:int = 0;

    protected var g:Vars = Vars.getInstance();

    public function Server() {
        _countSendRequest = 0;
        _queue = [];
        _nc = new NetConnection();
        _nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
        _resp = new Responder(onResult, onError);
        _callbacks = {};

        g.gameDispatcher.addEnterFrame(render);
    }

    public function inquiry(command:String, method:String, parameters:Object = null, data:Array = null, xp:uint = 0, callback:Function = null, ...callbackParams/*hero:BirdWorking = null*/):void {
        var callbackKey:String;
        var time:uint = getTimer();
        _queue.push({command: command, method: method, parameters: parameters, data: data, time: time, xp: xp});

        if (Boolean(callback)) {
            callbackKey = method + "_" + String(parameters[1]) + "_" + String(time);
            _callbacks[callbackKey] = {callback: callback, callbackParams: callbackParams};
        }

        if (_queue.length == 1) {
            call(command, method, parameters);
        }
    }

    private function call(command:String, method:String, parameters:Object = null):void {
//        var userData:Object;
//
//        Cc.ch("server", "Request - " + command + "::" + method, 7);
//        if (method != INQ_START) {
//            Cc.obj("server", parameters, "Parameters:", 5);
//        }
//
//        _timeError = getTimer();
//        _countSendRequest++;
//        _nc.connect(g.socialNetwork.serverPath + "gateway.php");
//
//        if (command == COMMAND_START) {
//            userData = g.socialNetwork.getUserParams();
//            _nc.call(command, _resp, g.currentUser.uid, userData, method, parameters);
//        } else {
//            _nc.call(command, _resp, g.currentUser.uid, g.session_key, method, parameters, {});
//        }
    }

    private function onError(e:Object):void {
//        Cc.errorObject(e, "Server error:");
//
//        g.plugins.sendActivity("warning", "connection_error");
//
//        g.woBreak.errorMessage = '*';
//        g.woBreak.handler.show(Main.stageS);
    }

    private function onResult(e:Object):void {
//        var obj:Object;
//        var tObj:Object;
//        var error:String;
//        var version:int;
//        var errCode:int;
//        var time:uint;
//        var s:String = "";
//        var callbackKey:String;
//        var callback:Function;
//
//        if (!e) {
//            return;
//        }
//
//        try {
//            obj = _queue[0];
//            s = obj.method as String;
//            time = obj.time;
//
//            _countSendRequest--;
//
//            Cc.ch("server", "Answer - " + s + ", ping: " + (getTimer() - time) + "ms", 8);
//            if (s != INQ_START && s != INQ_DATA_FOR_VISIT && s != INQ_DATA_CITY && s != INQ_DATA_HOME && s != INQ_DATA_MAP && s != INQ_DATA_QUEST) {
//                Cc.obj("server", e, "Parameters:");
//            }
//
//            error = e.error;
//            version = (e.version || _gameVersion);
//
//            if (error && (error != "0")) {
//                Cc.error('BirdsServer:: error message: ' + error);
//                errCode = int(error.substring(0, 3));
//                if (errCode == ERROR_OPEN_IN_OTHER_WINDOW) {
//                    g.woUpdate.caption = g.language.duplicatedWindow.caption;
//                    g.woUpdate.captionInfo = g.language.duplicatedWindow.captionInfo;
//                    g.woUpdate.handler.init();
//                    return;
//                }
//                if (errCode == ERROR_TRY_HACKED) {
//                    g.woBreak.type = WOBreak.TYPE_HACK;
//                    g.woBreak.handler.init();
//                    return;
//                }
//
//                g.plugins.sendActivity("error", "code: " + String(errCode), {uids: g.currentUser.uid, idObj: errCode});
//                JRAnalytics.sendError(String(errCode), "Regular error event");
//
//                g.woBreak.type = WOBreak.TYPE_SERVER;
//                g.woBreak.errorMessage = String(errCode);
//                g.woBreak.handler.init();
//
//                return;
//            }
//            _queue.shift();
//            EnergyRender.needSync = false;
//
//            if (s == INQ_START) {
//                _gameVersion = version;
//            } else if (version != _gameVersion) {
//                g.woUpdate.caption = g.language.updateWindow.caption;
//                g.woUpdate.captionInfo = g.language.updateWindow.captionInfo;
//                g.woUpdate.handler.init();
//                return;
//            }
//
//            var oldKey:String;
//            if (_queue.length > 0) {
//                tObj = _queue[0];
//                callbackKey = tObj.method + "_" + String(tObj.parameters[1]) + "_" + String(tObj.time);
//                tObj.time = getTimer();
//                if (_callbacks[callbackKey]) {
//                    oldKey = callbackKey;
//                    callbackKey = tObj.method + "_" + String(tObj.parameters[1]) + "_" + String(tObj.time);
//                    _callbacks[callbackKey] = _callbacks[oldKey];
//                    delete _callbacks[oldKey];
//                }
//                call(tObj.command, tObj.method, tObj.parameters);
//            }
//
//            try{
//                callbackKey = s + "_" + String(obj.parameters[1]) + "_" + String(obj.time);
//                if (_callbacks[callbackKey]) {
//                    callback = _callbacks[callbackKey].callback;
//                    if (_callbacks[callbackKey].callbackParams[0] && _callbacks[callbackKey].callbackParams[0] is BirdWorking) {
//                        var hero:BirdWorking = _callbacks[callbackKey].callbackParams[0];
//                        g.actionRender.force(hero.hintAction);
//                    }
//
//                    callback.apply(null, _callbacks[callbackKey].callbackParams);
//                    delete _callbacks[callbackKey];
//                    callback = null;
//                }
//            }catch (err:Error) {
//                Cc.warn("obj.parameters", obj.parameters);
//                Cc.warn("callbackKey", callbackKey);
//                Cc.warn("callbackParams", _callbacks[callbackKey].callbackParams);
//                Cc.warn("callback", callback);
//                Cc.errorObject(e, "Error #" + err.errorID + " in preparing data for processing response from server. Got data into method " + s + ":");
//                g.plugins.sendActivity("warning", "crash_response_callback");
//                JRAnalytics.sendError("try-catch", "Crash callback method at server response");
//            }
//        } catch (err:Error) {
//            Cc.errorObject(e, "Error #" + err.errorID + " in preparing data for processing response from server. Got data into method " + s + ":");
//            g.plugins.sendActivity("warning", "crash_response_callback");
//            JRAnalytics.sendError("try-catch", "Crash callback method at server response");
//        }
//        try {
//            if (s == INQ_START) {
//                BirdsServerEventer.start(e);
//                JRAnalytics.sendLoading("data_start_end");
//                g.server.inquiry(COMMAND_QUEST, INQ_DATA_QUEST, [g.currentUser.uid]);
//                if (Main.snID == Main.SN_DRAUGIEM_ID && g.flashVars.hasOwnProperty('ref') && int(g.flashVars['ref']) == 1) {
//                    g.server.inquiry(COMMAND_DRAUGIEM_GIFT, INQ_DRAUGIEM_TAKE_GIFT, [g.currentUser.userId]);
//                }
//            } else if (s == INQ_DATA_QUEST) {
//                BirdsServerEventer.initDataQuest(e.data);
//                JRAnalytics.sendLoading("data_quest_end");
//            } else if (s == INQ_BUILD_BUILDING) {
//                BirdsServerEventer.build_building(e, obj.data);
//            } else if (s == INQ_WATERING_TREE) {
//                BirdsServerEventer.watering_tree(e, obj.data);
//            } else if (s == INQ_HARVEST_TREE) {
//                BirdsServerEventer.harvest_tree(e, obj.data);
//            } else if (s == INQ_COLLECTION_BUILDING) {
//                BirdsServerEventer.collection_building(e, obj.data);
//            } else if (s == INQ_NEW_PLOT) {
//                BirdsServerEventer.new_plot(e, obj.data);
//            } else if (s == INQ_PLOT_SEED) {
//                BirdsServerEventer.plot_seed(e, obj.data);
//            } else if (s == INQ_PLOT_CLEAR) {
//                BirdsServerEventer.plot_clear(e, obj.data);
//            } else if (s == INQ_PLOT_HARVEST) {
//                BirdsServerEventer.plot_harvest(e, obj.data);
//            } else if (s == INQ_CLEAR_TRASH) {
//                BirdsServerEventer.clear_trash(e, obj.data);
//            } else if (s == INQ_REMOVE_PLANT) {
//                BirdsServerEventer.remove_plant(e, obj.data);
//            } else if (s == INQ_DATA_FOR_VISIT) {
//                BirdsServerEventer.data_for_visit(e);
//            } else if (s == INQ_DATA_CITY_FRIEND) {
//                BirdsServerEventer.city_friend_visit(e);
//            } else if (s == INQ_QUEST_OK) {
//                BirdsServerEventer.quest_ok(e);
//            } else if (s == INQ_OPEN_SURPRISE) {
//                BirdsServerEventer.open_surprise(e);
//            } else if (s == INQ_NEW_LEVEL) {
//                BirdsServerEventer.new_level(e);
//            } else if (s == INQ_DATA_HOME) {
//                BirdsServerEventer.data_home(e);
//            } else if (s == INQ_PAYMENT) {
//                BirdsServerEventer.payment(e);
//            } else if (s == INQ_USE_GIFT) {
//                BirdsServerEventer.use_gift(e, obj.data);
//            } else if (s == INQ_COLLECTION_BACK_BUILDING) {
//                BirdsServerEventer.collection_back_building(e, obj.data);
//            } else if (s == INQ_OPEN_BACK_BRIDGE) {
//                BirdsServerEventer.open_back_bridge(e);
//            } else if (s == INQ_DATA_MAP) {
//                BirdsServerEventer.data_map(e, obj.data);
//            } else if (s == INQ_DATA_CITY) {
//                BirdsServerEventer.data_city(e, obj.data);
//            } else if (s == INQ_OPEN_AREA) {
//                BirdsServerEventer.open_area(e, obj.data);
//            } else if (s == INQ_UPLOAD_RESOURCE_BUILDING) {
//                BirdsServerEventer.upload_resource_building(obj.data);
//            } else if (s == INQ_UPLOAD_CRAFTING) {
//                BirdsServerEventer.upload_crafting(obj.data);
//            } else if (s == INQ_QUEST_SKIP) {
//                BirdsServerEventer.quest_ok(e);
//            } else if (s == INQ_JOIN_GROUP) {
//                BirdsServerEventer.join_group(e.data);
//            } else if (s == INQ_GET_URL) {
//                BirdsServerEventer.get_url(e.data);
//            } else if (s == INQ_CHECK_IN_GAME) {
//                BirdsServerEventer.check_in_game(e.data);
//            } else if (s == INQ_COUNT_ENERGY) {
//                BirdsServerEventer.count_energy(e.data);
//            } else if (s == INQ_DRAUGIEM_TAKE_GIFT) {
//                BirdsServerEventer.take_gift(e);
//            } else if (s == INQ_OPEN_GIFT) {
//                BirdsServerEventer.get_gift(e.data);
//            } else if (s == INQ_REMOVE_ONECLICK) {
//                BirdsServerEventer.one_click_building(e, obj.data);
//            } else if (s == INQ_TASK_COMPLETE) {
//                BirdsServerEventer.task_complete(e.data);
//            } else if (s == INQ_AB_TESTING) {
//                BirdsServerEventer.get_ab_test(e.data);
//            }
//        } catch (err:Error) {
//            Cc.errorObject(e, "Error #" + err.errorID + " in processing response from server. Got data into method " + s + ":");
//            g.plugins.sendActivity("warning", "crash_bad_data");
//            JRAnalytics.sendError("try-catch", "Receive bad data from server");
//        }
    }

    private function render():void {
//        if (!_countSendRequest) {
//            return;
//        }
//        if ((getTimer() - _timeError) > 60000) {
//            g.plugins.sendActivity("warning", "connection_timeout");
//
//            g.woBreak.type = WOBreak.TYPE_SERVER;
//            g.woBreak.handler.init();
//            _countSendRequest = 0;
//        }
    }

    private function netStatus(e:NetStatusEvent):void {
//        var info:Object;
//        var msg:String;
//        var request:Object;
//
//        info = e.info;
//        if (info && info.level && info.level == "error") {
//            switch (info.description) {
//                case "HTTP: Status 503":
//                    msg = info.description + " - Too many loadings file.";
//                    break;
//                default :
//                    msg = info.description + " - Connection with server lost! Last request was critical.";
//            }
//            Cc.error("BirdsServer::", msg);
//            request = _queue.shift();
//            g.plugins.sendActivity("warning", "connection_fail", {label1: "method: " + (request.method || "")});
//
//            g.woBreak.type = WOBreak.TYPE_SERVER;
//            g.woBreak.handler.init();
//            _countSendRequest = 0;
//        }
    }
}
}
