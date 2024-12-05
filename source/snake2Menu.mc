import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Graphics;

class snake2Menu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title=>"Settings"});
    }

    function onLayout(dc as Dc) as Void {
        
    }

    function onUpdate(dc) {
        dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }

}