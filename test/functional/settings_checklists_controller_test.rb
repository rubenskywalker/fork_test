require 'test_helper'

class SettingsChecklistsControllerTest < ActionController::TestCase
  setup do
    @settings_checklist = settings_checklists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:settings_checklists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create settings_checklist" do
    assert_difference('SettingsChecklist.count') do
      post :create, settings_checklist: {  }
    end

    assert_redirected_to settings_checklist_path(assigns(:settings_checklist))
  end

  test "should show settings_checklist" do
    get :show, id: @settings_checklist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @settings_checklist
    assert_response :success
  end

  test "should update settings_checklist" do
    put :update, id: @settings_checklist, settings_checklist: {  }
    assert_redirected_to settings_checklist_path(assigns(:settings_checklist))
  end

  test "should destroy settings_checklist" do
    assert_difference('SettingsChecklist.count', -1) do
      delete :destroy, id: @settings_checklist
    end

    assert_redirected_to settings_checklists_path
  end
end
