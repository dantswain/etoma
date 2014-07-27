# encoding: utf-8

THIS_DIR = File.dirname(__FILE__)
APP = 'etoma_sock'
NODE = 'etoma'
LIB = APP + '-1'

require 'fileutils'

desc 'Copy static content to release directory'
task :static do
  FileUtils.cp_r(File.join(THIS_DIR, 'apps', APP, 'priv'),
                 File.join(THIS_DIR, 'rel', NODE, 'lib', LIB))
end
