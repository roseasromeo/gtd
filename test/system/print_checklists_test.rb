require "application_system_test_case"

class PrintChecklistsTest < ApplicationSystemTestCase
  setup do
    @print_checklist = print_checklists(:one)
  end

  test "visiting the index" do
    visit print_checklists_url
    assert_selector "h1", text: "Print Checklists"
  end

  test "creating a Print checklist" do
    visit print_checklists_url
    click_on "New Print Checklist"

    fill_in "Description", with: @print_checklist.description
    fill_in "Name", with: @print_checklist.name
    fill_in "User", with: @print_checklist.user_id
    click_on "Create Print checklist"

    assert_text "Print checklist was successfully created"
    click_on "Back"
  end

  test "updating a Print checklist" do
    visit print_checklists_url
    click_on "Edit", match: :first

    fill_in "Description", with: @print_checklist.description
    fill_in "Name", with: @print_checklist.name
    fill_in "User", with: @print_checklist.user_id
    click_on "Update Print checklist"

    assert_text "Print checklist was successfully updated"
    click_on "Back"
  end

  test "destroying a Print checklist" do
    visit print_checklists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Print checklist was successfully destroyed"
  end
end
