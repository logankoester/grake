module Grake
  class Rakefile
    attr_accessor :fname, :tasks

    def initialize(fname = 'Rakefile')
      if File.exists? fname
        @fname = fname
      else
        rakefile_chooser
      end
      parse
    end

    def parse(fname = @fname)
      @tasks = TaskTree.new(fname)

      lines = `(cd #{File.dirname(fname)}; rake -T)`.split("\n")
      lines.shift
      raise "No tasks in this file" if lines.size < 1

      lines.each do |t|
        # "rake foo:bar:baz" => ["foo","bar","baz"]
        namespace = t.match(/rake (\w|:)+/)[0].scan(/\w+/)[1..-1]
        description = t.match(/.*# (.+)/)[1]
        task = @tasks.add_task namespace, description
        task.content.rake_line = t
      end

    end

    def rakefile_chooser
      label = Gtk::Label.new "No Rakefile found in #{Dir.pwd}"
      button = Gtk::Button.new("Choose one...")

      window = Gtk::Window.new
      window.border_width = 10
      window.title = "#{APP_NAME} says..."

      box = Gtk::VBox.new(false, 0)
      window.add(box)

      box.pack_start(label, true, true, 0)
      box.pack_start(button, true, true, 0)

      button.signal_connect("clicked") do
        dialog = Gtk::FileChooserDialog.new("Open File",
          window,
          Gtk::FileChooser::ACTION_OPEN,
          nil,
          [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])
        if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
          @fname = dialog.filename
          dialog.destroy
          Gtk.main_quit
        end
      end
      window.signal_connect("destroy") { Gtk.main_quit }
      window.show_all
      Gtk.main
    end

  end
end
