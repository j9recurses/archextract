require 'test_helper'

class PreprocessesControllerTest < ActionController::TestCase
  setup do
    @preprocess = preprocesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:preprocesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create preprocess" do
    assert_difference('Preprocess.count') do
      post :create, preprocess: {  }
    end

    assert_redirected_to preprocess_path(assigns(:preprocess))
  end

  test "should show preprocess" do
    get :show, id: @preprocess
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @preprocess
    assert_response :success
  end

  test "should update preprocess" do
    patch :update, id: @preprocess, preprocess: {  }
    assert_redirected_to preprocess_path(assigns(:preprocess))
  end

  test "should destroy preprocess" do
    assert_difference('Preprocess.count', -1) do
      delete :destroy, id: @preprocess
    end

    assert_redirected_to preprocesses_path
  end
end
