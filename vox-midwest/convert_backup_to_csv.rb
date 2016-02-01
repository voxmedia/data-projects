#!/usr/bin/ruby
require 'json'
require 'date'
require 'csv'
require 'active_support/time'

submissions = JSON.parse( IO.read('submissions.json') )

csv_format = {:col_sep => ',', :quote_char => '"', :force_quotes => true}

# create states directory if it doesn't exist already
unless File.directory?('states')
  Dir.mkdir 'states'
end


# create states directory if it doesn't exist already
unless File.directory?('data')
  Dir.mkdir 'data'
end

valid_states = ['AL','AZ','AR','CA','CO','CT','DE','FL','GA','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']


# make a csv of each submission and their states selected
submissions_csv = CSV.open('data/submissions.csv', 'w', csv_format)
submissions_csv << ['date','time (ET)','states']

# if you picked one state, what did the vox midwest look like?
valid_state_hash = Hash.new
valid_states.each do | state |
  valid_state_hash[ state ] = 0
end
state_hashes = Hash.new
valid_states.each_with_index do | state |
  state_hashes[ state ] = valid_state_hash
end

# loop through submissions
submissions.each_with_index do | submission, i |
  if i == 2

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


    # # loop through the states 
    states.each do | state |
      other_states = states - [ state ]


      puts "#{ state } : #{ other_states }"


      other_states.each do | other_state |
        value = state_hashes[ state ][ other_state ] + 1
        state_hashes[ state ][ other_state ] = value
      end



    end

    # join the array of states for the ismple csv
    all_states = states.join(',')

    # fill out some CSVs
    submissions_csv << [full_date,time,all_states]
  end
end 

# puts JSON.pretty_generate(state_hashes)

submissions_csv.close()
