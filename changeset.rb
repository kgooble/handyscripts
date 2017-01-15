#! /usr/bin/env ruby

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: changeset.rb --author='Your Name' -n10 -x='-' [base-branch-eg-master]"

  opts.on('-nNUMBER', '--number=NUMBER', 'Number of commits to get') do |n|
    options[:number] = n
  end

  opts.on('-aAUTHOR', '--author=AUTHOR', 'The author of the commits') do |a|
    options[:author] = a
  end

  opts.on('-xBULLET', '--bullet=BULLET', 'The type of bullet to use') do |b|
    options[:bullet] = b
  end

  opts.on('-bBRANCH', '--branch=BRANCH', 'The branch to get logs against') do |b|
    options[:branch] = b
  end
end.parse!

options[:number] = 10 unless options.key?(:number)
options[:author] = `git config --get user.name` unless options.key?(:author)
options[:bullet] = '-' unless options.key?(:bullet)
options[:branch] = if ARGV.size > 0
                     ARGV[0]
                   else
                     'master'
                   end

my_logs = `git log --format="- %h %s" --no-merges -n#{options[:number]} --author='#{options[:author]}' #{options[:branch]}..`

my_logs = my_logs.split("\n").reverse

my_logs.each do |log|
  puts log
end
