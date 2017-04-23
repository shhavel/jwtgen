require "spec_helper"
require "clipboard"

RSpec.describe "CLI", type: :aruba do
  context "usage instructions" do
    before do
      run "jwtgen --help"
    end

    it "generates JWT and copies it into clipboard" do
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output <<-EOF.gsub(/^ {8}/, '').chomp
        Usage: jwtgen [options] [arguments]
                arguments                    JWT payload key-value pairs, e.g. key1 value1 key2 value2 key3 value3
                                             Required inputs (keys) are user_id and email.
                --key KEY                    HMAC secret key
                --algorithm ALGORITHM        Cryptographic hash algorithm, one of: none, HS256 HS512256 HS384 HS512
      EOF
    end
  end

  context "with invalid options" do
    context "invalid email" do
      before do
        run "jwtgen --key my$ecretK3y --algorithm HS512 "\
            'user_id 1123 email INVALID name "Dougal McGuire" role Manager'
      end

      it "exits with status 1 and prints error message" do
        expect(last_command_started).to have_exit_status(1)
        expect(last_command_started).to have_output "** Error occurred: Email is invalid. Get help: jwtgen --help"
      end
    end

    context "unknown algorithm" do
      before do
        run "jwtgen --key my$ecretK3y --algorithm UNKNOWN "\
            'user_id 1123 email dougal.mcguire@example.com name "Dougal McGuire" role Manager'
      end

      it "exits with status 1 and prints error message" do
        expect(last_command_started).to have_exit_status(1)
        expect(last_command_started).to have_output include_output_string "invalid"
      end
    end
  end

  context "with valid options" do
    before do
      run "jwtgen --key my$ecretK3y --algorithm HS512 "\
          'user_id 1123 email dougal.mcguire@example.com name "Dougal McGuire" role Manager'
    end

    it "generates JWT and copies it into clipboard" do
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output "The JWT has been copied to your clipboard!"
      decoded_payload = JWT.decode(Clipboard.paste, "my$ecretK3y", true, algorithm: "HS512").first
      expect(decoded_payload).to eq({
        "user_id"=>"1123",
        "email"=>"dougal.mcguire@example.com",
        "name"=>"Dougal McGuire",
        "role"=>"Manager"})
    end
  end

  context "config file" do
    let(:config_file) { File.join(File.expand_path("~"), ".jwtgenrc") }
    before do
      File.open(config_file, "w") do |f|
        f.write "--key 2f27090cf62f34c1dcfd4b1de3809bb8b1ab31f0b376d1cf8c36827f4d5ad2dd\n" \
                "--algorithm HS384"
      end
    end
    after { File.delete(config_file) }

    context "without runtime options" do
      before do
        run 'jwtgen user_id 1234 email ted.crillyre@example.com name "Ted Crilly" role User'
      end

      it "uses config file to get default options" do
        expect(last_command_started).to be_successfully_executed
        expect(last_command_started).to have_output "The JWT has been copied to your clipboard!"
        decoded_payload = JWT.decode(Clipboard.paste, "2f27090cf62f34c1dcfd4b1de3809bb8b1ab31f0b376d1cf8c36827f4d5ad2dd", true,
                                           algorithm: "HS384").first
        expect(decoded_payload).to eq({
          "user_id"=>"1234",
          "email"=>"ted.crillyre@example.com",
          "name"=>"Ted Crilly",
          "role"=>"User"})
      end
    end

    context "with runtime options" do
      before do
        run "jwtgen --key my$ecretK3y --algorithm HS512 "\
            'user_id 1234 email ted.crillyre@example.com name "Ted Crilly" role User'
      end

      specify "supplied options have higher precedence than options stored in config file" do
        expect(last_command_started).to be_successfully_executed
        expect(last_command_started).to have_output "The JWT has been copied to your clipboard!"
        decoded_payload = JWT.decode(Clipboard.paste, "my$ecretK3y", true, algorithm: "HS512").first
        expect(decoded_payload).to eq({
          "user_id"=>"1234",
          "email"=>"ted.crillyre@example.com",
          "name"=>"Ted Crilly",
          "role"=>"User"})
      end
    end
  end
end
