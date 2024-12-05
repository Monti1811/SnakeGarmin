import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class snake2GameDelegate extends WatchUi.BehaviorDelegate {
    private var _parentView as snake2GameView;

    function initialize(view as snake2GameView) {
        BehaviorDelegate.initialize();
        _parentView = view;
    }

    function onSwipe(swipeEvent as SwipeEvent) as Boolean {
        _parentView.MoveDirection(swipeEvent.getDirection());
        return true;
    }

    function onBack() as Boolean {
        return false;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        //showConfirmation();
        if (keyEvent.getKey() == WatchUi.KEY_ESC) {
            showConfirmation();
            return true;
        }
        return true;
    }

    function showConfirmation() {
        var message = "Quit?";
        var dialog = new WatchUi.Confirmation(message);
        WatchUi.pushView(
            dialog,
            new snake2ConfirmationDelegate(),
            WatchUi.SLIDE_IMMEDIATE
        );
    }


}

//! Input handler for the confirmation dialog
class snake2ConfirmationDelegate extends WatchUi.ConfirmationDelegate {


    //! Constructor
    //! @param view The app view
    public function initialize() {
        ConfirmationDelegate.initialize();
    }

    //! Handle a confirmation selection
    //! @param value The confirmation value
    //! @return true if handled, false otherwise
    public function onResponse(value as Confirm) as Boolean {
        if (value == WatchUi.CONFIRM_YES) {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        return true;
    }
}