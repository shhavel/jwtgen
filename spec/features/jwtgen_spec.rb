require "spec_helper"
require "clipboard"

RSpec.describe "CLI", type: :aruba do
  context "with invalid options" do
    context "invalid email" do
      before do
        run "jwtgen --key my$ecretK3y --algorithm HS512 "\
            "--payload user_id=1123,email=INVALID,first_name=Jack,last_name=Hackett"
      end

      it "exits with status 1 and prints error message" do
        expect(last_command_started).to have_exit_status(1)
        expect(last_command_started).to have_output "** Error occurred: Email is invalid. Get help: jwtgen --help"
      end
    end

    context "unknown algorithm" do
      before do
        run "jwtgen --key my$ecretK3y --algorithm UNKNOWN "\
            "--payload user_id=1123,email=jack.hackett@example.com,first_name=Jack,last_name=Hackett"
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
          "--payload user_id=1123,email=jack.hackett@example.com,first_name=Jack,last_name=Hackett"
    end

    it "generates JWT and copies it into clipboard" do
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output "The JWT has been copied to your clipboard!"
      decoded_payload = JWT.decode(Clipboard.paste, "my$ecretK3y", true, algorithm: "HS512").first
      expect(decoded_payload).to eq({
        "user_id"=>"1123",
        "email"=>"jack.hackett@example.com",
        "first_name"=>"Jack",
        "last_name"=>"Hackett"})
    end
  end

  context "usage instructions" do
    before do
      run "jwtgen --help"
    end

    it "generates JWT and copies it into clipboard" do
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output <<-EOF.gsub(/^ {8}/, '').chomp
        Usage: jwtgen [options]
                --payload key1=value1,key2=value2,key3=value3
                                             JWT payload. Required keys: `user_id` and `email`.
                --separator SEPARATOR        Payload key-value separator (default "=")
                --key KEY                    HMAC secret key
                --algorithm ALGORITHM        Cryptographic hash algorithm, one of: none, HS256 HS512256 HS384 HS512
      EOF
    end
  end
end
