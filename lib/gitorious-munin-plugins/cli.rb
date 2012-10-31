module GitoriousMuninPlugins
  class Cli
    attr_reader :plugins, :called_as

    def initialize(plugins, called_as)
      @plugins = plugins
      @called_as = called_as
    end

    def run
      if plugins.any? {|plugin| plugin.named?(called_as)}
        load_plugin(called_as)
      else
        display_usage
      end
    end

    def display_usage
      msg = [Term::ANSIColor.bold { "Munin plugins for Gitorious, symlink to me in /etc/munin/plugins/"} ]
      msg << ""
      msg << "I may be called by these names:"
      plugins.each do |p|
        msg << "- #{p.description}"
      end
      msg << ""

      fail_with_message(msg.join("\n"))
    end

    def fail_with_message(message)
      puts message
      exit 1
    end

    def load_plugin(name)
      load Plugin.root.realpath + "#{name}.rb"
    end
  end
end
