module Constants
  WEIGHT_UNITS = [
    "lbs",
    "kg"
  ]

  LONG_DISTANCE_UNITS = [
    "mi",
    "km"
  ]

  SHORT_DISTANCE_UNITS = [
    "ft",
    "m"
  ]

  UNIT_TYPES = {
    "ft" => "imperial",
    "lbs" => "imperial",
    "mi" => "imperial",
    "km" => "metric",
    "m" => "metric",
    "kg" => "metric"
  }

  UNIT_CONVERSION_FACTORS = {
    "ft" => 0.3048, # Feet to meters
    "m" => 3.2808, # Meters to feet
    "lbs" => 0.4535, # Pounds to kilograms
    "kg" => 2.2046, # Kilograms to pounds
    "mi" => 1.6093, # Miles to kilometers
    "km" => 0.6213 # Kilometers to miles
  }

  WORKOUT_TYPES = [
    "Weight",
    "Long Distance",
    "Short Distance"
  ]

  WORKOUT_TAGS = [
    "Core",
    "Legs",
    "Shoulders",
    "Chest",
    "Upper Back",
    "Lower Back",
    "Biceps",
    "Triceps",
    "Cardio",
    "Stretch"
  ]
end
