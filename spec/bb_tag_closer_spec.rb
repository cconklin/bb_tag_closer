require "spec_helper"
class Post < ActiveRecord::Base
  include BBTagCloser
  attr_accessor :body
  close_tags_for :body
  
  def initialize
    @body = ""
  end
end

describe BBTagCloser do
  before(:each) do
    @post = Post.new
  end

  it "should close forum tags" do
    @post.body = "[u]test"
    @post.close_tags
    @post.body.should == "[u]test[/u]"
  end
  
  it "should close multiple forum tags" do
    @post.body = "[u][b]test"
    @post.close_tags
    @post.body.should == "[u][b]test[/b][/u]"
  end

  it "should close complex forum tags" do
    @post.body = "[quote=Fish]test"
    @post.close_tags
    @post.body.should == "[quote=Fish]test[/quote]"
  end
  
  it "should close multiple forum tags of the same type" do
    @post.body = "[u][u]test"
    @post.close_tags
    @post.body.should == "[u][u]test[/u][/u]"
  end

  it "should leave properly closed tags alone" do
    @post.body = "[u][u]test[/u][/u]"
    @post.close_tags
    @post.body.should == "[u][u]test[/u][/u]"
  end
  
  it "should leave properly closed tags alone while closing others" do
    @post.body = "[u][b]test[/u]"
    @post.close_tags
    @post.body.should == "[u][b]test[/u][/b]"
  end
  
end