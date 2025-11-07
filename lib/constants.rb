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

  TIME_ZONES = [
    "Pacific/Midway",            # UTC-11
    "America/Adak",              # UTC-10, Alaska
    "Pacific/Honolulu",          # UTC-10, Hawaii
    "America/Anchorage",         # UTC-9
    "America/Los_Angeles",       # UTC-8, Pacific Time
    "America/Denver",            # UTC-7, Mountain Time
    "America/Chicago",           # UTC-6, Central Time
    "America/New_York",          # UTC-5, Eastern Time
    "America/Caracas",           # UTC-4:30
    "America/Santiago",          # UTC-4, Chile
    "America/Halifax",           # UTC-4, Atlantic Time (Canada)
    "America/St_Johns",          # UTC-3:30, Newfoundland
    "America/Argentina/Buenos_Aires", # UTC-3
    "America/Sao_Paulo",         # UTC-3, Brazil
    "Atlantic/Azores",           # UTC-1
    "Europe/London",             # UTC+0, UK
    "Europe/Paris",              # UTC+1, Central Europe
    "Europe/Athens",             # UTC+2, Eastern Europe
    "Africa/Cairo",              # UTC+2, Egypt
    "Europe/Moscow",             # UTC+3
    "Asia/Dubai",                # UTC+4, UAE
    "Asia/Karachi",              # UTC+5, Pakistan
    "Asia/Kolkata",              # UTC+5:30, India
    "Asia/Dhaka",                # UTC+6, Bangladesh
    "Asia/Jakarta",              # UTC+7, Indonesia
    "Asia/Shanghai",             # UTC+8, China
    "Asia/Tokyo",                # UTC+9, Japan
    "Australia/Adelaide",        # UTC+9:30
    "Australia/Sydney",          # UTC+10
    "Pacific/Noumea",            # UTC+11, New Caledonia
    "Pacific/Auckland",          # UTC+12, New Zealand
    "Pacific/Kiritimati"         # UTC+14, Line Islands (earliest time zone)
  ]
end
