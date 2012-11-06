module GitoriousMuninPlugins
  class Config
    GITORIOUS_CONF_PATH = "/etc/gitorious.conf"

    def gitorious_config
      yaml_file = fetch("GITORIOUS_HOME")
      gitorious_yml = gitorious_home + "config/gitorious.yml"
      YAML::load_file(gitorious_yml)[rails_env]
    end

    def rails_env
      @rails_env ||= fetch("RAILS_ENV", "production")
    end

    def gitorious_home
      path = fetch("GITORIOUS_HOME")
      Pathname(path)
    end

    def database_yaml
      database_yaml = gitorious_home + "config/database.yml"
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
