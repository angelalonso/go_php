#!/usr/bin/ruby
require 'mysql'

@max_colnr = 18
@max_rownr = 18


def newgame
  begin
    con = Mysql.new 'localhost', 'root', 'root 123'
    for cols in 0..@max_colnr
      for rows in 0..@max_rownr
        row_col = "%02d" % rows + "%02d" % cols
        sql_a = con.query "UPDATE `goDB`.`stonetable` SET `stone`='none' WHERE `row_col`=" + row_col + ";"
      end
    end
    sql_b = con.query "UPDATE `goDB`.`table_of_games` SET `is_plyr1_next`=true , `moveid_for_next`=0000000001 WHERE gameid=0000000001;"

  rescue Mysql::Error => e
    puts e.errno
    puts e.error
  ensure
    con.close if con
  end
end


def load_table
  curr_table = {}
  begin
    con = Mysql.new 'localhost', 'root', 'root 123'
    sql_a = con.query "SELECT `row_col`,`stone` FROM `goDB`.`stonetable` WHERE `stone`=`stone`;"
    while row = sql_a.fetch_row do
      curr_table[row[0]] = row[1]
    end
  rescue Mysql::Error => e
    puts e.errno
    puts e.error
  ensure
    con.close if con
  end
  return curr_table
end


def add_stone(row_col)
  stone_table = load_table()
  if (stone_table[row_col] == "none")
  then
    begin
      con = Mysql.new 'localhost', 'root', 'root 123'
      sql_a = con.query "SELECT is_plyr1_next, moveid_for_next FROM `goDB`.`table_of_games` WHERE gameid=0000000001;"
      result_a = sql_a.fetch_row
      if result_a[0] == '1'
        stone = 'white'
        nextiswhite = false
      else
        stone = 'black'
        nextiswhite = true
      end
      new_moveid = result_a[1].to_i + 1

      sql_b = con.query "UPDATE `goDB`.`stonetable` SET `stone`='" + stone + "' WHERE `row_col`='" + row_col + "';"
      sql_c = con.query "UPDATE `goDB`.`table_of_games` SET `is_plyr1_next`=" + nextiswhite.to_s + ", `moveid_for_next`=" + new_moveid.to_s + " WHERE gameid=0000000001;"
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    ensure
      con.close if con
    end
  end
  grouped_stones = getgroups(stone_table)
  ##TODO: transform this in arrays
  white_groups = grouped_stones[0]
  black_groups = grouped_stones[1]

  get_catches(stone_table,white_groups)
  get_catches(stone_table,black_groups)
  #puts white_groups.to_s
  #puts black_groups.to_s
  return ""
end

def get_turn
  begin
    con = Mysql.new 'localhost', 'root', 'root 123'
    sql_a = con.query "SELECT is_plyr1_next, moveid_for_next FROM `goDB`.`table_of_games` WHERE gameid=0000000001;"
    result_a = sql_a.fetch_row
      if result_a[0] == '1'
        stone = 'white'
      else
        stone = 'black'
      end
  rescue Mysql::Error => e
    puts e.errno
    puts e.error
  ensure
    con.close if con
  end
  return stone
end
#def test_liberty_table
#  stone_table = load_table()
#  stripped_table = {}
#  liberties_table = {}
#  stone_table.each do |test|
#    row_col = test[0]
#    stone = test[1]
#    if (stone == "white" or stone == "black")
#    then 
#      stripped_table[row_col] = stone
#    end
#  end
#  stripped_table.each do |stone|
#    liberties_table[stone[0]] = liberties_of_stone(stone[0],stone[1],stripped_table)
#  end
#  look_for_catches(stone_table,liberties_table)
#end

#def neighbours_of_stone(row_col,stone_table)
#  # Indexes: 0 -> up, 1 -> down, 2 -> left, 3 -> right
#  neighbours = []
#  row = row_col.slice(0,2).to_i
#  col = row_col.slice(2,2).to_i
#  if (row==0) then up = "end" else up = stone_table["%02d" % (row-1) + "%02d" % col] end
#  if (row==@max_rownr) then down = "end" else down = stone_table["%02d" % (row+1) + "%02d" % col] end
#  if (col==0) then left = "end" else left = stone_table["%02d" % row + "%02d" % (col-1) ] end
#  if (col==@max_colnr) then right = "end" else right = stone_table["%02d" % row + "%02d" % (col+1) ] end
#  neighbours = [up, down, left, right]
#  return neighbours
#end


#def liberties_of_stone(row_col,stone_color,stone_table)
#  other_stone = opposite_stone(stone_color)
#  row = row_col.slice(0,2).to_i
#  col = row_col.slice(2,2).to_i
#  if (row==0) then up = "end" else up = stone_table["%02d" % (row-1) + "%02d" % col] end
#  if (row==@max_rownr) then down = "end" else down = stone_table["%02d" % (row+1) + "%02d" % col] end
#  if (col==0) then left = "end" else left = stone_table["%02d" % row + "%02d" % (col-1) ] end
#  if (col==@max_colnr) then right = "end" else right = stone_table["%02d" % row + "%02d" % (col+1) ] end
#  liberty_count = 4
#  connections = 0
#  liberties = [up, down, left, right]
#  liberties.each do |a|
#    if (a!=nil) then 
#      liberty_count -=1 
#      if (a==stone_color) then 
#        connections -= 1 
#      end
#    end
#  end
#  if (liberty_count == 0) then liberty_count = connections end
#  return liberty_count
#end


#def look_for_catches(stone_table,liberties_table)
#  liberties_table.each do |stone|
#    if (stone[1] == 0) then 
#      catch_stone(stone[0],stone_table[stone[0]]) 
#    elsif (stone[1] < 0) then
#      group_array = []
#      look_for_catches_group(stone[0],stone_table[stone[0]],stone_table,liberties_table,group_array)
#    end
#  end
#end


#def look_for_catches_group(row_col,stone,stone_table,liberties_table,group_array)
#  this_group = group_array
#  this_group = this_group + [row_col]
#  neighbours_of_stone(row_col,stone_table).each do |group_stone|
#    if (!this_group.include?(group_stone)) then
#      if (stone_table[group_stone] == stone) then
#        puts group_stone
#        this_group = this_group + [group_stone]
#        look_for_catches_group(group_stone,stone,stone_table,liberties_table,this_group)
#      end
#    end
#  end      
#end

#def opposite_stone(stone)
#  if (stone=="white") then other_stone="black" elsif (stone=="black") then other_stone="white" end
#  return other_stone
#end


#def connections(row_col,stone_table)
#  stone_table = load_table()
#  puts stone_table.to_s
#  puts "----------------------------------------------_"
#  checked = []
#  group = []
#  stone_table.each do |stone|
#    color = stone[1]
#    if (color=="white" or color=="black") and (!checked.include?(stone[0])) then
#      puts "---" + stone[0]
#      checked = checked + [stone[0]]
#      surround = surrounding(stone[0],stone_table)
#      surround.each do |surr_stone|
#        if (surr_stone[1] == color) then
#          puts surr_stone[0]
#        end
#      end
#    end
#  end 
#end



#def surrounding(row_col,stone_table)
#  surrounders = {}
#  color = stone_table[row_col]
#  row = row_col.slice(0,2).to_i
#  col = row_col.slice(2,2).to_i
#  if (row==0) then surrounders["%02d" % (row-1) + "%02d" % col] = "end" else surrounders["%02d" % (row-1) + "%02d" % col] = stone_table["%02d" % (row-1) + "%02d" % col] end
#  if (row==@max_rownr) then surrounders["%02d" % (row+1) + "%02d" % col] = "end" else surrounders["%02d" % (row+1) + "%02d" % col] = stone_table["%02d" % (row+1) + "%02d" % col] end
#  if (col==0) then surrounders["%02d" % row + "%02d" % (col-1)] = "end" else surrounders["%02d" % row + "%02d" % (col-1)] = stone_table["%02d" % row + "%02d" % (col-1) ] end
#  if (col==@max_colnr) then surrounders["%02d" % row + "%02d" % (col+1)] = "end" else surrounders["%02d" % row + "%02d" % (col+1)] = stone_table["%02d" % row + "%02d" % (col+1) ] end
#  return surrounders
#end


##############################
###
def getgroups(table)
  group = []
  group_of_groups = []
  white_groups = []
  black_groups = []
  checked = []
  table.each do |stone|
    if (stone[1] != "none")
      group = get_connect(stone[0],table) + [stone[0]] 
      if (stone[1] == "white") then
        white_groups = white_groups + [group]
      elsif (stone[1] == "black") then
        black_groups = black_groups + [group]
      end
    end
  end
  if white_groups.length > 0 then
    white_groups = reduce_groups(white_groups,table).map.to_a
  end
  if black_groups.length > 0 then
    black_groups = reduce_groups(black_groups,table).map.to_a
  end
   
  result =  [white_groups] + [black_groups]
  return result
end

###
def get_connect(row_col, table)
  result = []
  list = get_surrounding(row_col,table)
  color = table[row_col]
  list.each do |connection|
    if (connection[1] == color) then
      result = result + [connection[0]]
    end
  end
  return result
end


def get_surrounding(row_col,table)
  row = row_col.slice(0,2).to_i
  col = row_col.slice(2,2).to_i
  result = {}
  if (row==0) then result["%02d" % (row-1) + "%02d" % col] = "end" else result["%02d" % (row-1) + "%02d" % col] = table["%02d" % (row-1) + "%02d" % col] end
  if (row==@max_rownr) then result["%02d" % (row+1) + "%02d" % col] = "end" else result["%02d" % (row+1) + "%02d" % col] = table["%02d" % (row+1) + "%02d" % col] end
  if (col==0) then result["%02d" % row + "%02d" % (col-1) ] = "end" else result["%02d" % row + "%02d" % (col-1) ] = table["%02d" % row + "%02d" % (col-1) ] end
  if (col==@max_colnr) then result["%02d" % row + "%02d" % (col+1) ] = "end" else result["%02d" % row + "%02d" % (col+1) ] = table["%02d" % row + "%02d" % (col+1) ] end

  return result
end


def reduce_groups(group_of_groups,table) 
  unchanged = 0 
  test_group = group_of_groups.map.to_a 
  until unchanged > group_of_groups.length do 
    unchanged_tmp = 1 
    subject = test_group.shift 
    main = subject.map.to_a 
    rest = [] 
    test_group.each do |test_against|  
      connected = false 
      subject.each do |item| 
        if test_against.include?(item) then connected = true end 
      end 
      if connected then 
        unchanged_tmp = 0 
        main = main.map.to_a + test_against.map.to_a 
        main = main.sort.uniq 
      else 
        rest = rest + [test_against] 
      end 
    end 
 
    test_group = rest.map.to_a + [main.map.to_a] 
    unchanged += unchanged_tmp 
  end 
  final_group = test_group.map.to_a 
  return final_group 
end 


def get_catches(table,groups)
  groups.each do |group|
    free = false
    group.each do |item|
      surround = get_surrounding(item,table)
      surround.each do |test|
        if (test[1].to_s == "none") then 
          free = true
        end
      end
    end
    if !free then
      group.each do |row_col|
        stone = table[row_col]
        catch_stone(row_col,stone)
      end
    end
  end
end


def catch_stone(row_col,stone)
  begin
    con = Mysql.new 'localhost', 'root', 'root 123'
    #sql_b = con.query "UPDATE `goDB`.`stonetable` SET `stone`='" + opposite_stone(stone) + "' WHERE `row_col`='" + row_col + "';"
    sql_b = con.query "UPDATE `goDB`.`stonetable` SET `stone`='none' WHERE `row_col`='" + row_col + "';"
  rescue Mysql::Error => e
    puts e.errno
    puts e.error
  ensure
    con.close if con
  end
end



##############################
def test
  puts "testing!"
end

## Main program
if (!ARGV[0].nil?) 
  if (ARGV[0] == "newgame")
    newgame()
  elsif (ARGV[0] == "getturn")
    puts get_turn    
  elsif (ARGV[0] == "test")
    test()
  elsif (ARGV[0] == "update")
    puts ""
  else
    newstone = ARGV[0]
    add_stone(newstone)
  end
else 
  puts "meh"
end
