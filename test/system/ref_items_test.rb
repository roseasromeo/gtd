require "application_system_test_case"

class RefItemsTest < ApplicationSystemTestCase
  setup do
    @ref_item = ref_items(:one)
  end

  test "visiting the index" do
    visit ref_items_url
    assert_selector "h1", text: "Ref Items"
  end

  test "creating a Ref item" do
    visit ref_items_url
    click_on "New Ref Item"

    fill_in "Description", with: @ref_item.description
    fill_in "Folder", with: @ref_item.folder_id
    fill_in "Name", with: @ref_item.name
    click_on "Create Ref item"

    assert_text "Ref item was successfully created"
    click_on "Back"
  end

  test "updating a Ref item" do
    visit ref_items_url
    click_on "Edit", match: :first

    fill_in "Description", with: @ref_item.description
    fill_in "Folder", with: @ref_item.folder_id
    fill_in "Name", with: @ref_item.name
    click_on "Update Ref item"

    assert_text "Ref item was successfully updated"
    click_on "Back"
  end

  test "destroying a Ref item" do
    visit ref_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ref item was successfully destroyed"
  end
end
