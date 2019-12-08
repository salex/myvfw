require "application_system_test_case"

class MarkupsTest < ApplicationSystemTestCase
  setup do
    @markup = markups(:one)
  end

  test "visiting the index" do
    visit markups_url
    assert_selector "h1", text: "Markups"
  end

  test "creating a Markup" do
    visit markups_url
    click_on "New Markup"

    check "Active" if @markup.active
    fill_in "Category", with: @markup.category
    fill_in "Conten", with: @markup.conten
    fill_in "Markup type", with: @markup.markup_type
    fill_in "Post", with: @markup.post_id
    fill_in "Title", with: @markup.title
    fill_in "User", with: @markup.user_id
    click_on "Create Markup"

    assert_text "Markup was successfully created"
    click_on "Back"
  end

  test "updating a Markup" do
    visit markups_url
    click_on "Edit", match: :first

    check "Active" if @markup.active
    fill_in "Category", with: @markup.category
    fill_in "Conten", with: @markup.conten
    fill_in "Markup type", with: @markup.markup_type
    fill_in "Post", with: @markup.post_id
    fill_in "Title", with: @markup.title
    fill_in "User", with: @markup.user_id
    click_on "Update Markup"

    assert_text "Markup was successfully updated"
    click_on "Back"
  end

  test "destroying a Markup" do
    visit markups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Markup was successfully destroyed"
  end
end
