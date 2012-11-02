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
        opt :install, "Install PACKAGE1 PACKAGE2. Specify 'all' to install all plugins"
        opt :uninstall, "Uninstall PACKAGE1 PACKAGE2. Specify 'all' to uninstall all plugins "
      end

      if global_options[:status_given]
        display_install_status
      elsif global_options[:install_given]
        install_plugins(ARGV)
      elsif global_options[:uninstall_given]
        uninstall_plugins(ARGV)
      end
    end

    def install_plugins(plugin_spec)
      plugins = extract_plugins_from_spec(plugin_spec)
      plugins.each do |p|
        if plugin = @known_plugins.detect {|_p| _p.named?(p)}
          plugin.install!
        else
          puts "Ignoring #{p}"
        end
      end
    end

    def uninstall_plugins(plugin_spec)
      plugins = extract_plugins_from_spec(plugin_spec)
      plugins.each do |p|
        if plugin = @known_plugins.detect {|_p| _p.named?(p)}
          plugin.uninstall!
        else
          puts "Ignoring #{p}"
        end
      end
    end

    def extract_plugins_from_spec(spec)
      if spec.first == "all"
        @known_plugins.map(&:name)
      else
        return spec
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
