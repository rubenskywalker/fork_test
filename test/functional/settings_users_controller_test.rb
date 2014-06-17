require 'test_helper'

class SettingsUsersControllerTest < ActionController::TestCase
  setup do
    @settings_user = settings_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:settings_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create settings_user" do
    assert_difference('SettingsUser.count') do
      post :create, settings_user: {  }
    end

    assert_redirected_to settings_user_path(assigns(:settings_user))
  end

  test "should show settings_user" do
    get :show, id: @settings_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @settings_user
    assert_response :success
  end

  test "should update settings_user" do
    put :update, id: @settings_user, settings_user: {  }
    assert_redirected_to settings_user_path(assigns(:settings_user))
  end

  test "should destroy settings_user" do
    assert_difference('SettingsUser.count', -1) do
      delete :destroy, id: @settings_user
    end

    assert_redirected_to settings_users_path
  end
end
