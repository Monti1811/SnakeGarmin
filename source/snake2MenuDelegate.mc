import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class snake2MenuDelegate extends WatchUi.Menu2InputDelegate {

    var _parent as WatchUi.Menu2;

    function initialize(parent) {
        Menu2InputDelegate.initialize();
        _parent = parent;
    }

    //! Handle a menu item being selected
    //! @param menuItem The menu item selected
    public function onSelect(menuItem as MenuItem) as Void {
        var id = menuItem.getId() as String;
        if (id.equals("arena_size")) {
            // When the toggle menu item is selected, push a new menu that demonstrates
            // left and right toggles with automatic substring toggles.
            var Menu = new WatchUi.Menu2({:title=>"Arena Size" });
            Menu.addItem(new WatchUi.MenuItem("24x24", null, "24", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("18x18", null, "18", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("12x12", null, "12", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("8x8", null, "8", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("6x6", null, "6", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            WatchUi.pushView(Menu, new $.Menu2SampleSubMenuDelegate(_parent), WatchUi.SLIDE_UP);
        } else if (id.equals("game_speed")) {
            // When the toggle menu item is selected, push a new menu that demonstrates
            // left and right toggles with automatic substring toggles.
            var Menu = new WatchUi.Menu2({:title=>"Game Speed" });
            Menu.addItem(new WatchUi.MenuItem("0.5x", null, "2000", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("0.66x", null, "1500", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("1x", null, "1000", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("2x", null, "500", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("3x", null, "333", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            Menu.addItem(new WatchUi.MenuItem("4x", null, "250", {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            WatchUi.pushView(Menu, new $.Menu2SampleSubMenuDelegate(_parent), WatchUi.SLIDE_UP);
        } else if (id.equals("wall_death")) {
            var toogleMenuItem = menuItem as WatchUi.ToggleMenuItem;
            var wall_death = toogleMenuItem.isEnabled();
            Storage.setValue("wall_death", wall_death);
            _parent.getItem(2).setSubLabel(wall_death ? "Disabled" : "Enabled");
            WatchUi.requestUpdate();
        }

    }
}

//! This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SampleSubMenuDelegate extends WatchUi.Menu2InputDelegate {

    var _parent as WatchUi.Menu2;

    function initialize(parent) {
        Menu2InputDelegate.initialize();
        _parent = parent;
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        // For IconMenuItems, we will change to the next icon state.
        // This demonstrates a custom toggle operation using icons.
        // Static icons can also be used in this layout.
        var label = item.getLabel() as String;
        var val = item.getId() as String;
        switch (val) {
            case "24":
            case "18":
            case "12":
            case "8":
            case "6":
                setArenaSize(label);
                break;
            case "2000":
            case "1500":
            case "1000":
            case "500":
            case "250":
                setGameSpeed(label);
                break;
        }

        
        WatchUi.requestUpdate();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function setArenaSize(size as String) as Void {
        Storage.setValue("arena_size", size);
        _parent.getItem(0).setSubLabel(size);
    }

    function setGameSpeed(speed as String) as Void {
        Storage.setValue("game_speed", speed);
        _parent.getItem(1).setSubLabel(speed);
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the done item being selected
    public function onDone() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}