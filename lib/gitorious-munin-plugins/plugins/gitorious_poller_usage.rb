# Display memory usage in the poller process
config = GitoriousMuninPlugins::Config.new

Pid = config.gitorious_home + "tmp/pids/poller0.pid"

case ARGV.shift
when "autoconf"
  puts "no"
when "config"
  puts "graph_title Poller memory usage"
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
