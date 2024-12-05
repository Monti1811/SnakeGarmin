import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;

class snake2Delegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();


        // Initialize empty settings
        var size = Storage.getValue("arena_size") as String;
        if (size == null || size == "") {
            size = "18x18";
            Storage.setValue("arena_size", size);
        }
        var speed = Storage.getValue("game_speed") as String;
        if (speed == null || speed == "") {
            speed = "1x";
            Storage.setValue("game_speed", speed);
        }
        var wall_death = Storage.getValue("wall_death") as Boolean;
        if (wall_death == null) {
            wall_death = false;
            Storage.setValue("wall_death", wall_death);
        }
    }

    function onHold(clickEvent) as Boolean {
        //WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        var mainView = new $.snake2GameView();
        var viewDelegate = new $.snake2GameDelegate(mainView);
        WatchUi.pushView(mainView, viewDelegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
        
    }

    public function onMenu() as Boolean {
        var menu = new $.snake2Menu();

        var size = Storage.getValue("arena_size") as String;
        menu.addItem(new WatchUi.MenuItem("Arena Size", size, "arena_size", null));

        var speed = Storage.getValue("game_speed") as String;
        menu.addItem(new WatchUi.MenuItem("Game Speed", speed, "game_speed", null));

        var wall_death = Storage.getValue("wall_death") as Boolean;
        menu.addItem(new WatchUi.ToggleMenuItem("Walls", {:enabled=>"Walls mean Game Over", :disabled=>"Can crawl through walls"}, "wall_death", wall_death, null));



        WatchUi.pushView(menu, new $.snake2MenuDelegate(menu), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }



}