# Validates that the password is strong.
class PasswordIsStrongValidator < ActiveModel::EachValidator
  #
  # CONSTANTS
  #

  # Known passwords that should NOT be allowed and should be considered weak.
  COMMON_PASSWORDS = %w{
      password pass root admin metasploit
      msf 123456 qwerty abc123 letmein monkey link182 demo
      changeme test1234 rapid7
    }

  # Special characters that are considered to strength passwords and are required once in a strong password.
  SPECIAL_CHARS = %q{!@"#$%&'()*+,-./:;<=>?[\\]^_`{|}~ }

  # Validates that the `attribute`'s `value` on `record` contains letters, numbers, and at least one special character
  # without containing the `record.username`, any {COMMON_PASSWORDS} or repetition.
  #
  # @param record [#errors, #username, ApplicationRecord] ActiveModel or ActiveRecord that supports #username method.
  # @param attribute [Symbol] password attribute name.
  # @param value [String] a password.
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank?

    if is_simple?(value)
      record.errors.add attribute, 'must contain letters, numbers, and at least one special character'
    end

    if !record.username.blank? && contains_username?(record.username, value)
      record.errors.add attribute, 'must not contain the username'
    end

    if is_common_password?(value)
      record.errors.add attribute, 'must not be a common password'
    end

    if is_only_repetition?(value)
      record.errors.add attribute, 'must not be a predictable sequence of characters'
    end
  end

  private

  # Returns whether the password is simple.
  #
  # @return [false] if password contains a letter, digit and special character.
  # @return [true] otherwise
  def is_simple?(password)
    not (password =~ /[A-Za-z]/ and password =~ /[0-9]/ and password =~ /[#{Regexp.escape(SPECIAL_CHARS)}]/)
  end

  # Returns whether username is in password (case-insensitively).
  #
  # @return [true] if `username` is in `password`.
  # @return [false] unless `username` is in `password`.
  def contains_username?(username, password)
    !!(password =~ /#{username}/i)
  end

  # Returns whether `password` is in {COMMON_PASSWORDS} or a simple variation of a password in {COMMON_PASSWORDS}.
  #
  # @param password [String]
  # @return [Boolean]
  def is_common_password?(password)
    COMMON_PASSWORDS.each do |pw|
      common_pw = [pw] # pw + "!", pw + "1", pw + "12", pw + "123", pw + "1234"]
      common_pw += mutate_pass(pw)
      common_pw.each do |common_pass|
        if password.downcase =~ /#{common_pass}[\d!]*/
          return true
        end
      end
    end
    false
  end

  # Returns a leet mutated variant of the original password
  #
  # @param password [String]
  # @return [String] containing the password with leet mutations
  def mutate_pass(password)
    mutations = {
        'a' => '@',
        'o' => '0',
        'e' => '3',
        's' => '$',
        't' => '7',
        'l' => '1'
    }

    iterations = mutations.keys.dup
    results = []

    # Find PowerSet of all possible mutation combinations
    iterations = iterations.inject([[]]){|c,y|r=[];c.each{|i|r<<i;r<<i+[y]};r}

    # Iterate through combinations to create each possible mutation
    iterations.each do |iteration|
      next if iteration.flatten.empty?
      first = iteration.shift
      intermediate = password.gsub(/#{first}/i, mutations[first])
      iteration.each do |mutator|
        next unless mutator.kind_of? String
        intermediate.gsub!(/#{mutator}/i, mutations[mutator])
      end
      results << intermediate
    end

    return results
  end


  # Returns whether `password` is only composed of repetitions
  #
  # @param password [String]
  # @return [Boolean]
  def is_only_repetition?(password)
    # Password repetition (quite basic) -- no "aaaaaa" or "ababab" or "abcabc" or
    # "abcdabcd" (but note that the user can use "aaaaaab" or something).

    if password.scan(/./).uniq.size < 2
      return true
    end

    if (password.size % 2 == 0) and (password.scan(/../).uniq.size < 2)
      return true
    end

    if (password.size % 3 == 0) and (password.scan(/.../).uniq.size < 2)
      return true
    end

    if (password.size % 4 == 0) and (password.scan(/..../).uniq.size < 2)
      return true
    end

    false
  end
end
