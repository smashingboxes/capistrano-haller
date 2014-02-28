require 'minitest/autorun'
require 'haller'

class TestHaller < Minitest::Unit::TestCase
  def setup
    @haller = Haller.new('testkey')
  end

  def test_fails_softly_on_network_error
    Net::HTTP.stub :new, mock_broken_http do
      assert_raises(Haller::HallApiError) { @haller.send_message('anyang!') }
    end
  end

  protected

  def mock_broken_http
    http = Minitest::Mock.new
    http.expect :verify_mode=, nil, [OpenSSL::SSL::VERIFY_NONE]
    http.expect :use_ssl=, nil, [true]

    def http.request(req)
      raise SocketError
    end

    return http
  end
end
