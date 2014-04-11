#!/usr/bin/ruby
# Author: csmunuku@gmail.com
# Get's Stock information for the stocks provided on command line
# Download's information from Yahoo Finance Site
# Gets a csv and displays it as a table.
####################################################################### 
require 'open-uri'
require 'csv'
require 'text-table'

#############################
# Yahoo API Symbol info
# s=Stock Symbol
# l1=Last Trade (Price Only)
# d1=Last Trade Date
# t1=Last Trade Time
# c1=Change
# o=Open price
# h=Day's High
# g=Day's Low
# v=Today's Volume
# a2=Avg Daily Volume
#############################
#Header
table = Text::Table.new
table.head = ['Symbol', 'Date', 'Last Trade', 'Open Price', 'Day\'s Low', 'Day\'s High', 'Change', 'Today\'s Volume', 'Avg Daily Vol']

# Go through the Arg list and add the row to the table and print
ARGV.each do|stock_symbol|
#  puts "Argument: #{stock_symbol}"
  url = "http://download.finance.yahoo.com/d/quotes.csv?s=#{stock_symbol}&f=sd1l1oghc1va2&e=.csv"
  csv = CSV.parse(open(url).read)
  csv.each do |row|
     table.rows << row
  end
end
puts table
