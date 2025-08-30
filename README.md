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
- [x] Add ability to add sets to workout instances inside of workout sessions
- [x] Create user config object, contains preferred units of each type. Short distance (m, ft), long distance (km, mi), and weight (kg, lbs)
- [x] Tie units to user config instead, so they don't have to put the unit in every set. Plus, workouts aren't gonna change units between sets anyway.
- [x] Complete form for `new_from_templates` so that they are submitted through `create_from_templates`
- [x] Add cancel button when about to add workout instance but change your mind
- [x] Make a conditional in the set form such that it checks what unit is being used, then puts that form field with the right attribute name (amount_metric or amount_imp)
- [x] When set is about to be created, it will have an empty field of the _other_ metric so I'll want to fill that in with a conversion (e.g. lb -> kg)
- [x] Add content to _workout.html.erb so that it shows up in the workout list page
- [ ] Make cards scale correctly when zooming
- [ ] Add a "sort by" section for workouts that does a serverside sort. Maybe filter by tags. Maybe a drop down could be added to add it to an existing workout session
- [ ] Make it so that workout sessions can't be "completed" unless there's at least 1 workout, and all workouts have at least 1 set
- [ ] Add ability to add and remove sets from workout instances inside of workout sessions
- [ ] For later: maybe auto create sets from previous completed workout?
- [ ] Look into chartjs - might be good for show workout, where it charts all previous workout instances
- [ ] Have logic requiring that workout names must be unique per-user
- [ ] Maybe make sessions taggable just like workouts. Perhaps we can use the pattern "taggable" and make workouttags more general?
- [ ] Consider having another User model called TempUser, which can eventually be turned into a real user when they sign up. Maybe they share a concern or something?
- [ ] Low prio, might be worth making tag names unique. Remember tags are pre-generated though so probably won't be an issue for a while

## Bugs
- [x] Add workout instance has strange behavior when looking at all workout sessions
- [x] Fix issue where selecting a template doesn't create the correct template. Issue is in the new_from_template controller function and the form generated from it.
- [x] Fix issue where workout templates only insert the first instance of a selection in the form. (issue was just that I didn't seed the database)
- [ ] Form doesn't reset when adding a workout set. Might actually be a good feature but worth cleaning up anyway
