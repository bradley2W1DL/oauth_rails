require "rails_helper"

RSpec.describe Oauth::OauthBase, type: :service do
  subject(:base_instance) { described_class.new(grant_type: :authorization_code) }

  describe "klass_grant_type" do
    it "defaults to nil on the base class" do
      expect(described_class.klass_grant_type).to be_nil
    end
  end

  describe "#initialize" do
    context "when subclass does not define klass_grant_type" do
      it "raises NotImplementedError" do
        expect { base_instance }.to raise_error(NotImplementedError, /klass_grant_type must be defined in subclass/)
      end
    end

    context "when subclass defines klass_grant_type" do
      let(:subclass) do
        # Class.new(parent_class) creates an anonymous class equivalent to `class SubClass < ParentClass`
        Class.new(described_class) do
          self.klass_grant_type = :authorization_code

          def generate_access_token!
            "token"
          end
        end
      end

      it "allows initialization with matching grant_type" do
        expect { subclass.new(grant_type: "authorization_code") }.to_not raise_error
      end

      it "raises ArgumentError with mismatched grant_type" do
        expect { subclass.new(grant_type: "client_credentials") }.to raise_error(
          ArgumentError,
          /Invalid grant_type: client_credentials passed to/
        )
      end
    end

    context "when subclass overrides klass_grant_type" do
      let(:parent_class) do
        Class.new(described_class) do
          self.klass_grant_type = :authorization_code
          def generate_access_token!
          end
        end
      end

      let(:child_class) do
        Class.new(parent_class) do
          self.klass_grant_type = :client_credentials
          def generate_access_token!
          end
        end
      end

      it "allows child class to override the grant type" do
        expect(parent_class.klass_grant_type).to eq(:authorization_code)
        expect(child_class.klass_grant_type).to eq(:client_credentials)
      end
    end
  end

  describe "#generate_access_token!" do
    let(:subclass) do
      Class.new(described_class) do
        self.klass_grant_type = :authorization_code
      end
    end

    it "raises NotImplementedError" do
      expect { subclass.new(grant_type: "authorization_code").generate_access_token! }
        .to raise_error(NotImplementedError, /generate_access_token! not implemented in/)
    end
  end
end
