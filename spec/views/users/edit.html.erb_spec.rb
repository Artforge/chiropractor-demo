require 'spec_helper'

describe "users/edit.html.erb" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :email => "MyString",
      :name => "MyString",
      :biography => "MyText",
      :favorite_color => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@user), :method => "post" do
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_name", :name => "user[name]"
      assert_select "textarea#user_biography", :name => "user[biography]"
      assert_select "input#user_favorite_color", :name => "user[favorite_color]"
    end
  end
end
