require 'spec_helper'

describe "users/new.html.erb" do
  before(:each) do
    assign(:user, stub_model(User,
      :email => "MyString",
      :name => "MyString",
      :biography => "MyText",
      :favorite_color => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_name", :name => "user[name]"
      assert_select "textarea#user_biography", :name => "user[biography]"
      assert_select "input#user_favorite_color", :name => "user[favorite_color]"
    end
  end
end
