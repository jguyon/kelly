require 'test_helper'

class TakeTest < ActiveSupport::TestCase
  setup do
    @take = takes(:john_physics)
  end

  test "gets current entry" do
    assert_equal entries(:john_physics_three), @take.current_entry
    @take.entries.destroy_all
    assert_nil @take.current_entry
  end

  test "creates next entry" do
    assert_no_difference 'Entry.count' do
      assert_nil @take.next_entry
      assert_equal 1, @take.score
      assert_not_nil @take.finished_at
    end

    @take.entries.last.destroy
    assert_difference '@take.entries.count' do
      next_entry = @take.next_entry
      assert_equal questions(:physics_three), next_entry.question
    end

    @take.entries.destroy_all
    assert_difference '@take.entries.count' do
      next_entry = @take.next_entry
      assert_equal questions(:physics_one), next_entry.question
    end
  end
end
