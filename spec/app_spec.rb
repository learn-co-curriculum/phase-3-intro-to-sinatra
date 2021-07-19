describe "App" do
  it "can add 1 + 2" do
    # Make a GET request to the server
    get "/add/1/2"
    # Inspect the body of the response
    expect(last_response.body).to include("3")
  end

  it "can add 2 + 5" do
    # Make a GET request to the server
    get "/add/2/5"
    # Inspect the body of the response
    expect(last_response.body).to include("7")
  end
end
