# Methods for use with the SNAILS DID method
# 
# Code pieces shamelessly yanked from:
# https://learnmeabitcoin.com/glossary/base58
#
# 32bit key generation:
# k = Snail.generate_key
#
# encode key to base58:
# b = Snail.base58_encode(k)
#
# map to a lockbox code:
# lock = Snail.lockbox(b)
module Snail

  @chars = %w[
      1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
]
  @base = @chars.length

  # creates a base58 encoded address
  def self.base58_encode(hex)
    i = hex.to_i(16)
    buffer = String.new

    while i > 0
      remainder = i % @base
      i = i / @base
      buffer = @chars[remainder] + buffer
    end

    # add '1's to the start based on number of leading bytes of zeros
    leading_zero_bytes = (hex.match(/^([0]+)/) ? $1 : '').size / 2

    ("1"*leading_zero_bytes) + buffer
  end

  # maps base58 key to a lockbox code 
  def self.lockbox(base58, key_space = 999)
    result = ""
    base58.each_byte do |c|
      result << c.to_s
    end
    result.to_i % key_space
  end

  # generates a 32bit private key
  def self.generate_key
    urandom = File.open("/dev/urandom") 
    bytes = urandom.read(32)
    privatekey = bytes.unpack("H*")[0] 
    privatekey
  end
end
