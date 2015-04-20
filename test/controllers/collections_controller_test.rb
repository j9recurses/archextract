require 'test_helper'

class CollectionsControllerTest < ActionController::TestCase
  setup do
    @collection = collections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:collections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create collection" do
    assert_difference('Collection.count') do
      post :create, collection: { acquisition_date: @collection.acquisition_date, acquisition_source: @collection.acquisition_source, collectin_id: @collection.collectin_id, collection_name: @collection.collection_name, end_date: @collection.end_date, notes: @collection.notes, src_datadir: @collection.src_datadir, start_date: @collection.start_date }
    end

    assert_redirected_to collection_path(assigns(:collection))
  end

  test "should show collection" do
    get :show, id: @collection
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @collection
    assert_response :success
  end

  test "should update collection" do
    patch :update, id: @collection, collection: { acquisition_date: @collection.acquisition_date, acquisition_source: @collection.acquisition_source, collectin_id: @collection.collectin_id, collection_name: @collection.collection_name, end_date: @collection.end_date, notes: @collection.notes, src_datadir: @collection.src_datadir, start_date: @collection.start_date }
    assert_redirected_to collection_path(assigns(:collection))
  end

  test "should destroy collection" do
    assert_difference('Collection.count', -1) do
      delete :destroy, id: @collection
    end

    assert_redirected_to collections_path
  end
end
