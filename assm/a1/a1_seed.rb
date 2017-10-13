#!/usr/bin/env ruby

# Author: Dave Pagurek (https://gist.github.com/davepagurek/2504674142c1698f5ae5e9d76466f034)
#
# Usage:
#    chmod +x seed_database.rb
#    ./seed_database.rb > seed.sql
#
# First, set up the schema using the provided sql:
#    db2 -f schema.sql
#
# Then, insert data:
#    db2 -f seed.sql

prng = Random.new(1) # with seed so this is deterministic

departments = ["CS", "CO", "PM", "AM"]
term_prefixes = ['S', 'F', 'W']
years = (2015..2017).to_a
num_students = 1000
num_profs = 20
days = %w(Monday Tuesday Wednesday Thursday Friday)

prof_inserts = []
student_inserts = []
course_inserts = []
class_inserts = []
schedule_inserts = []
enrollment_inserts = []
mark_inserts = []


# Generate 50 professors (2 exist in the schema setup)
(3..num_profs).each do |i|
  name = "Professor #{i}"
  office = "DC#{prng.rand(100..399)}" # they all live in DC I guess
  dept = departments.sample(random: prng)
  prof_inserts << "(#{i}, '#{name}', '#{office}', '#{dept}')"
end

# Generate students
(2..num_students).each do |i|
  name = "Student #{i}"
  year = prng.rand(1..4)
  student_inserts << "(#{i}, '#{name}', #{year})"
end

# Generate a bunch of classes
(3..100).each do |i|
  cnum = departments.sample(random: prng) + i.to_s
  cnum = "CS240" if i == 3
  cnum = "CS245" if i == 4
  term = term_prefixes.sample(random: prng) + years.sample(random: prng).to_s

  # the name is the class num, sue me
  course_inserts << "('#{cnum}', '#{cnum}')"

  (1..prng.rand(1..4)).each do |section|
    prof = prng.rand(1..num_profs)
    active = (term == "F2017")
    class_inserts << "('#{cnum}', '#{term}', #{section}, #{prof})"

    days.sample(prng.rand(1..5), random: prng).each do |day|
      time = prng.rand(1..23).to_s + ":30" # theyre all on :30s deal with it
      room = "MC#{prng.rand(1000..6999)}" # MC lyfe

      schedule_inserts << "('#{cnum}', '#{term}', #{section}, '#{day}', '#{time}', '#{room}')"
    end

    # Enroll between 30 and 200 students
    (1..num_students).to_a.sample(prng.rand(30..200), random: prng).each do |snum|
      enrollment_inserts << "(#{snum}, '#{cnum}', '#{term}', #{section})"

      # Add a mark unless this is a current course
      unless active
        grade = prng.rand(65..100) # everyone passes!
        mark_inserts << "(#{snum}, '#{cnum}', '#{term}', #{section}, #{grade})"
      end
    end
  end
end

puts "connect to cs348"
puts "insert into professor values #{prof_inserts.join(', ')}"
puts "insert into student values #{student_inserts.join(', ')}"
puts "insert into course values #{course_inserts.join(', ')}"
puts "insert into class values #{class_inserts.join(', ')}"
puts "insert into schedule values #{schedule_inserts.join(', ')}"
puts "insert into enrollment values #{enrollment_inserts.join(', ')}"
puts "insert into mark values #{mark_inserts.join(', ')}"
puts "commit work"
