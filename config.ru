require 'rubygems'
require 'bundler'

Bundler.require

$LOAD_PATH.unshift File.dirname(__FILE__)
puts "LOAD_PATH #{$LOAD_PATH.inspect}"
require 'app'
run App

