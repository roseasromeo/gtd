require "application_system_test_case"

class ChecklistsTest < ApplicationSystemTestCase
  setup do
    @checklist = checklists(:one)
  end

  test "visiting the index" do
    visit checklists_url
    assert_selector "h1", text: "Checklists"
  end

  test "creating a Checklist" do
    visit checklists_url
    click_on "New Checklist"

    fill_in "Description", with: @checklist.description
    fill_in "Name", with: @checklist.name
    fill_in "User", with: @checklist.user_id
    click_on "Create Checklist"

    assert_text "Checklist was successfully created"
    click_on "Back"
  end

  test "updating a Checklist" do
    visit checklists_url
    click_on "Edit", match: :first

    fill_in "Description", with: @checklist.description
    fill_in "Name", with: @checklist.name
    fill_in "User", with: @checklist.user_id
    click_on "Update Checklist"

    assert_text "Checklist was successfully updated"
    click_on "Back"
  end

  test "destroying a Checklist" do
    visit checklists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Checklist was successfully destroyed"
  end
end
