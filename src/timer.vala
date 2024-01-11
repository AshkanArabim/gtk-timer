namespace GtkTimer {

[GtkTemplate (ui = "/com/github/ashkanarabim/gtktimer/timer.ui")]
public class Timer : Gtk.ListBoxRow{
    // states
    private int original_len; // 10 mins default
    private int length;
    private int64 target = 0;
    private int remaining = 0;
    private string timer_name = "";
    private enum states {
        RUNNING,
        PAUSED,
        STOPPED
    }
    private int state = states.STOPPED;
    public int index = -1;

    //  [GtkChild]
    //  private unowned Gtk.Button start_button;
    //  [GtkChild]
    //  private unowned Gtk.Button stop_button;
    //  [GtkChild]
    //  private unowned Gtk.Button pause_button;
    [GtkChild]
    private unowned Gtk.Label display;
    [GtkChild]
    private unowned Gtk.Stack start_pause_stack;
    [GtkChild]
    private unowned Gtk.Stack reset_stack;
    [GtkChild]
    private unowned Gtk.Label name_label;

    public Timer (int s, string name = "") {
        this.original_len = s;
        this.length = s;
        this.update_display(s);
        this.set_timer_name(name);
        this.update_buttons();
    }

    public Timer.from_hms (int h, int m, int s, string name = "") {
        this(h * 3600 + m * 60 + s, name);
    }

    public void set_timer_name (string name) {
        this.timer_name = name;
        this.name_label.set_text(name);
        this.name_label.visible = (name.length > 0);
    }

    // UI logic
    private void update_display (int s) {
        int h = s / 3600;
        int m = (s / 60) % 60; 
        s = s % 60;
        display.set_text("%02i:%02i:%02i".printf(h, m, s));
    }

    private void update_buttons() {
        if (this.state == states.RUNNING) {
            this.start_pause_stack.visible_child_name = "pause_stackpage";
            this.reset_stack.visible_child_name = "show_reset_stack";
        } else if (this.state == states.PAUSED) {
            this.start_pause_stack.visible_child_name = "start_stackpage";
            this.reset_stack.visible_child_name = "show_reset_stack";
        } else { // if stopped
            this.start_pause_stack.visible_child_name = "start_stackpage";
            this.reset_stack.visible_child_name = "hide_reset_stack";
        }
    }

    [GtkCallback]
    private void on_start_clicked() {
        this.start();
    }
    [GtkCallback]
    private void on_reset_clicked() {
        this.reset();
    }
    [GtkCallback]
    private void on_pause_clicked() {
        this.pause();
    }
    [GtkCallback]
    private void on_delete_clicked() {
        this.@delete();
    }

    // internal logic
    private void start() { 
        this.target = new GLib.DateTime.now_local().to_unix() + this.length;
        this.state = states.RUNNING;
        int? last_remaining = null;
        this.update_buttons();
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

            return (this.state == states.RUNNING);
        });
    }

    private void stop() {
        this.state = states.STOPPED;
        this.update_buttons();
    }

    private void pause() {
        // edge case: what if already paused?
        if (this.state != states.RUNNING) {return;}
        
        // edge case: what if already past this time?
        int64 now = new GLib.DateTime.now_local().to_unix();
        if (this.target <= now) {return;}

        this.state = states.PAUSED;
        this.length = (int) (target - now);
        this.update_buttons();
    }

    private void reset() {
        stop();
        this.length = this.original_len;
        update_display(this.original_len);
    }

    private void @delete() {
        this.deleted(this.index);
    }

    // signals
    public signal void deleted(int idx);
}

}