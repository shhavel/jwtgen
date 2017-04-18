shared_examples "JWT generator" do |opts, token, decoded_token_payload|
  let(:gen) { Jwtgen.new(opts) }
  subject { gen.encode }
  let(:key) { opts[:key] }
  let(:algorithm) { opts.fetch(:algorithm, 'none') }

  it "generates JSON Web Token" do
    should eq(token)
  end

  it "can be deencoded to expected hash" do
    decoded_token = if algorithm == 'none'
                      JWT.decode subject, nil, false
                    else
                      JWT.decode subject, key, true, algorithm: algorithm
                    end
    expect(decoded_token.first).to eq(decoded_token_payload)
  end
end
