module GitoriousMuninPlugins
  class MemoryGauge
    def by_pid(pidfile)
      if pidfile.exist?
        pid = pidfile.read.chomp
        command = "ps -p #{pid} -o vsize | grep '[0-9]'"
        result = `#{command}`
      end
    end
  end
end
