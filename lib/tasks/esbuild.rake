# lib/tasks/esbuild.rake
namespace :assets do
  task :compile do
    require 'esbuild/rails/task'

    ESBuild::Rails::Task.new do |t|
      t.entry_points = { 'application.js' => 'app/javascript/application.js' }
      t.outdir = 'public/packs'
      t.bundle = true
      t.minify = Rails.env.production?
    end
  end
end
