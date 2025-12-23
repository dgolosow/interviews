require 'json'
require 'test/unit'


# Find the food with the highest amount of proteins that was consumed on 1st of November 2022.
# return: name of the meal
def find_highest_protiens(data)
    meals = data.select { |obj| obj["date_consumed"] == "2022-11-01"}
    sorted = meals.sort_by { | obj | - obj["protein"] }
    meal = sorted[0]["name"]
    meal
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

    passed
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
   cheapest.map { |obj| { "name" => obj["name"], "price" => obj["price"], "user_id" => obj["user_id"] } }
end

def load_data
    data = File.read("./data.json")
    json_data = JSON.parse(data)
    json_data
end

def print_tasks
  json_data = load_data

  puts "Food with the highest amount of proteins that was consumed on 1st of November 2022."
  puts "--------------------"
  puts find_highest_protiens(json_data)
  
  puts ""
  puts "How many users have passed 30k calories for each month"
  puts "--------------------"
  results = calculate_num_30k_calorie_users(json_data)
  results.each do |k,v|
      puts "#{k}: #{v}"
  end

  puts ""
  puts "Three cheapest Foods"
  puts "--------------------"
  cheapest = find_three_cheapest_foods(json_data)
  cheapest.each do | obj |
      puts "#{obj["name"]}, #{obj["price"]}, #{obj["user_id"]}"
  end
end


class TaskTest < Test::Unit::TestCase
    
    def test_highest_protiens
        json_data = load_data
        result = find_highest_protiens(json_data)
        expected = "Pizza"
        assert_equal(result, expected, "Result expected to be #{expected}")
    end

    def test_calculate_num_30k_calorie_users
        json_data = load_data
        result = calculate_num_30k_calorie_users(json_data)
        expected = {
            "2022-09" => 6,
            "2022-10" => 20,
            "2022-11" => 19
        }
        assert_equal(result, expected, "Result expected to be #{expected}")
    end

    def test_find_three_cheapest_foods
        json_data = load_data
        result = find_three_cheapest_foods(json_data)
        expected = [
            { "name" => "Arepas", "price" => 5.01, "user_id" => "13" },
            { "name" => "Tiramisù", "price" => 5.02, "user_id" => "15" },
            { "name" => "Cauliflower Penne", "price" => 5.03, "user_id" => "17" },
        ]
        assert_equal(result, expected, "Result expected to be #{expected}")
    end

end