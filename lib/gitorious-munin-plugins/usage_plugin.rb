module GitoriousMuninPlugins
  class UsagePlugin
    def initialize(known_plugins)
      @known_plugins = known_plugins
    end

    def run
      global_options = Trollop::options do
        version "#{GitoriousMuninPlugins::VERSION} (c) 2012 Gitorious AS."
        banner <<-EOS
Munin plugins for Gitorious

Usage:
       gitorious-munin-plugins [options]
where [options] are:
EOS
        opt :status, "List install status of plugins"
        opt :install, "Install PACKAGE1 PACKAGE2"
        opt :uninstall, "Uninstall PACKAGE1 PACKAGE2 "
      end

      if global_options[:status_given]
        display_install_status
      elsif global_options[:install_given]
        install_plugins(ARGV)
      elsif global_options[:uninstall_given]
        uninstall_plugins(ARGV)
      end
    end

    def install_plugins(plugins)
      plugins.each do |p|
        if plugin = @known_plugins.detect {|_p| _p.named?(p)}
          plugin.install!
        else
          puts "Ignoring #{p}"
        end
      end
    end

    def uninstall_plugins(plugins)
      plugins.each do |p|
        if plugin = @known_plugins.detect {|_p| _p.named?(p)}
          plugin.uninstall!
        else
          puts "Ignoring #{p}"
        end
      end
    end

    def display_install_status
      msg = [Term::ANSIColor.bold { "These plugins are available"} ]
      @known_plugins.each do |p|
        msg << "- #{p.description}"
      end
      msg << ""

      fail_with_message(msg.join("\n"))
    end

    def fail_with_message(message)
      puts message
      exit 1
    end
  end
end
