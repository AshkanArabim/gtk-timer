namespace Timer {

[GtkTemplate (ui = "/com/github/ashkanarabim/gtktimer/item.ui")]
public class Item : Gtk.ListBoxRow{
    // states
    public int original_len; // 10 mins default
    public int length;
    private string _timer_name = "";
    public string timer_name {
        get{
            return this._timer_name;
        } 
        set {
            this._timer_name = value;
            this.name_label.set_text(value);
            this.name_label.visible = (value.length > 0);
        }
    }
    public int64 target = 0;
    public int remaining = 0;
    public string remaining_hms {get; set; default = "--:--:--";}
    public string target_hms {get; set; default = "--:--:--";}
    public enum states {
        RUNNING,
        PAUSED,
        STOPPED
    }
    public int state {get; set; default = states.STOPPED;}
    public int index = -1;
    [GtkChild]
    private unowned Gtk.Label display;
    [GtkChild]
    private unowned Gtk.Stack start_pause_stack;
    [GtkChild]
    private unowned Gtk.Stack reset_stack;
    [GtkChild]
    private unowned Gtk.Label name_label;

    public Item (int s, string name = "") {
        this.original_len = s;
        this.length = s;
        this.update_display(s);
        this.name = name;
        this.update_buttons();
    }

    public Item.from_hms (int h, int m, int s, string name = "") {
        this(h * 3600 + m * 60 + s, name);
    }

    // getters / setters
    public int get_length_seconds () {
        return this.original_len;
    }

    // UI logic
    private void update_display (int s) {
        this.update_remaining_hms(s);
        display.set_text(this.remaining_hms);
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
    [GtkCallback]
    private void on_edit_clicked() {
        this.edit();
    }
    [GtkCallback]
    private void on_fullscreen_clicked() {
        this.show_standalone();
    }

    // internal logic
    public void update_remaining_hms(int seconds) {
        int h = seconds / 3600;
        int m = (seconds / 60) % 60; 
        int s = seconds % 60;
        this.remaining_hms = "%02i:%02i:%02i".printf(h, m, s);
    }

    public void update_target_hms(GLib.DateTime? dt = null) {
        if (dt == null) {
            this.target_hms = "--:--:--";
            return;
        }
        //  this.target_hms = dt.format("hh:mm:ss");
        this.target_hms = "%02i:%02i:%02i".printf(
            dt.get_hour(),
            dt.get_minute(),
            dt.get_second()
        );
    }

    public void start() { 
        GLib.DateTime dt = new GLib.DateTime.now_local();
        this.target = dt.to_unix() + this.length;
        update_target_hms(dt);

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

    public void pause() {
        // edge case: what if already paused?
        if (this.state != states.RUNNING) {return;}
        
        // edge case: what if already past this time?
        int64 now = new GLib.DateTime.now_local().to_unix();
        if (this.target <= now) {return;}

        this.update_target_hms();
        this.state = states.PAUSED;
        this.length = (int) (target - now);
        this.update_buttons();
    }

    public void reset() {
        this.update_target_hms();
        this.length = this.original_len;
        update_display(this.original_len);
        this.state = states.STOPPED;
        this.update_buttons();
    }

    private void @delete() {
        this.deleted(this.index);
    }

    // signals
    public signal void deleted(int idx);
    public signal void edit();
    public signal void show_standalone();
}

}