require "application_system_test_case"

class PrintChecklistItemsTest < ApplicationSystemTestCase
  setup do
    @print_checklist_item = print_checklist_items(:one)
  end

  test "visiting the index" do
    visit print_checklist_items_url
    assert_selector "h1", text: "Print Checklist Items"
  end

  test "creating a Print checklist item" do
    visit print_checklist_items_url
    click_on "New Print Checklist Item"

    check "Completed" if @print_checklist_item.completed
    fill_in "Name", with: @print_checklist_item.name
    click_on "Create Print checklist item"

    assert_text "Print checklist item was successfully created"
    click_on "Back"
  end

  test "updating a Print checklist item" do
    visit print_checklist_items_url
    click_on "Edit", match: :first

    check "Completed" if @print_checklist_item.completed
    fill_in "Name", with: @print_checklist_item.name
    click_on "Update Print checklist item"

    assert_text "Print checklist item was successfully updated"
    click_on "Back"
  end

  test "destroying a Print checklist item" do
    visit print_checklist_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Print checklist item was successfully destroyed"
  end
end
