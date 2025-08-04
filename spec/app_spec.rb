require_relative 'spec_helper'

describe "App" do
  it "can add 1 + 2" do
    get "/add/1/2"
    expect(last_response.body).to include("3")
  end

  it "can add 2 + 5" do
    get "/add/2/5"
    expect(last_response.body).to include("7")
  end
end
