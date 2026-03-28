require "rails_helper"

RSpec.describe Oauth::ClientCredentialsFlow, type: :service do
  let(:client_id) { "some-client-id" }
  let(:grant_type) { "client_credentials" }
  let(:client) { instance_double(Client, id: 123, client_id: client_id, client_secret: "correct-secret") }

  before do
    allow(Client).to receive(:find_by).and_call_original
  end

  subject(:flow) { described_class.new(client_id:, client_secret:, grant_type:) }

  describe "klass_grant_type" do
    it "is set to :client_credentials" do
      expect(described_class.klass_grant_type).to eq(:client_credentials)
    end
  end

  describe "#initialize" do
    let(:client_secret) { "some-client-secret" }

    context "when client_id is missing" do
      let(:client_id) { nil }

      it "raises Errors::InvalidRequest" do
        expect { flow }.to raise_error(Oauth::Errors::InvalidRequest, /client_id and client_secret required/)
      end
    end

    context "when client_secret is missing" do
      let(:client_secret) { nil }

      it "raises Errors::InvalidRequest" do
        expect { flow }.to raise_error(Oauth::Errors::InvalidRequest, /client_id and client_secret required/)
      end
    end

    context "when grant_type does not match klass_grant_type" do
      let(:grant_type) { "authorization_code" }

      it "raises ArgumentError from OauthBase" do
        expect { flow }.to raise_error(ArgumentError, /Invalid grant_type/)
      end
    end

    context "when client_id does not exist" do
      let(:client_id) { "non-existent-client-id" }
      let(:client_secret) { "some-secret" }

      it "raises ActiveRecord::RecordNotFound" do
        expect { flow }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when all parameters are valid" do
      before do
        allow(Client).to receive(:find_by).with(client_id: client_id).and_return(client)
      end

      it "creates the flow successfully" do
        expect { flow }.to_not raise_error
      end

      it "sets the client instance variable" do
        flow
        expect(flow.client).to eq(client)
      end
    end
  end

  describe "#generate_access_token!" do
    let(:client_secret) { "correct-secret" }

    before do
      allow(Client).to receive(:find_by).with(client_id: client_id).and_return(client)
    end

    context "when client_secret is invalid" do
      let(:client_secret) { "wrong-secret" }

      it "raises Errors::InvalidRequest" do
        expect { described_class.new(client_id:, client_secret:, grant_type:).generate_access_token! }.to raise_error(Oauth::Errors::InvalidRequest, /Invalid client_id or client_secret/)
      end
    end

    context "when client_secret is valid" do
      it "returns an AccessToken instance" do
        result = flow.generate_access_token!
        expect(result).to be_a(Oauth::AccessToken)
      end

      it "creates access token with correct client_id" do
        result = flow.generate_access_token!
        expect(result.client_id).to eq(client_id)
      end

      it "creates access token with correct subject" do
        result = flow.generate_access_token!
        expect(result.subject).to eq(client)
      end

      it "creates access token with empty scopes by default" do
        result = flow.generate_access_token!
        expect(result.scopes).to eq([])
      end
    end
  end
end
