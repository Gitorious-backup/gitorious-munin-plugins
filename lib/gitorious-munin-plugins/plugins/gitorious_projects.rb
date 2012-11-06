database = GitoriousMuninPlugins::Database.new
cmd = ARGV.shift
case cmd
  when "autoconf"
    puts "no"
  when "config"
    puts "graph_title New Projects (within last 24 hrs)"
    puts 'graph_args -l 0'
    puts 'graph_vlabel Projects'
    puts 'graph_category Gitorious'
    puts "new.label Projects"
    puts "new.draw LINE2"
    puts "new.type GAUGE"
  else
    database.select("select count(*) as count from projects where created_at >= date_sub(now(), interval 24 hour)").each_hash do |row|
      puts "new.value #{row['count'].to_i}"
    end
end
