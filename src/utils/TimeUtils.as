package utils {
import manager.Vars;

public class TimeUtils {
    protected static var g:Vars = Vars.getInstance();

//    public static function convertSecondsToString(seconds:uint, d:Boolean, h:Boolean, m:Boolean, s:Boolean):String {
//        var day:uint = seconds / 86400;
//        var hour:uint = (seconds - day * 86400) / 3600;
//        var minutes:uint = (seconds - day * 86400 - hour * 3600) / 60;
//        var sec:uint = (seconds - day * 86400 - hour * 3600 - minutes * 60);
//        var strCaption:String = '';
//
//        if (d && day > 0) {
//            strCaption = day + ' ' + g.language.formatTime.day;
//
//            if (h) {
//                strCaption += ' ' + hour + ' ' + g.language.formatTime.hour;
//            }
//            if (m) {
//                strCaption += ' ' + minutes + ' ' + g.language.formatTime.minutes;
//            }
//            /*if (s) {
//             strCaption += ' ' + sec + ' ' + g.language.formatTime.second;
//             }*/
//        }
//        else if (h && hour > 0) {
//            strCaption = hour + ' ' + g.language.formatTime.hour;
//
//            if (m) {
//                strCaption += ' ' + minutes + ' ' + g.language.formatTime.minutes;
//            }
//            if (s) {
//                strCaption += ' ' + sec + ' ' + g.language.formatTime.second;
//            }
//        }
//        else if (m && minutes > 0) {
//            strCaption = minutes + ' ' + g.language.formatTime.minutes;
//
//            if (s) {
//                strCaption += ' ' + sec + ' ' + g.language.formatTime.second;
//            }
//        }
//        else if (s && sec > 0) {
//            strCaption = sec + ' ' + g.language.formatTime.second;
//        }
//
//        return strCaption;
//    }

//    public static function convertSecondsToStringMaterialsWindow(seconds:uint):String {
//        var day:uint = seconds / 86400;
//        var hour:uint = (seconds - day * 86400) / 3600;
//        var minutes:uint = (seconds - day * 86400 - hour * 3600) / 60;
//        var sec:uint = (seconds - day * 86400 - hour * 3600 - minutes * 60);
//        var strCaption:String = '';
//
//        if (day > 0) {
//            strCaption = day + ' ' + g.language.formatTime.day;
//        }
//        if (hour > 0) {
//            strCaption += hour + ' ' + g.language.formatTime.hour;
//        }
//        if (minutes > 0) {
//            strCaption += minutes + ' ' + g.language.formatTime.minutes;
//        }
//
//        return strCaption;
//    }

//    public static function convertSecondsToStringHintShop(seconds:uint):String {
//        var hour:uint = seconds / 3600;
//        var minutes:uint = (seconds - hour * 3600) / 60;
//        var strCaption:String = '';
//
//        if (hour > 0) {
//            strCaption += hour + ' ' + g.language.formatTime.hour;
//            if (minutes > 0) {
//                strCaption += ' ' + minutes + ' ' + g.language.formatTime.minutes;
//            }
//        }
//        else if (minutes > 0) {
//            strCaption += minutes + ' ' + g.language.formatTime.minutes;
//        }
//
//        return strCaption;
//    }

    public static function convertSecondsToStringClassic(seconds:uint):String {
        var day:uint = seconds / 86400;
        var hour:uint = (seconds - day * 86400) / 3600;
        var minutes:uint = (seconds - day * 86400 - hour * 3600) / 60;
        var sec:uint = (seconds - day * 86400 - hour * 3600 - minutes * 60);
        var strCaption:String;
        strCaption = day > 0 ? format(day) + ":" : "";
        strCaption += day > 0 || hour > 0 ? format(hour) + ":" : "";
        strCaption += day > 0 || hour > 0 || minutes > 0 ? format(minutes) + ":" : "";
        strCaption += format(sec);

        return strCaption;
    }

//    public static function convertSecondsToStringNewsIcon(seconds:uint):String {
//        var day:uint = seconds / 86400;
//        var hour:uint = (seconds - day * 86400) / 3600;
//        var minutes:uint = (seconds - day * 86400 - hour * 3600) / 60;
//        var sec:uint = (seconds - day * 86400 - hour * 3600 - minutes * 60);
//        var strCaption:String;
//
//        if (day > 0) {
//            strCaption = day + ' ' + g.language.formatTime.day;
//        } else {
//            strCaption = hour > 0 ? format(hour) + ":" : "";
//            strCaption += hour > 0 || minutes > 0 ? format(minutes) + ":" : "";
//            strCaption += format(sec);
//        }
//
//        return strCaption;
//    }

//    public static function convertSecondsToStringEnergy(seconds:uint):String {
//        var minutes:uint = seconds / 60;
//        var sec:uint = seconds - minutes * 60;
//        var strCaption:String = String(minutes) + ':' + format(sec);
//
//        return strCaption;
//    }

    private static function format(value:uint):String {
        var result:String = String(value);
        result = value < 10 ? "0" + result : result;

        return result;
    }

//    public static function stringToAge(str:String):uint {
//        var arr:Array /*of String*/;
//        var year:uint = new Date().getFullYear();
//        if (!str || !str.length) {
//            return 0;
//        }
//        arr = str.split(".");
//        for (var i:int = 0; i < arr.length; i++) {
//            if (arr[i].length == 4) {
//                return year - arr[i];
//            }
//        }
//        return 0;
//    }
}
}