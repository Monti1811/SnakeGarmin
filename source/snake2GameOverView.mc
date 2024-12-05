import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Lang;

class snake2GameOverView extends WatchUi.View {

    private var _total_points as Number;

    function initialize(total_points as Number) {
        View.initialize();
        _total_points = total_points;
        var max_points = Storage.getValue("snake2_max_points") as Number;
        if (max_points == null || max_points < _total_points) {
            Storage.setValue("snake2_max_points", _total_points);
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.GameOverLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var total_points = "" + _total_points;
        dc.drawText(180, 290, Graphics.FONT_TINY, total_points, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
