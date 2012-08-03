require 'spec_helper'

describe 'Aphasia' do
  describe 'repos' do
    it 'should return an array of repos' do
      repos = Aphasia.repos 'dinduks'
      repos.to_a.size.should == 2
    end

    it 'should return an empty array if the user has no repo' do
      repos = Aphasia.repos 'arepothatdoesntexist'
      repos.to_a.size.should == 0
    end
  end

  describe 'user_repos' do
    it 'should return a specific user\'s repos if the user\'s specified' do
      repos = Aphasia.user_repos 'dinduks'
      repos.to_a.size.should > 0
    end

    it 'should raise an exception if the user doesn\'t exist' do
      expect do
        repos = Aphasia.user_repos 'auserthatdoesntexist'
      end.to raise_error
    end
  end
end
