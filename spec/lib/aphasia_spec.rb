require 'spec_helper'

describe 'The main API' do
  describe 'Find users' do
    it 'should return an array of users'
    it 'should return an empty array if no user is found'
  end

  describe 'Find repos' do
    it 'should return an array of repos'
    it 'should return an empty array if the user has no repo'
    it 'should return a specific user\' repos if the user\'s specified'
    it 'should raise an exception if the user doesn\'t exist'
  end
end
