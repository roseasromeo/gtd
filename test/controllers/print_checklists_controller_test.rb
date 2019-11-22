require 'test_helper'

class PrintChecklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @print_checklist = print_checklists(:one)
  end

  test "should get index" do
    get print_checklists_url
    assert_response :success
  end

  test "should get new" do
    get new_print_checklist_url
    assert_response :success
  end

  test "should create print_checklist" do
    assert_difference('PrintChecklist.count') do
      post print_checklists_url, params: { print_checklist: { description: @print_checklist.description, name: @print_checklist.name, user_id: @print_checklist.user_id } }
    end

    assert_redirected_to print_checklist_url(PrintChecklist.last)
  end

  test "should show print_checklist" do
    get print_checklist_url(@print_checklist)
    assert_response :success
  end

  test "should get edit" do
    get edit_print_checklist_url(@print_checklist)
    assert_response :success
  end

  test "should update print_checklist" do
    patch print_checklist_url(@print_checklist), params: { print_checklist: { description: @print_checklist.description, name: @print_checklist.name, user_id: @print_checklist.user_id } }
    assert_redirected_to print_checklist_url(@print_checklist)
  end

  test "should destroy print_checklist" do
    assert_difference('PrintChecklist.count', -1) do
      delete print_checklist_url(@print_checklist)
    end

    assert_redirected_to print_checklists_url
  end
end
