require "test_helper"

module OkonomiUiKit
  class FormBuilderTest < ActionView::TestCase
    include OkonomiUiKit::UiHelper

    class TestModel
      include ActiveModel::Model
      attr_accessor :name, :email, :bio, :country, :active, :avatar

      def errors
        @errors ||= ActiveModel::Errors.new(self)
      end

      def self.model_name
        ActiveModel::Name.new(self, nil, "test_model")
      end
    end

    setup do
      @model = TestModel.new(name: "John", email: "john@example.com")
      
      # Mock the SvgIcons to avoid file system dependencies
      @test_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z"/></svg>'
      @original_exist = OkonomiUiKit::SvgIcons.method(:exist?)
      @original_read = OkonomiUiKit::SvgIcons.method(:read)
      
      # Mock icon existence and reading for tests
      test_svg = @test_svg
      OkonomiUiKit::SvgIcons.define_singleton_method(:exist?) { |_| true }
      OkonomiUiKit::SvgIcons.define_singleton_method(:read) { |_| test_svg }
    end

    teardown do
      # Restore original methods
      OkonomiUiKit::SvgIcons.define_singleton_method(:exist?, @original_exist)
      OkonomiUiKit::SvgIcons.define_singleton_method(:read, @original_read)
    end

    test "form builder creates field with block" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.field :name do
          form.text_field :name
        end
      end

      assert_includes form_html, 'name="test_model[name]"'
      assert_includes form_html, 'value="John"'
    end

    test "form builder creates field set" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.field_set do
          form.field :email do
            form.email_field :email
          end
        end
      end

      assert_includes form_html, 'type="email"'
      assert_includes form_html, 'name="test_model[email]"'
      assert_includes form_html, 'value="john@example.com"'
    end

    test "form builder shows field errors" do
      @model.errors.add(:name, "can't be blank")

      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.field :name do
          form.text_field :name
        end
      end

      assert_includes form_html, "can&#39;t be blank"
    end

    test "form builder creates select field" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.field :country do
          form.select :country, [ [ "US", "us" ], [ "UK", "uk" ] ], { prompt: "Select country" }
        end
      end

      assert_includes form_html, "<select"
      assert_includes form_html, 'name="test_model[country]"'
      assert_includes form_html, '<option value="">Select country</option>'
      assert_includes form_html, '<option value="us">US</option>'
    end

    test "form builder creates text area" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.field :bio do
          form.text_area :bio, rows: 3
        end
      end

      assert_includes form_html, "<textarea"
      assert_includes form_html, 'name="test_model[bio]"'
      assert_includes form_html, 'rows="3"'
    end

    test "form builder field with hint option" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.field :name, hint: true do
          form.text_field :name
        end
      end

      # Should render hint trigger
      assert_includes form_html, "Hilfe"
      assert_includes form_html, "x-data"
    end

    test "form builder creates submit button with styling" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.submit "Save"
      end

      assert_includes form_html, '<button name="button" type="submit"'
      assert_includes form_html, ">Save</button>"
      # Should have button styling
      assert_match /class="[^"]*hover:cursor-pointer[^"]*"/, form_html
    end

    test "submit with color option works" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.submit "Create Account", color: :primary
      end

      assert_includes form_html, '<button name="button" type="submit"'
      assert_includes form_html, ">Create Account</button>"
      assert_includes form_html, "bg-primary-600"
    end

    test "submit with custom class option works" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.submit "Delete User", class: "custom-danger-button-classes"
      end

      assert_includes form_html, '<button name="button" type="submit"'
      assert_includes form_html, "custom-danger-button-classes"
      assert_includes form_html, ">Delete User</button>"
      # Custom classes should be appended to default button classes
      assert_includes form_html, "hover:cursor-pointer"
    end

    test "submit with variant option works" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.submit "Save", variant: :outlined, color: :secondary
      end

      assert_includes form_html, '<button name="button" type="submit"'
      assert_includes form_html, ">Save</button>"
      # Should have outlined variant styling
      assert_includes form_html, "border"
    end

    test "submit with icon at start position" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.submit "Save", icon: "heroicons/outline/save"
      end

      assert_includes form_html, '<button name="button" type="submit"'
      assert_includes form_html, "Save"
      # Should include icon SVG
      assert_includes form_html, "<svg"
      # Icon should come before text
      assert form_html.index("<svg") < form_html.index("Save")
    end

    test "submit with icon at end position" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.submit "Continue", icon: { end: "heroicons/outline/arrow-right" }
      end

      assert_includes form_html, '<button name="button" type="submit"'
      assert_includes form_html, "Continue"
      assert_includes form_html, "<svg"
      # Icon should come after text
      assert form_html.index("Continue") < form_html.index("<svg")
    end

    test "submit with icon and custom styling" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.submit "Create Account", icon: "heroicons/outline/user-add", variant: :contained, color: :primary
      end

      assert_includes form_html, '<button name="button" type="submit"'
      assert_includes form_html, "Create Account"
      assert_includes form_html, "<svg"
      # Check for icon-specific classes
      assert_match /size-3\.5/, form_html
      # Check for flex wrapper with gap
      assert_match /inline-flex items-center gap-1\.5/, form_html
    end

    test "form builder creates check box with label" do
      form_html = form_with(model: @model, url: "/test", builder: OkonomiUiKit::FormBuilder) do |form|
        form.check_box_with_label :active, label: "Active user"
      end

      assert_includes form_html, 'type="checkbox"'
      assert_includes form_html, 'name="test_model[active]"'
      assert_includes form_html, "Active user"
    end

    test "form builder creates upload field" do
      # Skip this test as it requires Active Storage setup
      skip "Upload field requires Active Storage setup"
    end
  end
end
