database = GitoriousMuninPlugins::Database.new
config = database.gitorious_config
Directories = {
  "cache_dir" => config["archive_cache_dir"],
  "working_dir" => config["archive_work_dir"],
  "repo_root" => config["repository_base_path"]
}
def disk_usage(key)
  dir = Directories[key]
  command = "du -sb #{dir} 2>/dev/null"
  result = `#{command}`.split(/\s+/).first
end

cmd = ARGV.shift
case cmd
when "autoconf"
  puts "no"
when "config"
  puts "graph_title Disk usage"
  puts "graph_args -l 0"
  puts "graph_vlabel Disk usage"
  puts "graph_category Gitorious"

  # Cache dir
  puts "cache.label Repo cache"
  puts "cache.draw LINE2"
  puts "cache.type GAUGE"

  # Work dir
  puts "work.label Repo work"
  puts "work.draw LINE2"
  puts "work.type GAUGE"

  # Root dir
  puts "root.label Repo storage"
  puts "root.draw LINE2"
  puts "root.type GAUGE"
else
  puts "cache.value #{disk_usage('cache_dir')}"
  puts "work.value #{disk_usage('working_dir')}"
  puts "root.value #{disk_usage('repo_root')}"
end
