require 'spec_helper'

describe 'get /users/:pattern' do
  it 'should return the users list'
  it 'should return an empty array if no user was found'
end

describe 'get /user/:username' do
  it 'should return the user\'s info'
  it 'should respond with a 404 if the user was not found'
end

describe 'get /repo/:pattern' do
  it 'should return the repos list'
  it 'should return an empty array if no repo was found'
end

describe 'get /repo/:username/:pattern' do
  it 'should return the specified user\'s repos list'
  it 'should return an empty array if the user has no repo'
  it 'should respond with a 404 if the user was not found'
end
