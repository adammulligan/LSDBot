#!/usr/bin/env ruby

$: << '.' unless $:.include? '.'

require 'config'

bot = LSDBot.new('irc.freenode.net', 6667, 'fakechannel10')
bot.run

