import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.Application.Storage;

class snake2GameView extends WatchUi.View {

    // Arena
    private const start_x as Number = 60;
    private const start_y as Number = 60;

    private var size_block as Number = 10;
    private var size_block_fill as Number = 9;
    private var size_x as Number = 24;
    private var size_y as Number = 24;
    private var arena_array as Array<Number>;

    private var wall_death as Boolean = false;

    // Timer for game loop
    private var _timer as Timer.Timer;
    private var timer_base_step as Number = 1000;
    private var timer_step as Number = 1000;
    private var speed_up as Boolean = true;

    // Snake
    private var snake_length as Number = 3;
    private var snake_body as Array<[Number, Number]> = new [size_x * size_y];
    private var current_points as Number = 0;
    private var eating_block as [Number, Number] = [0, 0];

    // Movement
    private var has_moved as Boolean = false;
    private var last_direction as Number = 3;
    private var timer_run as Boolean = false;

    function initialize() {
        View.initialize();
  
        // Initialize settings
        wall_death = Storage.getValue("wall_death") as Boolean;

        var arena_size = Storage.getValue("arena_size") as String;
        size_x = arena_size.toNumber();
        size_y = size_x;
        size_block = 240 / size_x;
        size_block_fill = size_block - 1;

        var game_speed = Storage.getValue("game_speed") as String;
        var time_temp = game_speed.toFloat();
        time_temp = 1000 / time_temp;
        timer_step = time_temp.toNumber();
        timer_base_step = timer_step;

        speed_up = Storage.getValue("speed_up") as Boolean;


        // Initialize game
        _timer = new Timer.Timer();
        arena_array = new Array<Number>[size_x * size_y];

        for (var i = 0; i < size_x; i++) {
            for (var j = 0; j < size_y; j++) {
                arena_array[i + j * size_x] = 0;
            }
        }

        // Create starting Snake
        for (var i = 0; i < snake_length; i++) {
            var pos = PosToIndex(size_x/2 + i, size_y/2);
            arena_array[pos] = 1;
            snake_body[i] = [size_x/2 + i, size_y/2];
        }

        AddEatingBlock();
        System.println("Game initialized");
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.GameLayout(dc));
        System.println("Game layout loaded");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _timer.start(method(:onTimer), timer_step, true);
        System.println("Game shown");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.clear();
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        if (!has_moved && timer_run) {
            // Move snake
            MoveDirection(last_direction);
            timer_run = false;
            if (speed_up) {
                // Update timer step
                var new_time = CalcTimerStep();
                if (new_time != timer_step) {
                    timer_step = new_time;
                    _timer.stop();
                    _timer.start(method(:onTimer), timer_step, true);
                }
            }
        }

        // Reset variables
        has_moved = false;
        timer_run = false;
        
        DrawEatingBlock(dc, eating_block[0], eating_block[1]);
        DrawSnake(dc);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(240, 310, Graphics.FONT_TINY, current_points, Graphics.TEXT_JUSTIFY_CENTER);

        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        _timer.stop();
    }

    function CalcTimerStep() as Number {
        // Calculate timer step based on current points
        if (current_points > 90) {
            return 100;
        } else {
            return timer_base_step - current_points * 10;
        }
    }

    function DrawEatingBlock(dc as Dc, x as Number, y as Number) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(start_x + x  * size_block, start_y + y * size_block, size_block_fill, size_block_fill);
    }

    function DrawSnakeBlock(dc as Dc, x as Number, y as Number) as Void {
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(start_x + x  * size_block, start_y + y * size_block, size_block_fill, size_block_fill);
    }

    function DrawSnake(dc as Dc) as Void {
        for (var i = 0; i < snake_length; i++) {
            DrawSnakeBlock(dc, snake_body[i][0], snake_body[i][1]);
        }
    }

    function AddEatingBlock() {
        // Add random eating block
        while (snake_length < size_x * size_y) {
            var sb_ = Math.rand() % (size_x * size_y);
            if (arena_array[sb_] == 0) {
                eating_block = [sb_ % size_x, sb_ / size_x];
                arena_array[sb_] = 2;
                break;
            }
        }
    }

    function MoveDirection(direction as Number) as Boolean {
        if (has_moved) {
            return false;
        }
        has_moved = true;

        var new_head;
        var new_head_index ;
        var new_head_pos;
        var new_head_x ;
        var new_head_y;

        // Calculate new head position
        new_head = snake_body[0];
        new_head_x = new_head[0];
        new_head_y = new_head[1];

        // Up
        if (direction == WatchUi.SWIPE_UP && last_direction != WatchUi.SWIPE_DOWN) {
            new_head_y -= 1;
        // Right
        } else if (direction == WatchUi.SWIPE_RIGHT && last_direction != WatchUi.SWIPE_LEFT) {
            new_head_x += 1;
        // Down
        } else if (direction == WatchUi.SWIPE_DOWN && last_direction != WatchUi.SWIPE_UP) {
            new_head_y += 1;
        // Left
        } else if (direction == WatchUi.SWIPE_LEFT && last_direction != WatchUi.SWIPE_RIGHT) {
            new_head_x -= 1;
        } else {
            return false;
        }


        if (wall_death) {
            // Check if new head position is outside the arena
            if (new_head_x < 0 || new_head_x >= size_x || new_head_y < 0 || new_head_y >= size_y) {
                // Game over
                GameOver();
                return false;
            }
        } else {
            // Wrap around the edges
            if (new_head_x < 0) {
                new_head_x = size_x - 1;
            } else if (new_head_x >= size_x) {
                new_head_x = 0;
            }

            if (new_head_y < 0) {
                new_head_y = size_y - 1;
            } else if (new_head_y >= size_y) {
                new_head_y = 0;
            }
        }
        

        new_head_pos = [new_head_x, new_head_y];
        new_head_index = PosToIndex(new_head_x, new_head_y);

        if (arena_array[new_head_index] == 1) {
            // Game over
            GameOver();
            return false;
        }

        var last_snake_block = snake_body[snake_length - 1];

        MoveSnake(new_head_pos);

        // Check if new head position is eating block
        if (new_head_pos[0] == eating_block[0] && new_head_pos[1] == eating_block[1]) {
            // Eating block
            snake_length += 1;
            current_points += 1;
            AddSnakeBlock(last_snake_block);
            AddEatingBlock();
        } 
        // Set value of head only after eating block check
        last_direction = direction;
        return true;
        
    }

    function AddSnakeBlock(last_snake_block as [Number, Number]) as Void {
        snake_body[snake_length - 1] = last_snake_block;
        arena_array[PosToIndex(last_snake_block[0], last_snake_block[1])] = 0;
    }

    function MoveSnake(new_head_pos as [Number, Number]) as Void {
        // Remove tail
        var snake_tail = snake_body[snake_length - 1];
        arena_array[PosToIndex(snake_tail[0], snake_tail[1])] = 0;
        // Move body
        for (var i = snake_length - 1; i > 0; i--) {
            snake_body[i] = snake_body[i - 1];
        }
        arena_array[PosToIndex(new_head_pos[0], new_head_pos[1])] = 1;
        snake_body[0] = new_head_pos;
        // PrintArena(0);
    }

    function GameOver() as Void {
        // Game over
        _timer.stop();
        var gameOverView = new $.snake2GameOverView(current_points);
        WatchUi.switchToView(gameOverView, new $.snake2GameOverDelegate(), WatchUi.SLIDE_UP);
    }

    // Function to print out the arena array
    (:debug) function PrintArena(counter as Number) as Void {
        System.println("Arena at time: " + counter);
        for (var j = 0; j < size_y; j++) {
            var row = "";
            for (var i = 0; i < size_x; i++) {
                row += arena_array[PosToIndex(i, j)] + " ";
            }
            System.println(row);
        }
    }

    //! Timer callback
    public function onTimer() as Void {
        //Kick the display update
        timer_run = true;
        WatchUi.requestUpdate();
    }

    function PosToIndex(x as Number, y as Number) as Number {
        return x + y * size_x;
    }

    function IndexToPos(index as Number) as [Number, Number] {
        return [index % size_x, index / size_x];
    }

}
