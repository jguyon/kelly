module Sortable
  extend ActiveSupport::Concern

  class_methods do
    def sortable_by(association)
      define_method :list_scope do
        column = :"#{association}_id"
        self.class.where(column => self[column])
      end
    end
  end

  included do
    before_create :add_to_list_bottom
    after_destroy :decrement_position_on_lower_items
  end

  def next_item
    column = self.class.arel_table[:position]
    list_scope.where(column.gt(position)).order(:position).first
  end

  # Change the position of the item, update the position of the other items
  # accordingly and return a scope of the moved items
  def insert_at(new_position)
    return if new_record?

    old_position = position
    new_position = new_position.to_i
    return if old_position == new_position

    column = self.class.arel_table[:position]
    if old_position < new_position
      list_scope.
        where(column.gt(old_position)).
        where(column.lteq(new_position)).
        update_all('position = position - 1')
      updated_scope = list_scope.
        where(column.gteq(old_position)).
        where(column.lt(new_position))
    else
      list_scope.
        where(column.lt(old_position)).
        where(column.gteq(new_position)).
        update_all('position = position + 1')
      updated_scope = list_scope.
        where(column.lteq(old_position)).
        where(column.gt(new_position))
    end
    update_attribute :position, new_position

    updated_scope
  end

  # Return a scope of the items that were moved during destroy
  def moved_items_after_destroy
    return unless destroyed?
    column = self.class.arel_table[:position]
    list_scope.where(column.gteq(position))
  end

  private

    def add_to_list_bottom
      self.position = list_scope.count + 1
    end

    def decrement_position_on_lower_items
      column = self.class.arel_table[:position]
      list_scope.
        where(column.gt(position)).
        update_all('position = position - 1')
    end
end
