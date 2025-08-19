# Sesh
A Ruby on Rails web app for tracking workouts.

## Requirements
Ruby Version: 3.2 or newer

## How to set up and run
1. `git clone https://github.com/dfebs/sesh.git`
1. `cd sesh`
1. `bundle install`
1. `bin/rails db:setup`
1. `bin/rails server`

## Todo
- [x] Make base partial for sets
- [x] Add weight/distance in sets
- [x] Have session show page allow you to add workout instances. Button with data -> new workout session form
- [x] Show workout instances in session
- [x] Finish up create method for workout instances
- [ ] Add ability to add and remove sets from workout instances inside of workout sessions
- [ ] For later: maybe auto create sets from previous completed workout?
- [ ] Add cancel button when about to add workout instance but change your mind
- [ ] Look into chartjs
- [ ] Have logic requiring that workout names must be unique per-user

## Bugs

