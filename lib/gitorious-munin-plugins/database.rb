module GitoriousMuninPlugins
  class Database
    def initialize
      @config = Config.new
    end

    def database_configuration
      @database_configuration ||= load_database_configuration
    end

    def load_database_configuration
      begin
        YAML::load_file(@config.database_yaml)[@config.rails_env]
      rescue Errno::ENOENT
        raise NotFound, "Gitorious configuration file /etc/gitorious.conf was not found, exiting"
      end
    end

    def database_connection
        @database_connection ||= Mysql.new(database_configuration["host"],
                         database_configuration["username"],
                         database_configuration["password"],
                         database_configuration["database"])
    end

    def select(sql)
      begin
        conn = database_connection
        conn.query(sql)
      ensure
        conn.close
      end
    end

    class NotFound < StandardError; end
  end
end
