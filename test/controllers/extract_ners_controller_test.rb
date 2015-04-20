require 'test_helper'

class ExtractNersControllerTest < ActionController::TestCase
  setup do
    @extract_ner = extract_ners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:extract_ners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create extract_ner" do
    assert_difference('ExtractNer.count') do
      post :create, extract_ner: { file_dir: @extract_ner.file_dir, fname_base: @extract_ner.fname_base, status: @extract_ner.status, status: @extract_ner.status }
    end

    assert_redirected_to extract_ner_path(assigns(:extract_ner))
  end

  test "should show extract_ner" do
    get :show, id: @extract_ner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @extract_ner
    assert_response :success
  end

  test "should update extract_ner" do
    patch :update, id: @extract_ner, extract_ner: { file_dir: @extract_ner.file_dir, fname_base: @extract_ner.fname_base, status: @extract_ner.status, status: @extract_ner.status }
    assert_redirected_to extract_ner_path(assigns(:extract_ner))
  end

  test "should destroy extract_ner" do
    assert_difference('ExtractNer.count', -1) do
      delete :destroy, id: @extract_ner
    end

    assert_redirected_to extract_ners_path
  end
end
