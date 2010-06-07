require 'helper'

class TestGrake < Test::Unit::TestCase
  context "The example TaskTree" do
    setup do
      @task1 = ['food','pastry','cupcake']
      @task2 = 'food:pastry:muffin'
      @tasks = TaskTree.new('Tasks')
      @tasks.add_task(@task1, "First example")
      @tasks.add_task(@task2, "Second example")
    end

    should "work with the << alias" do
      @tasks << 'animals:frog'
      assert_equal "animals", @tasks.tree['animals'].name
    end

    should "contain food" do
      assert_equal 1, @tasks.tree.children.size
      assert_equal "food", @tasks.tree.children.first.name
    end

    context "with food" do
      should "contain pastries" do
        assert_equal 1, @tasks.tree['food'].children.size
        assert_equal "pastry", @tasks.tree['food'].children.first.name
        assert_equal 2, @tasks.tree['food']['pastry'].children.size
      end

      should "should not have a description for a category" do
        assert_raise(NoMethodError) do
          @tasks.tree['food'].description
        end
      end

      should "have a description for a leaf" do
        assert_equal "First example", @tasks.tree['food']['pastry']['cupcake'].content.description
      end

    end
  end
end
