require 'test_helper'

class ChecklistPermissionsControllerTest < ActionController::TestCase
  setup do
    @checklist_permission = checklist_permissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checklist_permissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checklist_permission" do
    assert_difference('ChecklistPermission.count') do
      post :create, checklist_permission: {  }
    end

    assert_redirected_to checklist_permission_path(assigns(:checklist_permission))
  end

  test "should show checklist_permission" do
    get :show, id: @checklist_permission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @checklist_permission
    assert_response :success
  end

  test "should update checklist_permission" do
    put :update, id: @checklist_permission, checklist_permission: {  }
    assert_redirected_to checklist_permission_path(assigns(:checklist_permission))
  end

  test "should destroy checklist_permission" do
    assert_difference('ChecklistPermission.count', -1) do
      delete :destroy, id: @checklist_permission
    end

    assert_redirected_to checklist_permissions_path
  end
end
