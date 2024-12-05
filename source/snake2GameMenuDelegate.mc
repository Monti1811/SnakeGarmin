import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class snake2GameMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();

    }

    //! Handle a menu item being selected
    //! @param menuItem The menu item selected
    public function onMenuItem(item as Symbol) as Void {
        if (item == :quit) {
            WatchUi.popView(WatchUi.SLIDE_UP);
        } else if (item == :dismiss) {
            
        }
    }
}
