module GitoriousMuninPlugins
  class Plugin
    def self.all
      root.children.collect do |plugin|
        if plugin.basename.to_s.split(".").last == "rb"
          name = plugin.basename.to_s.sub(/\.rb/, "")
          new(name)
        end
      end.compact
    end

    # Root of all plugins
    def self.root
      Pathname(File.dirname(__FILE__)) + "plugins"
    end

    # The binary, used as a target for Munin symlinks
    def binary
      Pathname(Gem.bindir) + "gitorious-munin-plugin"
    end

    # Where the symlink should be placed
    def target
      Pathname("/etc/munin/plugins/#{name}")
    end

    def install!
      if target.exist?
        puts "#{target} exists, ignoring"
      else
        puts "Installing #{target}"
        target.make_symlink(binary)
      end
    end

    def uninstall!
      if target.exist?
        puts "Deleting #{target}"
        target.delete
      else
        puts "#{target} exists"
      end
    end

    attr_reader :name
    def initialize(name)
      @name = name
    end

    # Is there a symlink to us in /etc/munin/plugins ?
    def installed?
      File.exist?("/etc/munin/plugins/#{name}")
    end

    def named?(given)
      name == given
    end

    def install_status
      if installed?
        Term::ANSIColor.green {"(installed)"}
      else
        Term::ANSIColor.red {"(not installed)"}
      end
    end

    def description
      "#{name} #{install_status}"
    end
  end
end
