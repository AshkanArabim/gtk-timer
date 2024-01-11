namespace GtkTimer{

[GtkTemplate (ui="/com/github/ashkanarabim/gtktimer/new-timer-dialog.ui")]
public class NewTimerDialog : Adw.Window{
    // states
    private int hours = 0;
    private int minutes = 0;
    private int seconds = 0;

    // elements
    [GtkChild]
    private unowned Gtk.SpinButton h_spinbutton;
    [GtkChild]
    private unowned Gtk.SpinButton m_spinbutton;
    [GtkChild]
    private unowned Gtk.SpinButton s_spinbutton;
    [GtkChild]
    private unowned Gtk.Button add_btn;
    [GtkChild]
    private unowned Gtk.Entry name_entry;

    // constructors
    public NewTimerDialog() {
        this.h_spinbutton.input.connect(() => parse_hours ());
        this.m_spinbutton.input.connect(() => parse_minutes ());
        this.s_spinbutton.input.connect(() => parse_seconds ());
    }

    // logic
    private int parse_hours() {
        this.h_spinbutton.value = int.parse(this.h_spinbutton.get_text());
        this.hours = (int) this.h_spinbutton.value;
        //  message("hours updated");
        //  message("h_spinbutton other value: %d".printf((int) this.h_spinbutton.value));
        //  message("h_spinbutton text: %s".printf(this.h_spinbutton.get_text()));
        //  message("h_spinbutton get chars: %s".printf(this.h_spinbutton.get_chars()));
        //  message("hours: %s".printf(this.hours.to_string()));
        check_tiemr_validity();
        return 0;
    }
    private int parse_minutes() {
        this.m_spinbutton.value = int.parse(this.m_spinbutton.get_text());
        this.minutes = (int) this.m_spinbutton.value;
        check_tiemr_validity();
        return 0;
    }
    private int parse_seconds() {
        this.s_spinbutton.value = int.parse(this.s_spinbutton.get_text());
        this.seconds = (int) this.s_spinbutton.value;
        check_tiemr_validity();
        return 0;
    }

    private void check_tiemr_validity() {
        // DEBUG: vv
        //  message("hours: %d".printf(this.hours));
        //  message("minutes: %d".printf(this.minutes));
        //  message("seconds: %d".printf(this.seconds));
        if (
            this.hours != 0 ||
            this.minutes != 0 ||
            this.seconds != 0
        ) {
            add_btn.sensitive = true;
        } else {
            add_btn.sensitive = false;
        }
    }

    [GtkCallback]
    private void on_cancel_clicked() {
        this.close();
    }

    [GtkCallback]
    private void on_submit_clicked () {
        // guaranteed that valid timer can be made
        Timer newtimer = new Timer.from_hms (
            this.hours,
            this.minutes,
            this.seconds,
            this.name_entry.buffer.text
        );
        done (newtimer);
        this.close();
    }

    // signals
    public signal void done (Timer r);
}

}