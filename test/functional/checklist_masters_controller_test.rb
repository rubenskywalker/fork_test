require 'test_helper'

class ChecklistMastersControllerTest < ActionController::TestCase
  setup do
    @checklist_master = checklist_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checklist_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checklist_master" do
    assert_difference('ChecklistMaster.count') do
      post :create, checklist_master: {  }
    end

    assert_redirected_to checklist_master_path(assigns(:checklist_master))
  end

  test "should show checklist_master" do
    get :show, id: @checklist_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @checklist_master
    assert_response :success
  end

  test "should update checklist_master" do
    put :update, id: @checklist_master, checklist_master: {  }
    assert_redirected_to checklist_master_path(assigns(:checklist_master))
  end

  test "should destroy checklist_master" do
    assert_difference('ChecklistMaster.count', -1) do
      delete :destroy, id: @checklist_master
    end

    assert_redirected_to checklist_masters_path
  end
end
