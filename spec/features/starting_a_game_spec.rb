require 'spec_helper'

feature 'Starting a new game' do
  scenario 'asks the user for their name' do
    visit '/'
    click_link 'New Game'
    expect(page).to have_content "What's your name?"
  end

  scenario 'allows the user to input their name' do
    visit '/Start'
    fill_in('name', with: 'Bob')
    click_button('Submit')
    expect(page).to have_content "Welcome to Battleships, Bob!"
  end

  scenario 'does not allow name field to be submitted if blank' do
    visit '/Start'
    click_button('Submit')
    expect(page).to have_content "Please fill in your name"
  end

  scenario 'the new game page should have a board' do
    visit '/New_Game?name=Bob'
    expect(page).to have_content(
  'ABCDEFGHIJ
  ------------
 1|          |1
 2|          |2
 3|          |3
 4|          |4
 5|          |5
 6|          |6
 7|          |7
 8|          |8
 9|          |9
10|          |10
  ------------
   ABCDEFGHIJ')
  end

  scenario 'the page should prompt user to place a ship' do
    visit '/New_Game?name=Bob'
    expect(page).to have_content('Please place a ship')
  end

  scenario 'allows the user to enter a valid ship' do
    visit '/New_Game?name=Bob'
    select 'Submarine', from: 'ship'
    fill_in('coordinates', with: 'A1')
    #fill_in('orientation', with: 'horizontally')
    select "Vertical", from: "orientation"
    click_button('Submit')
    expect(page).to have_content(
   'ABCDEFGHIJ
  ------------
 1|S         |1
 2|          |2
 3|          |3
 4|          |4
 5|          |5
 6|          |6
 7|          |7
 8|          |8
 9|          |9
10|          |10
  ------------
   ABCDEFGHIJ')

  end

  scenario 'ship orientation contains a dropdown' do
    visit '/New_Game?name=Bob'
    expect(page).to have_selector('select')
  end

end