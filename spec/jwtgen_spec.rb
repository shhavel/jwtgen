require "spec_helper"

RSpec.describe Jwtgen do
  describe ".new" do
    it "requires option payload kind of Hash" do
      expect { Jwtgen.new({}) }.to raise_error ArgumentError, "Option `payload` is required"
      expect { Jwtgen.new(payload: []) }.to raise_error ArgumentError, "Option `payload` is required"
    end

    it "requires payload key user_id" do
      expect { Jwtgen.new(payload: { key1: "value1", key2: "value2" }) }.to raise_error ArgumentError, "Payload key `user_id` is required"
      expect { Jwtgen.new(payload: { key1: "value1", key2: "value2", user_id: nil }) }.to raise_error ArgumentError, "Payload key `user_id` is required"
    end

    it "requires payload key email" do
      expect { Jwtgen.new(payload: { user_id: "1234" }) }.to raise_error ArgumentError, "Payload key `email` is required"
      expect { Jwtgen.new(payload: { user_id: "1234", email: "" }) }.to raise_error ArgumentError, "Payload key `email` is required"
    end

    it "requires valid email" do
      expect { Jwtgen.new(payload: { user_id: "1234", email: "something" }) }.to raise_error ArgumentError, "Email is invalid"
    end
  end

  describe "#encode" do
    it_behaves_like "JWT generator", { payload: { user_id: "12312", email: "syed@thredup.com" } },
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJ1c2VyX2lkIjoiMTIzMTIiLCJlbWFpbCI6InN5ZWRAdGhyZWR1cC5jb20ifQ.",
      "user_id" => "12312",
      "email" => "syed@thredup.com"

    it_behaves_like "JWT generator", { payload: { user_id: "1234", email: "ted.crilly@example.com" } },
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJ1c2VyX2lkIjoiMTIzNCIsImVtYWlsIjoidGVkLmNyaWxseUBleGFtcGxlLmNvbSJ9.",
      "user_id" => "1234",
      "email" => "ted.crilly@example.com"

    it_behaves_like "JWT generator", { payload: { user_id: "1234", email: "ted.crilly@example.com", name: "Teg Crilly" },
        key: "my$ecretK3y", algorithm: "HS256" },
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTIzNCIsImVtYWlsIjoidGVkLmNyaWxseUBleGFtcGxlLmNvbSIsIm5hbWUiOiJUZWcgQ3JpbGx5In0.t-64nnpTEbEm3vFeR4LHbX1zgg_SvSczt5YD6ovwC0M",
      "user_id" => "1234",
      "email" => "ted.crilly@example.com",
      "name" => "Teg Crilly"

    it_behaves_like "JWT generator", { payload: { user_id: "9876", email: "dougal.mcguire@example.com",
        first_name: "Dougal", last_name: "McGuire" },
        key: "37e22f6d707f329d78b1bc07186d4da684a976403ee302b97cd4c024dc478d5e", algorithm: "HS512" },
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoiOTg3NiIsImVtYWlsIjoiZG91Z2FsLm1jZ3VpcmVAZXhhbXBsZS5jb20iLCJmaXJzdF9uYW1lIjoiRG91Z2FsIiwibGFzdF9uYW1lIjoiTWNHdWlyZSJ9.7y1MtRvSb3pJX7cXOEOgnH1pFMy18CC0WWnyjdgz3z6CWuNwUkosWfZYTImk_x34jRzL9prEKtZ762mR3d2L8g",
      "user_id" => "9876",
      "email" => "dougal.mcguire@example.com",
      "first_name" => "Dougal",
      "last_name" => "McGuire"
  end
end
