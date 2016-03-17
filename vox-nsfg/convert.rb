#!/usr/bin/ruby

require 'csv'

  
def convert_to_csv(file_name, sex, year)
  marstat = {
    "" => "N/A",
    "1" => "Married to a person of the opposite sex",
    "2" => "Not married but living together with a partner of the opposite sex",
    "3" => "Widowed",
    "4" =>"Divorced or annulled",
    "5" => "Separated, because you and your spouse are not getting along",
    "6" => "Never been married",
    "8" => "Refused",
    "9" => "Don't know"
  }
  relcurr = {
    "" => "N/A",
    "1" => "None", 
    "2" => "Catholic",
    "3" => "Baptist/Southern Baptist",
    "4" => "Methodist, Lutheran, Presbyterian, Episcopal",
    "5" => "Fundamentalist Protestant",
    "6" => "Other Protestant denomination",
    "7" => "Protestant - No specific denomination",
    "8" => "Other religion",
    "9" => "Refused",
    "10" => "Don't know",
    "V1" => "Christian" # Vox category (3 - 7)
  }
  reldlife = {
    "" => "N/A",
    "1" => "Very important",
    "2" => "Somewhat important",
    "3" => "Not important",
    "7" => "Not ascertained",
    "8" => "Refused",
    "9" => "Don't know"
  }
  staytog = {
    "" => "N/A",
    "1" => "Strongly agree",
    "2" => "Agree",
    "3" => "Disagree",
    "4" => "Strongly disagree" ,
    "5" => "If R insists: Neither agree nor disagree",
    "8" => "Refused",
    "9" => "Don't know",
    "V1" => "Agree",    # Vox category (1 - 2)
    "V2" => "Disagree", # Vox category (3 - 4)
    "V3" => "Other"     # Vox category (5, 8, 9)
  }
  hieduc = {
    "" => "N/A",
    "5" => "9TH GRADE OR LESS",
    "6" => "10TH GRADE",
    "7" => "11TH GRADE",
    "8" => "12TH GRADE, NO DIPLOMA (NOR GED)",
    "9" => "HIGH SCHOOL GRADUATE (DIPLOMA OR GED)",
    "10" => "SOME COLLEGE BUT NO DEGREE",
    "11" => "ASSOCIATE DEGREE IN COLLEGE/UNIVERSITY",
    "12" => "BACHELOR'S DEGREE",
    "13" => "MASTER'S DEGREE",
    "14" => "DOCTORATE DEGREE",
    "15" => "PROFESSIONAL DEGREE",
    "V1" => "No high school degree", # Vox category (5 - 8)
    "V2" => "High school degree",    # Vox category (9 - 10)
    "V3" => "College degree",        # Vox category (11 - 12)
    "V4" => "Graduate degree"        # Vox category (13 - 15)
  }

  csv_name = file_name.sub('_raw.txt', '.csv').sub('extract', 'csv')
  CSV.open(csv_name, 'w') do | csv |
    csv << ['YEAR','SEX','MARSTAT','RELCURR','RELDLIFE','STAYTOG','HIEDUC']

    File.foreach(file_name).with_index do |line, i|
      # r_index = i
      r_marstat = marstat[ line[0].strip ] 

      # group up values
      religion = line[1..2].strip
      if Integer(religion)
        if Integer(religion) >= 3 and Integer(religion) <= 7
          religion = "V1"
        end
      end
      r_relcurr = relcurr[ religion ]

      r_reldlife =  reldlife[ line[3].strip ]

      divorce = line[4].strip
      if Integer(divorce)
        if Integer(divorce) >= 1 and Integer(divorce) <= 2
          divorce = "V1"
        elsif Integer(divorce) >= 3 and Integer(divorce) <= 4
          divorce = "V2"
        elsif Integer(divorce) == 5 or Integer(divorce) == 8 or Integer(divorce) == 9
          divorce = "V3"
        end
      end
      r_staytog  =   staytog[ divorce ]

      # r_age = line[5..6].strip
      # if Integer(r_age)
      #   if Integer(r_age) >= 15 and Integer(r_age) <= 24
      #     r_age = '15-24'
      #   elsif Integer(r_age) >= 25 and Integer(r_age) <= 34
      #     r_age = '25-34'
      #   elsif Integer(r_age) >= 35
      #     r_age = '35-44'
      #   end
      # end

      # group up values
      education = line[7..8].strip
      if Integer(education)
        if Integer(education) >= 5 and Integer(education) <= 8
          education = "V1"
        elsif Integer(education) >= 9 and Integer(education) <= 10
          education = "V2"
        elsif Integer(education) >= 11 and Integer(education) <=12
          education = "V3"
        elsif Integer(education) >= 13 and Integer(education) <= 15
          education = "V4"
        end
      end
      r_hieduc   =   hieduc[ education ]
      csv << [year, sex, r_marstat, r_relcurr, r_reldlife, r_staytog, r_hieduc]
    end
  end
end

def convert()
  puts "- Recoding raw data to values..."

  Dir.mkdir 'csv' unless File.exists?('csv')

  convert_to_csv('extract/2011_2013_female_raw.txt', "f", "2011_2013")
  convert_to_csv('extract/2011_2013_male_raw.txt'  , "m",   "2011_2013")
  convert_to_csv('extract/2006_2010_female_raw.txt', "f", "2006_2010")
  convert_to_csv('extract/2006_2010_male_raw.txt'  , "m",   "2006_2010")
  convert_to_csv('extract/2002_female_raw.txt'     , "f", "2002")
  convert_to_csv('extract/2002_male_raw.txt'       , "m",   "2002")
end

convert()
