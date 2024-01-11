gtk_timer_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'timer.vala',
  'new-timer-dialog.vala'
]

gtk_timer_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('gee-0.8'),
  # dependency('gxml-0.16'),
]

gtk_timer_sources += gnome.compile_resources('gtk-timer-resources',
  'gtk-timer.gresource.xml',
  c_name: 'gtk_timer'
)

executable('gtk-timer', gtk_timer_sources,
  dependencies: gtk_timer_deps,
       install: true,
)
