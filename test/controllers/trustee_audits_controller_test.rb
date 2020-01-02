require 'test_helper'

class TrusteeAuditsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get trustee_audits_index_url
    assert_response :success
  end

  test "should get show" do
    get trustee_audits_show_url
    assert_response :success
  end

  test "should get new" do
    get trustee_audits_new_url
    assert_response :success
  end

  test "should get create" do
    get trustee_audits_create_url
    assert_response :success
  end

  test "should get edit" do
    get trustee_audits_edit_url
    assert_response :success
  end

  test "should get update" do
    get trustee_audits_update_url
    assert_response :success
  end

  test "should get destroy" do
    get trustee_audits_destroy_url
    assert_response :success
  end

  test "should get pdf" do
    get trustee_audits_pdf_url
    assert_response :success
  end

end
