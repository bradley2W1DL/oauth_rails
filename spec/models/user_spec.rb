require "rails_helper"

RSpec.describe User, type: :model do
  describe ".find_by_factor" do
    context "when username matches" do
      it "returns matching user"
    end

    context "when email matches" do
      it "returns matching user"
    end

    context "when factor doesn't match any Users" do
      it "returns nil"
    end

    context "when multiple users are returned" do
      it "raises an error"
    end
  end
end
