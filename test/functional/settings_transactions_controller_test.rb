require 'test_helper'

class SettingsTransactionsControllerTest < ActionController::TestCase
  setup do
    @settings_transaction = settings_transactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:settings_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create settings_transaction" do
    assert_difference('SettingsTransaction.count') do
      post :create, settings_transaction: {  }
    end

    assert_redirected_to settings_transaction_path(assigns(:settings_transaction))
  end

  test "should show settings_transaction" do
    get :show, id: @settings_transaction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @settings_transaction
    assert_response :success
  end

  test "should update settings_transaction" do
    put :update, id: @settings_transaction, settings_transaction: {  }
    assert_redirected_to settings_transaction_path(assigns(:settings_transaction))
  end

  test "should destroy settings_transaction" do
    assert_difference('SettingsTransaction.count', -1) do
      delete :destroy, id: @settings_transaction
    end

    assert_redirected_to settings_transactions_path
  end
end
