require 'json'



# Find the food with the highest amount of proteins that was consumed on 1st of November 2022.
# return: name of the meal
def find_highest_protiens(data)
    meals = data.select { |obj| obj["date_consumed"] == "2022-11-01"}
    sorted = meals.sort_by { | obj | - obj["protein"] }
    meal = sorted[0]["name"]
    puts meal
end

# 4) Calculate how many users have passed 30k calories for each month.
# Output: Lines in format "<month in format YYYY-MM>: <number of users meeting criteria>"
# Expected:
# 2022-09: 6
# 2022-10: 20
# 2022-11: 19
def calculate_num_30k_calorie_users(data)
    unique_users = data.map { |obj| obj["user_id"]}.uniq

    grouped = {}
    data.each do |obj|
        date = obj["date_consumed"][0..6]
        user_id = obj["user_id"]
        calories = obj["calories"]
        
        if grouped[date].nil?
            grouped[date] = {}
        end
        month = grouped[date]

        if month[user_id].nil? 
            month[user_id] = 0
        end
        current = month[user_id]
        month[user_id] = current + calories
    end
    
    passed = {}
    grouped.each do | m, usrs | 
        usrs.each do |key,val|
            if val > 30_000
                if passed[m].nil?
                    passed[m] = 0
                end
                passed[m] += 1
            end
        end
    end

    passed.each do |k,v|
        puts "#{k}: #{v}"
    end
end

# Find 3 cheapest foods and their consumers.
# Output: Lines in format "<name of the meal>, <lowest price>, <consumer ID>"
# Expected: 
#Arepas, 5.01, 13
#Tiramisù, 5.02, 15
#Cauliflower Penne, 5.03, 17
def find_three_cheapest_foods(data)
   sorted = data.sort_by { |obj| obj["price"] }
   cheapest = sorted[0..2]
   cheapest.each do | obj |
     puts "#{obj["name"]}, #{obj["price"]}, #{obj["user_id"]}"
   end
end

data = File.read("./data.json")
json_data = JSON.parse(data)

puts "Food with the highest amount of proteins that was consumed on 1st of November 2022."
puts "--------------------"
find_highest_protiens(json_data)

puts ""
puts "How many users have passed 30k calories for each month"
puts "--------------------"
calculate_num_30k_calorie_users(json_data)

puts ""
puts "Three cheapest Foods"
puts "--------------------"
find_three_cheapest_foods(json_data)

