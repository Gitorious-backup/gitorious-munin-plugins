module GitoriousMuninPlugins
  class Database
    def initialize
    end

    def configuration
      @configuration ||= load_configuration
    end

    def load_configuration
      begin
        dir = gitorious_conf("GITORIOUS_HOME")
        rails_env = gitorious_conf("RAILS_ENV") || "production"
        database_yaml = Pathname(dir) + "config/database.yml"
        raise NotFound, "No database.yml found in #{database_yml}" unless database_yaml.exist?
        YAML::load_file(database_yaml)[rails_env]
      rescue Errno::ENOENT
        raise NotFound, "Gitorious configuration file /etc/gitorious.conf was not found, exiting"
      end
    end

    def gitorious_config
      yaml_file = gitorious_conf("GITORIOUS_HOME")
      gitorious_yml = Pathname(gitorious_conf("GITORIOUS_HOME")) + "config/gitorious.yml"
      YAML::load_file(gitorious_yml)[gitorious_conf("RAILS_ENV")]
    end

    # Fetch line matching #{key}= in /etc/gitorious.conf
    def gitorious_conf(key)
      config_file = File.read("/etc/gitorious.conf")
      config_file.scan(/^#{key}=(.*)$/).flatten.first
    end

    def select(sql)
      begin
        conn = Mysql.new(configuration["host"], configuration["username"], configuration["password"], configuration["database"])
        conn.query(sql)
      ensure
        conn.close
      end
    end

    class NotFound < StandardError; end
  end
end
