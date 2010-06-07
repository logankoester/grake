require 'tree'
require 'libglade2'
require 'yaml'
require 'ftools'

@@path = File.expand_path(File.dirname(__FILE__))
$:.unshift @@path unless $:.include?(@@path)

require 'grake/rakefile.rb'
require 'grake/tasktree.rb'

class GrakeWindow
  include GetText

  attr_accessor :glade, :tasks

  def initialize(tasks, domain = nil, localedir = nil, flag = GladeXML::FILE)
    @tasks = tasks
    bindtextdomain(domain, localedir, nil, "UTF-8")
    @glade = GladeXML.new(glade_file, nil, domain, localedir, flag) {|handler| method(handler)}
    @glade['grake_window'].signal_connect("destroy") { Gtk.main_quit }

    @rake_buttonbox1 = @glade['rake_buttonbox1']
    @rake_buttonbox2 = @glade['rake_buttonbox2']
    @statusbar = @glade['statusbar']
    add_task_buttons(@tasks.children)
  end
  
  def add_task_buttons(tasks)
    pos = 1
    tasks.each do |task|
      task.content.button = Gtk::Button.new(task.name)
      task.content.button.show

      # Display the tooltip
      if task.content.description
        task.content.button.signal_connect "enter" do
          task.content.statusbar_context_id = @statusbar.get_context_id("Task description")
          task.content.statusbar_message_id = @statusbar.push(task.content.statusbar_context_id, task.content.description)
        end

        task.content.button.signal_connect "leave" do
          @statusbar.remove(task.content.statusbar_context_id, task.content.statusbar_message_id)
        end
      end

      # Open a subwindow or perform a task
      task.content.button.signal_connect "clicked" do
        if task.children.empty?
          rake_exec(task)
        else
          spawn_window(task)
          add_task_buttons(task.children)
        end
      end

      if pos >= tasks.size / 2
        @rake_buttonbox1.add( task.content.button)
      else
        @rake_buttonbox2.add( task.content.button)
      end
      pos += 1
    end
  end

  def spawn_window(task)
    GrakeChildWindow.new(task, nil, task.name)
    Gtk.main
  end

  def rake_exec(task)
    rake = task.content.rake_line.match(/(rake (\w|:)+)\s/)[0]
    cmd = "cd #{PROJECT_PATH}; #{rake}; read"
    `#{preferences['terminal_emulator'].strip} "#{cmd}"`
  end

  def glade_file
    "#{@@path}/../glade/grake_window.glade"
  end

  def preferences
    @preferences ||= load_preferences(PREFS_FNAME)
  end

  def load_preferences(fname)
    unless File.exists?(fname)
      File.install('default_preferences.yml', fname, nil, true)
    end
    YAML.load(File.read(fname))
  end
  
end

class GrakeChildWindow < GrakeWindow
end

class GrakeRootWindow < GrakeWindow
  def initialize(tasks, domain = nil, localedir = nil, flag = GladeXML::FILE)
    super

    @glade['grake_window'].title  = "#{PROG_NAME}: #{Dir.pwd}"

    @prefs_term = @glade['prefs_term']
    @prefs_shape_wide = @glade['prefs_shape_wide']
    @prefs_shape_tall = @glade['prefs_shape_tall']
    @prefs_save = @glade['prefs_save']

    # Load values
    @prefs_term.text = preferences['terminal_emulator']
    if preferences['window_shape'] == 0
      @prefs_shape_wide.set_active(true)
    else
      @prefs_shape_tall.set_active(true)
    end

    # Save values
    @prefs_save.signal_connect("clicked") do
      prefs = {}
      prefs['terminal_emulator'] = @prefs_term.text
      prefs['window_shape'] = @prefs_shape_tall.active? ? 1 : 0
      File.open(PREFS_FNAME, 'w') { |f| f << prefs.to_yaml }
    end

  end

  def glade_file
    if preferences['window_shape'] == 0
      "#{@@path}/../glade/grake_root_window_wide.glade"
    else
      "#{@@path}/../glade/grake_root_window_tall.glade"
    end
  end
end
