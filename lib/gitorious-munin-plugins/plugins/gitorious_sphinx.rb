# Display memory usage in the sphinx daemon
config = GitoriousMuninPlugins::Config.new
env = config.rails_env
Pid = config.gitorious_home + "log/searchd.#{env}.pid"

case ARGV.shift
when "autoconf"
  puts "no"
when "config"
  puts "graph_title Sphinx daemon memory usage"
  puts "graph_args -l 0"
  puts "graph_vlabel Memory usage"
  puts "graph_category Gitorious"
  puts "curr.label vsize"
  puts "curr.warning 524288" # 512M
  puts "curr.critical 1048576" # 1G
else
  usage = GitoriousMuninPlugins::MemoryGauge.new.by_pid(Pid)
  if usage
    puts usage
  end
end
