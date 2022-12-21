# frozen_string_literal: true

require_relative 'node'

# Class for managing the instances of nodes in a Binary search tree data structure
class Tree
  attr_accessor :root, :data

  def initialize(array = [])
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  # builds a Binary Search Tree(BST) with node objects
  def build_tree(array)
    return nil if array.empty?

    middle = (array.size - 1) / 2
    root_node = Node.new(array[middle])

    root_node.left = build_tree(array[0...middle])
    root_node.right = build_tree(array[(middle + 1)..-1])

    root_node
  end

  # supplied method from the Odin Project to visualize the BST
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = root)
    return nil if value == node.data

    if value > node.data
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    else
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    end
  end

  def find(value, node = root)
   return node if node.nil? || node.data == value

   if value > node.data
    find(value, node.right)
   else
    find(value, node.left)
   end
  end

  def delete(value, node = root)
    return node if node.nil?

    if value > node.data
      node.right = delete(value, node.right)
    elsif value < node.data
      node.left = delete(value, node.left)
    else
      # if node has 1 child or no children
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      # if node has 2 children
      leftmost_node = leftmost_leaf(node.right)
      node.data = leftmost_node.data
      node.right = delete(leftmost_node.data, node.right)
    end
    node
  end

  def level_order(node = root, queue = [])
    print "#{node.data} "
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?
    return if queue.empty?

    level_order(queue.shift, queue)
  end

  def preorder(node = root)
    # root, left, right
    return if node.nil?

    print "#{node.data} "
    preorder(node.left)
    preorder(node.right)
  end

  def inorder(node = root)
    # left, root, right
    return if node.nil?

    inorder(node.left)
    print "#{node.data} "
    inorder(node.right)
  end

  def postorder(node = root)
    # left, right, root
    return if node.nil?

    postorder(node.left)
    postorder(node.right)
    print "#{node.data} "
  end

  # returns -1 for nodes that do not exist

  def height(node = root)
    unless node.nil? || node == root
      node = (node.instance_of?(Node) ? find(node.data) : find(node))
    end

    return -1 if node.nil?

    [height(node.left), height(node.right)].max + 1
  end

  # returns -1 for nodes that do not exist

  def depth(node = root, parent_node = root, edges = 0)
    return -1 if node.nil?
    return 0 if node == root

   if node < parent_node.data
    edges += 1
    depth(node, parent_node.left, edges)
   elsif node > parent_node.data
    edges += 1
    depth(node, parent_node.right, edges)
   else
    edges
   end
  end

  # returns true if height of left and right subtree does not differ by more than 1

  def balanced?(node = root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return true if (left_height - right_height).abs < 2 && balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance
    self.data = inorder_array
    self.root = build_tree(data)
  end

  private

  def leftmost_leaf(node)
    node = node.left until node.left.nil?

    node
  end

  def inorder_array(node = root, array =[])
    unless node.nil?
      inorder_array(node.left, array)
      array << node.data
      inorder_array(node.right, array)
    end
    array
  end
end

# Driver script

array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)

p tree.balanced?
p tree.preorder
p tree.inorder
p tree.postorder
5.times do
  num = rand(101..200)
  tree.insert(num)
  puts "#{num} added to tree."
end
p tree.balanced?
p tree.rebalance
p tree.balanced?
p tree.preorder
p tree.inorder
p tree.postorder
p tree.pretty_print
