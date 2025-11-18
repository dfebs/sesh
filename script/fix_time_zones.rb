
require_relative "../config/environment"

users = User.where(time_zone: "America/New York")
users.update_all(time_zone: "America/New_York")
