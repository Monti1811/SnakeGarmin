import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class snake2App extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        Math.srand(Time.now().value());
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new $.snake2View(), new $.snake2Delegate() ];
    }

}

function getApp() as snake2App {
    return Application.getApp() as snake2App;
}