module GitoriousMuninPlugins
  class Config
    GITORIOUS_CONF_PATH = "/etc/gitorious.conf"

    def gitorious_config
      yaml_file = fetch("GITORIOUS_HOME")
      gitorious_yml = Pathname(fetch("GITORIOUS_HOME")) + "config/gitorious.yml"
      YAML::load_file(gitorious_yml)[fetch("RAILS_ENV")]
    end

    def rails_env
      @rails_env ||= fetch("RAILS_ENV", "production")
    end

    def database_yaml
      dir = fetch("GITORIOUS_HOME")
      database_yaml = Pathname(dir) + "config/database.yml"
      raise NotFound, "No database.yml found in #{database_yml}" unless database_yaml.exist?
      database_yaml
    end

    # Fetch line matching #{key}= in /etc/gitorious.conf
    def fetch(key, default_value=nil)

      begin
        config_file = File.read(GITORIOUS_CONF_PATH)
      rescue Errno::ENOENT
        abort "Gitorious configuration file #{GITORIOUS_CONF_PATH} was not found, exiting"
      end

      result = config_file.scan(/^#{key}=(.*)$/).flatten.first
      if result
        result
      elsif default_value
        default_value
      end
    end
  end
end
