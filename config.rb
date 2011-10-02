require 'rubygems'
require 'socket'
require 'rest_client'
require 'nokogiri'
require 'sanitize'
require 'cgi'
require 'net/http'
require 'sequel'

Dir['classes/*'].each { |object| require object }
DB = Sequel.sqlite('lsdbot.db')

