# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'run tests'
task :spec do
  sh 'ruby spec/repo_spec.rb'
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  CODE = 'lib/'

  desc 'run all quality checks'
  task all: [:rubocop, :flog, :reek]

  task :rubocop do
    sh 'rubocop'
  end

  task :flog do
    sh "flog #{CODE}"
  end

  task :reek do
    sh "reek #{CODE}"
  end
end
