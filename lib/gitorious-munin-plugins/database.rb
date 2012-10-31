module GitoriousMuninPlugins
  class Database
    def initialize
    end

    def configuration
      @configuration ||= load_configuration
    end

    def load_configuration
      begin
        gitorious_conf = File.read("/etc/gitorious.conf")
        dir = gitorious_conf.scan(/^GITORIOUS_HOME=(.*)$/).flatten.first
        raise NotFound, "/etc/gitorious.conf was found, but no GITORIOUS_HOME was defined" unless dir
        rails_env = gitorious_conf.scan(/^RAILS_ENV=(.*)$/).flatten.first || "production"
        database_yaml = Pathname(dir) + "config/database.yml"
        raise NotFound, "No database.yml found in #{database_yml}" unless database_yaml.exist?
        YAML::load_file(database_yaml)[rails_env]
      rescue Errno::ENOENT
        raise NotFound, "Gitorious configuration file /etc/gitorious.conf was not found, exiting"
      end
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
