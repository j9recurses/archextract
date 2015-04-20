require 'test_helper'

class NersControllerTest < ActionController::TestCase
  setup do
    @ner = ners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ner" do
    assert_difference('Ner.count') do
      post :create, ner: { count: @ner.count, docs: @ner.docs, name: @ner.name, nertype: @ner.nertype }
    end

    assert_redirected_to ner_path(assigns(:ner))
  end

  test "should show ner" do
    get :show, id: @ner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ner
    assert_response :success
  end

  test "should update ner" do
    patch :update, id: @ner, ner: { count: @ner.count, docs: @ner.docs, name: @ner.name, nertype: @ner.nertype }
    assert_redirected_to ner_path(assigns(:ner))
  end

  test "should destroy ner" do
    assert_difference('Ner.count', -1) do
      delete :destroy, id: @ner
    end

    assert_redirected_to ners_path
  end
end
