#!/usr/bin/ruby
require 'json'
require 'date'
require 'csv'
require 'active_support/time'

submissions = JSON.parse( IO.read('submissions.json') )

csv_format = {:col_sep => ',', :quote_char => '"', :force_quotes => true}


# create data directory if it doesn't exist already
unless File.directory?('data')
  Dir.mkdir 'data'
end

valid_states = ["AL","AZ","AR","CA","CO","CT","DE","FL","GA","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]


# make a csv of each submission and their states selected
submissions_csv = CSV.open('data/submissions.csv', 'w', csv_format)
submissions_csv << ['date','time (ET)','states']

# if you picked one state, what did the vox midwest look like?

state_hashes = Hash.new
valid_states.each_with_index do | state |
  # loop thru each state and create a hash of states
  state_hash = Hash.new

  valid_states.each do | s |
    state_hash[ s ] = 0
  end

  state_hashes[ state ] = state_hash
end


# loop through submissions
submissions.each_with_index do | submission, i |

  submission = JSON.parse( submission )
  timestamp = DateTime.parse( submission['time'] ).in_time_zone('Eastern Time (US & Canada)')

  # # Use these if you want second-by-second analysis
  # year    = timestamp.strftime('%Y')
  # month   = timestamp.strftime('%m')
  # date    = timestamp.strftime('%d')
  # hour    = timestamp.strftime('%H')
  # minute  = timestamp.strftime('%M')
  # seconds = timestamp.strftime('%S')

  full_date = timestamp.strftime('%Y-%m-%d')
  time      = timestamp.strftime('%H:%M:%S')
  
  # sort states
  states = submission['states'].sort()
  # e.g. "IA,IL,IN,KS,MI,MN,NE,OH,WI"


  # # loop through the states in submission
  states.each do | state |

    states.each do | other_state |
      value =  state_hashes[ state ][ other_state ] 
      state_hashes[ state ][ other_state  ] = value + 1
    end

  end

  # join the array of states for the ismple csv
  all_states = states.join(',')

  # fill out some CSVs
  submissions_csv << [full_date,time,all_states]
end 


# create states directory if it doesn't exist already
unless File.directory?('states')
  Dir.mkdir 'states'
end

state_hashes.keys.each do | key |
  state_json = state_hashes[ key ].to_json
  fileName = "states/#{ key }.json"
  File.open(fileName, 'w') do | file |
    file.write( state_json )
  end
end

submissions_csv.close()
