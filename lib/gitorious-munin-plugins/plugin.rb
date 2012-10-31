module GitoriousMuninPlugins
  class Plugin
    def self.all
      root.children.collect do |plugin|
        name = plugin.basename.to_s.sub(/\.rb/, "")
        new(name)
      end
    end

    # Root of all plugins
    def self.root
      Pathname(File.dirname(__FILE__)) + "plugins"
    end

    attr_reader :name
    def initialize(name)
      @name = name
    end

    # Is there a symlink to us in /etc/munin/plugins ?
    def installed?
      File.exist?("/etc/munin/plugins/#{name}")
    end

    def install_status
      installed? ? "installed" : "not installed"
    end

    def named?(given)
      name == given
    end

    def description
      "#{name} [#{install_status}]"
    end
  end
end
