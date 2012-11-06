config = GitoriousMuninPlugins::Config.new
home = config.gitorious_home
ProxyPid = home + "../run/git-proxy-1.pid"

def ps_output
if ProxyPid.exist?
  cmd = "ps ww `cat #{ProxyPid}` | egrep -v '(ps|PID)'"
  res = `#{cmd}`.strip
  if res =~ /\-\ (\d+)\/(\d+)\/(\d+)\ cur\/max\/tot\ conns$/
    curr, max, total = $1, $2, $3
    puts "curr.value #{curr}"
    puts "max.value #{max}"
    puts "total.value #{total}"
  end
else
  $stderr.puts "#{ProxyPid} not found"
end

end

case ARGV.shift
when "autoconf"
  puts "no"
when "config"
  puts "graph_title git-proxy activity"
  puts 'graph_args -l 0'
  puts 'graph_vlabel active connections'
  puts 'graph_category Gitorious'
  puts "curr.label Active connections"
  puts "curr.draw LINE2"
  puts "curr.type GAUGE"
  #    puts "max.label Max connections so far"
  #    puts "max.draw no"
  #    puts "total.label Total conncetions"
  #    puts "total.draw no"
else
  ps_output
end
