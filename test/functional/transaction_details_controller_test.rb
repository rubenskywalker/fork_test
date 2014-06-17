require 'test_helper'

class TransactionDetailsControllerTest < ActionController::TestCase
  setup do
    @transaction_detail = transaction_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transaction_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction_detail" do
    assert_difference('TransactionDetail.count') do
      post :create, transaction_detail: {  }
    end

    assert_redirected_to transaction_detail_path(assigns(:transaction_detail))
  end

  test "should show transaction_detail" do
    get :show, id: @transaction_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transaction_detail
    assert_response :success
  end

  test "should update transaction_detail" do
    put :update, id: @transaction_detail, transaction_detail: {  }
    assert_redirected_to transaction_detail_path(assigns(:transaction_detail))
  end

  test "should destroy transaction_detail" do
    assert_difference('TransactionDetail.count', -1) do
      delete :destroy, id: @transaction_detail
    end

    assert_redirected_to transaction_details_path
  end
end
