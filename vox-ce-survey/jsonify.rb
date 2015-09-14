#!/usr/bin/ruby
require 'csv'
require 'json'
require 'readline'
require 'pp'


def arrayify(column_index)

  a = Array.new

  CSV.foreach( 'parent.csv', :headers => true ) do | row |

    unless row[column_index].nil?
      # If it's not an empty row

      parent_name = row[0]
      parent_id = row[1]
      item_name = row[2]
      item_id = row[3]
      is_child = row[4] 
      income_range = row[column_index]


      h = Hash.new
     
      h[:item_id] = item_id
      h[:name] = item_name
      unless parent_id == 'expenditures' 
        # If it has a parent
        h[:parent_id] = parent_id
      end

      if is_child == 'child'
        if income_range == 'a/' || income_range == 'b/'
          h[:value] = 0
        else
          h[:value] = income_range.gsub(',', '').to_f
        end
      end
      a.push(h)
    end
  end

  # How to generate a tree structure from an array
  # http://stackoverflow.com/a/18829741

  a = a.map do |h| 
    [ 
      h[:item_id],
      h.merge( children: [] ) 
    ] 
  end
  nested_hash = Hash[ a ]
  nested_hash.each do |id, item|
    parent_id = nested_hash[ item[:parent_id] ]
    if parent_id
      parent_id[:children] << item 
    end
  end

  tree = nested_hash.select do |id, item| 
    item[:parent_id].nil? 
  end

  expenditures = Hash.new
  expenditures['name'] = 'Expenditures';
  expenditures['item_id'] = 'expenditures';
  expenditures['children'] = tree.values;

  cjson = expenditures.to_json
  pjson = JSON.pretty_generate(expenditures)

  File.open("range-#{column_index}.json",'w') do | file |
    file << cjson
  end

  File.open("pretty-range-#{column_index}.json",'w') do | file |
    file << pjson
  end
end

def jsonify
  c = 5
  9.times do 
    arrayify(c)
    c += 1
  end
end

jsonify()
