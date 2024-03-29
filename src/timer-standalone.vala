namespace Timer {

[GtkTemplate (ui = "/com/github/ashkanarabim/gtktimer/timer-standalone.ui")]
public class Standalone : Adw.NavigationPage {
    public Item? item {get; set;}
    public string target_hms {get; set; default = "??";}
    public string remaining_hms {get; set; default = "??";}
    private int _state;
    public int state {
        get {
            return this._state;
        }
        set {
            this._state = value;
            this.update_buttons(); // needed
        }
    }

    // elements
    [GtkChild]
    private unowned Gtk.Stack button_stack;
    [GtkChild]
    private unowned Gtk.Label ui_end_time;
    [GtkChild]
    private unowned Gtk.Label display;
    [GtkChild]
    private unowned GLib.BindingGroup binds;

    // constructors
    construct {
        // the reason these can be here is that binds isn't null. 
        // it's initialized and has a source (item) from XML
        this.binds.bind("remaining_hms", this, "remaining_hms", GLib.BindingFlags.SYNC_CREATE);
        this.binds.bind("target_hms", this, "target_hms", GLib.BindingFlags.SYNC_CREATE);
        this.binds.bind("state", this, "state", GLib.BindingFlags.SYNC_CREATE);
    }

    private void update_buttons () {
        if (this.state == Item.states.RUNNING) {
            this.button_stack.visible_child_name = "running_stack";
        } else if (this.state == Item.states.PAUSED) {
            this.button_stack.visible_child_name = "paused_stack";
        } else { // assume stopped
            this.button_stack.visible_child_name = "stopped_stack";
        }
    }

    // gtk callbacks
    [GtkCallback]
    private void on_start_clicked () {
        //  when the state changes buttons are updated automatically
        this.item.start();
    }
    [GtkCallback]
    private void on_pause_clicked () {
        this.item.pause();
    }
    [GtkCallback]
    private void on_reset_clicked () {
        this.item.reset();
    }
}

}
