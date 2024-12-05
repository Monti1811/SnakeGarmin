import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;

class snake2Delegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();


        // Initialize empty settings
        initSetting("arena_size", "18x18", String);
        initSetting("game_speed", "1x", String);
        initSetting("wall_death", false, Boolean);
        initSetting("speed_up", true, Boolean);
    }

    function initSetting(name, default_value, type) {
        if (type == String) {
            var value = Storage.getValue(name) as String;
            if (value == null || value == "") {
                value = default_value;
                Storage.setValue(name, value);
            }
        } else if (type == Boolean) {
            var value = Storage.getValue(name) as Boolean;
            if (value == null) {
                value = default_value;
                Storage.setValue(name, value);
            }
        } else if (type == Number) {
            var value = Storage.getValue(name) as Number;
            if (value == null) {
                value = default_value;
                Storage.setValue(name, value);
            }
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

        var speed_up = Storage.getValue("speed_up") as Boolean;
        menu.addItem(new WatchUi.ToggleMenuItem("Speed Up", {:enabled=>"Speed up after eating", :disabled=>"No speed up"}, "speed_up", speed_up, null));

        WatchUi.pushView(menu, new $.snake2MenuDelegate(menu), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }



}