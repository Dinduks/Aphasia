require 'spec_helper'

describe 'GitHubClientMock' do
  describe 'call' do
    before do
      @http_client = GitHubClientMock.new
    end

    it 'should return the response from the file' do
      resp = @http_client.call '/hello/world', File.dirname(__FILE__) + '/../resources/'
      resp.size.should     == 1
      resp['hello'].should == 'world'
    end

    it 'should return an empty hash if no path was given' do
      resp = @http_client.call ''
      resp.should be_empty
    end

    it 'should return an hash' do
      resp = @http_client.call ''
      resp.should be_a Hash
    end
  end
end
