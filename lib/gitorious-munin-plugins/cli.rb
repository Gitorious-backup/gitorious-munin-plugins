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
        UsagePlugin.new(plugins).run
      end
    end


    def load_plugin(name)
      load Plugin.root.realpath + "#{name}.rb"
    end
  end

end
