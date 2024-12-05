import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class snake2GameOverDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onTap(tapEvent as ClickEvent) as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }


}