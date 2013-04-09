require "rack/test"
require "sprockets"
require "sprockets/image_compressor"

describe "sprockets integration" do
  include Rack::Test::Methods

  let(:app) do
    Sprockets::Environment.new.tap do |env|
      Sprockets::ImageCompressor::Integration.setup env
      env.append_path "spec/fixtures"
    end
  end
  let(:original_png_size){File.size('spec/fixtures/largepng.png').to_i}

  it "should compress pngs" do
    big_response = get "/largepng.png"
    big_response.headers["Content-Length"].to_i.should < original_png_size
    big_response.headers["Content-Type"].should == 'image/png'
  end

  it "should compress jpgs" do
    big_response = get "/largejpg.jpg"
    small_response = get "/smalljpg.jpg"
    big_response.headers["Content-Length"].should == small_response.headers["Content-Length"]
    big_response.body.should == small_response.body
  end

  it "should still serve text assets" do
    response = get "/test.css"
    response.status.should == 200
  end
end
