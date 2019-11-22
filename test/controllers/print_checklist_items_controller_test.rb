require 'test_helper'

class PrintChecklistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @print_checklist_item = print_checklist_items(:one)
  end

  test "should get index" do
    get print_checklist_items_url
    assert_response :success
  end

  test "should get new" do
    get new_print_checklist_item_url
    assert_response :success
  end

  test "should create print_checklist_item" do
    assert_difference('PrintChecklistItem.count') do
      post print_checklist_items_url, params: { print_checklist_item: { completed: @print_checklist_item.completed, name: @print_checklist_item.name } }
    end

    assert_redirected_to print_checklist_item_url(PrintChecklistItem.last)
  end

  test "should show print_checklist_item" do
    get print_checklist_item_url(@print_checklist_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_print_checklist_item_url(@print_checklist_item)
    assert_response :success
  end

  test "should update print_checklist_item" do
    patch print_checklist_item_url(@print_checklist_item), params: { print_checklist_item: { completed: @print_checklist_item.completed, name: @print_checklist_item.name } }
    assert_redirected_to print_checklist_item_url(@print_checklist_item)
  end

  test "should destroy print_checklist_item" do
    assert_difference('PrintChecklistItem.count', -1) do
      delete print_checklist_item_url(@print_checklist_item)
    end

    assert_redirected_to print_checklist_items_url
  end
end
