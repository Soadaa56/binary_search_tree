# frozen_string_literal: true
 
# Class to create and manage nodes for binary tree
class Node
  attr_accessor :data, :left, :right
  
  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end

  def print
    puts @data
  end
end