require 'test_helper'

class ExtractsControllerTest < ActionController::TestCase
  setup do
    @extract = extracts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:extracts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create extract" do
    assert_difference('Extract.count') do
      post :create, extract: { lda: @extract.lda, ner_dates: @extract.ner_dates, ner_organizations: @extract.ner_organizations, ner_people: @extract.ner_people, ner_places: @extract.ner_places, num_of_topics: @extract.num_of_topics }
    end

    assert_redirected_to extract_path(assigns(:extract))
  end

  test "should show extract" do
    get :show, id: @extract
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @extract
    assert_response :success
  end

  test "should update extract" do
    patch :update, id: @extract, extract: { lda: @extract.lda, ner_dates: @extract.ner_dates, ner_organizations: @extract.ner_organizations, ner_people: @extract.ner_people, ner_places: @extract.ner_places, num_of_topics: @extract.num_of_topics }
    assert_redirected_to extract_path(assigns(:extract))
  end

  test "should destroy extract" do
    assert_difference('Extract.count', -1) do
      delete :destroy, id: @extract
    end

    assert_redirected_to extracts_path
  end
end
