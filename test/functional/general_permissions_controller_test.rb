require 'test_helper'

class GeneralPermissionsControllerTest < ActionController::TestCase
  setup do
    @general_permission = general_permissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:general_permissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create general_permission" do
    assert_difference('GeneralPermission.count') do
      post :create, general_permission: {  }
    end

    assert_redirected_to general_permission_path(assigns(:general_permission))
  end

  test "should show general_permission" do
    get :show, id: @general_permission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @general_permission
    assert_response :success
  end

  test "should update general_permission" do
    put :update, id: @general_permission, general_permission: {  }
    assert_redirected_to general_permission_path(assigns(:general_permission))
  end

  test "should destroy general_permission" do
    assert_difference('GeneralPermission.count', -1) do
      delete :destroy, id: @general_permission
    end

    assert_redirected_to general_permissions_path
  end
end
