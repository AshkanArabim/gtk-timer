namespace GtkTimer {

[GtkTemplate (ui = "/com/github/ashkanarabim/gtktimer/row.ui")]
public class Row : Gtk.ListBoxRow{
    // states
    private int original_len; // 10 mins default
    private int length;
    private int64 target = 0;
    private int remaining = 0;
    private bool running = false;

    public Row (int s) {
        //  Object(
        //      original_len: s,
        //      length: s
        //  );

        this.original_len = s;
        this.length = s;
    }

    public Row.from_hms (int h, int m, int s) {
        this(h * 3600 + m * 60 + s);
    }

    [GtkChild]
    private unowned Gtk.Label display;
    //  [GtkChild]
    //  private unowned Gtk.Button start_button;
    //  [GtkChild]
    //  private unowned Gtk.Button stop_button;
    //  [GtkChild]
    //  private unowned Gtk.Button pause_button;

    // UI logic
    private void update_display (int s) {
        int h = s / 3600;
        int m = (s / 60) % 60; 
        s = s % 60;
        display.set_text("%02i:%02i:%02i".printf(h, m, s));
    }

    [GtkCallback]
    private void on_start_clicked() {
        start();
    }
    [GtkCallback]
    private void on_reset_clicked() {
        reset();
    }
    [GtkCallback]
    private void on_pause_clicked() {
        pause();
    }

    // internal logic
    private void start() { 
        this.target = new GLib.DateTime.now_local().to_unix() + this.length;
        this.running = true;
        int? last_remaining = null;
        GLib.Timeout.add(100, () => {
            int64 now = new GLib.DateTime.now_local().to_unix();
            this.remaining = (int) (this.target - now);

            if (last_remaining == null || last_remaining != this.remaining) {
                update_display(this.remaining);
                last_remaining = this.remaining;
            }

            if (this.remaining <= 0) {
                reset();
            }

            return this.running;
        });
    }

    private void stop() {
        this.running = false;
    }

    private void pause() {
        // edge case: what if already paused?
        if (!this.running) {return;}
        
        // edge case: what if already past this time?
        int64 now = new GLib.DateTime.now_local().to_unix();
        if (this.target <= now) {return;}

        this.running = false;
        this.length = (int) (target - now);
    }

    private void reset() {
        stop();
        this.length = this.original_len;
        update_display(this.original_len);
    }
}

}