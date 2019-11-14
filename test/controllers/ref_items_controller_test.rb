require 'test_helper'

class RefItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ref_item = ref_items(:one)
  end

  test "should get index" do
    get ref_items_url
    assert_response :success
  end

  test "should get new" do
    get new_ref_item_url
    assert_response :success
  end

  test "should create ref_item" do
    assert_difference('RefItem.count') do
      post ref_items_url, params: { ref_item: { description: @ref_item.description, folder_id: @ref_item.folder_id, name: @ref_item.name } }
    end

    assert_redirected_to ref_item_url(RefItem.last)
  end

  test "should show ref_item" do
    get ref_item_url(@ref_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_ref_item_url(@ref_item)
    assert_response :success
  end

  test "should update ref_item" do
    patch ref_item_url(@ref_item), params: { ref_item: { description: @ref_item.description, folder_id: @ref_item.folder_id, name: @ref_item.name } }
    assert_redirected_to ref_item_url(@ref_item)
  end

  test "should destroy ref_item" do
    assert_difference('RefItem.count', -1) do
      delete ref_item_url(@ref_item)
    end

    assert_redirected_to ref_items_url
  end
end
