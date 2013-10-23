### WHEN ###
When /^I visit new games url$/ do
  visit '/games/new'
end

Then /^I fill create a game form fields in$/ do
  fill_in "game_game_type", :with => 'This is a test game'
  fill_in "game_location", :with => 'Test location'
  fill_in "game_time", :with => 'Test time'
  fill_in "game_date", :with => '10/28/2013'
  fill_in "game_name", :with => 'This is a test game title'
  fill_in "game_city", :with => 'This is a test city'
  fill_in "game_state", :with => 'This is a test state'
  fill_in "game_zip", :with => 'This is a test zip'
  fill_in "game_player_max", :with => 'This is a test player max'
  fill_in "game_equipment", :with => 'This is a test piece of equipment'
  click_button "Get this game started!"
end

Then /^I should see a group created successfully message/ do
  page.should have_content "Game was successfully created."
end