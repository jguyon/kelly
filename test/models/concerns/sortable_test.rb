require 'test_helper'

class SortableParent < ActiveRecord::Base
  has_many :sortable_items
end

class SortableItem < ActiveRecord::Base
  include Sortable
  belongs_to :sortable_parent
  sortable_by :sortable_parent
end

class SortableTest < ActiveSupport::TestCase
  setup do
    ActiveRecord::Base.connection.create_table :sortable_parents
    ActiveRecord::Base.connection.create_table :sortable_items do |t|
      t.references :sortable_parent
      t.integer :position
    end

    sortable_parent = SortableParent.create!
    @items = []
    5.times { @items << SortableItem.create!(sortable_parent: sortable_parent) }
  end

  teardown do
    ActiveRecord::Base.connection.drop_table :sortable_items
    ActiveRecord::Base.connection.drop_table :sortable_parents
  end

  test "initializes the position of items" do
    @items.each_with_index do |item, index|
      assert_equal index + 1, item.position
    end
  end

  test "gets next item in the list" do
    assert_equal @items[2], @items[1].next_item
  end

  test "moves item down the list" do
    assert_equal @items[2..3], @items[1].insert_at(4).order(:position)
    @items.each { |item| item.reload }
    assert_equal 1, @items[0].position
    assert_equal 4, @items[1].position
    assert_equal 2, @items[2].position
    assert_equal 3, @items[3].position
    assert_equal 5, @items[4].position
  end

  test "moves item up the list" do
    assert_equal @items[1..2], @items[3].insert_at(2).order(:position)
    @items.each { |item| item.reload }
    assert_equal 1, @items[0].position
    assert_equal 3, @items[1].position
    assert_equal 4, @items[2].position
    assert_equal 2, @items[3].position
    assert_equal 5, @items[4].position
  end

  test "updates position when destroying item" do
    @items[2].destroy
    @items.each { |item| item.reload unless item.id == @items[2].id }
    assert_equal 1, @items[0].position
    assert_equal 2, @items[1].position
    assert_equal 3, @items[3].position
    assert_equal 4, @items[4].position
    assert_equal @items[3..4],
      @items[2].moved_items_after_destroy.order(:position)
  end
end
