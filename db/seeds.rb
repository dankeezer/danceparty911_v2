# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Adding a whole bunch of tracks"
Track.create [

  {
    artist_name: "Yeah Yeah Yeahs",
    stream_url: "http://dankeezer.com/dp911/xyz/awesome/02DateWithANight.mp3",
    title: "Date With A Night"
  },
  {
    artist_name: "Yeasayer",
    stream_url: "http://dankeezer.com/dp911/xyz/joiedevivre/05 ONE.mp3",
    title: "O.N.E."
  }
]

