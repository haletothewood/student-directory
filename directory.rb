require 'csv'

@students = []
@possible_cohorts = [:January, :February, :March,
  :April, :May, :June, :July, :August, :September,
  :October, :November, :December]

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts "What would you like to do?"
  puts "1. Input the students"
  puts "2. Show the student directory"
  puts "3. Save the list to a file"
  puts "4. Load the list from a file"
  puts "5. Remove a student from the directory"
  puts "9. Exit"
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      print_students_list
    when "3"
      save_students
    when "4"
      load_students
    when "5"
      remove_student
    when "9"
      exit
    else
      puts "Please enter 1, 2, 3, 4, or 9"
  end
end

def prompt
  puts "Please enter the names of the student to enter:"
  @name = STDIN.gets.chomp.capitalize
  if !@name.empty?
    puts "What cohort are they in?"
    @cohort = STDIN.gets.chomp.capitalize.to_sym
    until @possible_cohorts.include?(@cohort) do
      puts "I'm sorry I didn't get that, please enter a valid month"
      @cohort = STDIN.gets.chomp.capitalize.to_sym
    end
  end
  @students
end

def input_student(name, cohort)
  @students << {name: name, cohort: cohort}
end

def input_students
  prompt
  while !@name.empty? do
  input_student(@name, @cohort)
  if @students.count == 1
    puts "Now we have #{@students.count} student"
  else
    puts "Now we have #{@students.count} students"
  end
  prompt
  end
  @students
end

def remove_student
  puts "Please enter the name of the student you would like to remove"
  name = gets.chomp
  @students.each do |student|
    if name == student[:name]
      puts "-------------"
      puts "#{student[:name]} has removed from the directory"
      puts "-------------"
      @students.delete(student)
    end
  end
  @students
end

def save_students
  puts "What would you like to call your saved file?"
  CSV.open(STDIN.gets.chomp, "wb") do |csv|
    @students.each do |student|
      student_data = [student[:name], student[:cohort]]
      csv << student_data
    end
  end
  puts "Your file has been saved."
  puts "-------------"
end

def load_students
  puts "Please write the file would you like to load? Or press ENTER to load students.csv"
  input = STDIN.gets.chomp
  input.empty? ? filename = "students.csv" : filename = input
  if File.exists?(filename)
    CSV.foreach(filename) do |row|
        name, cohort = row
        input_student(name, cohort.to_sym)
    end
  else
    puts "Sorry, #{filename} doesn't exist."
    puts "-------------"
    interactive_menu
  end
  puts "Your file #{filename} has been loaded."
  puts "-------------"
end

def try_load_students
  filename = ARGV.first
  if filename.nil?
    interactive_menu
  elsif File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

def print_header
  puts "----------------" * 3
  puts "The students of Villains Academy".center(47)
  puts "----------------" * 3
end

def print_footer
  puts "----------------" * 3
  if @students.count != 1
    puts "Overall, we have #{@students.count} great students".center(47)
  else
    puts "Overall, we have #{@students.count} great student.".center(47)
  end
  puts "----------------" * 3
end

def print_students_list
  if @students != []
    print_header
    array = []
    @students.each do |student|
      array << [student[:name], student[:cohort]]
    end
    index = 1
    @possible_cohorts.each do |cohort|
      array.each_with_index do |student|
        if cohort == student[1]
          puts "#{index}: #{student[0].split.map(&:capitalize).join(' ')}".ljust(20) + "(#{student[1]} Cohort)".center(40)
          index += 1
        end
      end
    end
    print_footer
  else
    puts "Sorry, no students are yet enrolled!"
  end
end

try_load_students
interactive_menu
