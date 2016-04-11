
namespace :git do
  # rake git:push
  desc "push a ahead commits of all git repos"
  task :push do
    threads = []
    Dir.chdir(Dir.home) do
      Dir['Documents/**/.git/', '.dotfiles/'].each do |git_repo|
        git_repo.sub!(/\/?\.git\/?\z/, '')
        git_repo = '.' if git_repo.empty?

        threads << Thread.new(git_repo) do |git_repo|
          push_commits(git_repo)
        end
      end
    end
    threads.each(&:join)
    success("All your repos is up-to-date.")
  end

  # rake git:fetch
  desc "fetch commits of all gir repos"
  task :fetch do
    threads = []
    Dir.chdir(Dir.home) do
      Dir['Documents/**/.git/', '.dotfiles/'].each do |git_repo|
        git_repo.sub!(/\/?\.git\/?\z/, '')
        git_repo = '.' if git_repo.empty?

        threads << Thread.new(git_repo) do |git_repo|
          fetch_commits(git_repo)
        end
      end
    end
    threads.each(&:join)
    success("All your repos is up-to-date.")
  end
end



def success(message)
  puts " \033[32m✔ \033[m#{message}"
end

def error(message)
  puts " \033[31m✘ \033[m#{message}"
end

# git push
# git push origin master
#
# if repo is ahead from remote, push the ahead commits.
def push_commits(git_repo)
  status = `cd #{git_repo} && git status`
  if status.match(/^Your branch is ahead of/)
    origin = 'origin'
    master = 'master'
    branches = `cd "#{git_repo}" && git branch -vv`
    # if upstream exists, shows like this:
    #   * master 6aecb18 [origin/master] commit message
    # or
    #   * master 1514fb2 [origin/master: ahead 1] commit message
    if m = branches.match(/\[([-\w]+)\/([-\w]+)(?:\]|:)/)
      # extract the upstream remote and branch name
      origin = m[1]
      master = m[2]
    end
    command = "cd #{git_repo} && git push #{origin} #{master}"
    puts "> #{command}"
    Kernel.system(command) unless (ENV['DRYRUN'] || ENV['dryrun']) == 'true'
    success("#{git_repo}")
  end
end

# git fetch
#
# fetch commits from remote.
def fetch_commits(git_repo)
  command = "cd #{git_repo} && git fetch"
  puts "> #{command}"
  return if (ENV['DRYRUN'] || ENV['dryrun']) == 'true'
  result = Kernel.system(command)
  if result
    success("#{git_repo}")
  else
    error("#{git_repo}")
  end
end
