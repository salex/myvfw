require 'test_helper'

class MarkupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @markup = markups(:one)
  end

  test "should get index" do
    get markups_url
    assert_response :success
  end

  test "should get new" do
    get new_markup_url
    assert_response :success
  end

  test "should create markup" do
    assert_difference('Markup.count') do
      post markups_url, params: { markup: { active: @markup.active, category: @markup.category, conten: @markup.conten, markup_type: @markup.markup_type, post_id: @markup.post_id, title: @markup.title, user_id: @markup.user_id } }
    end

    assert_redirected_to markup_url(Markup.last)
  end

  test "should show markup" do
    get markup_url(@markup)
    assert_response :success
  end

  test "should get edit" do
    get edit_markup_url(@markup)
    assert_response :success
  end

  test "should update markup" do
    patch markup_url(@markup), params: { markup: { active: @markup.active, category: @markup.category, conten: @markup.conten, markup_type: @markup.markup_type, post_id: @markup.post_id, title: @markup.title, user_id: @markup.user_id } }
    assert_redirected_to markup_url(@markup)
  end

  test "should destroy markup" do
    assert_difference('Markup.count', -1) do
      delete markup_url(@markup)
    end

    assert_redirected_to markups_url
  end
end
