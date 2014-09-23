# The types of stances a module can take, such as {PASSIVE} or {AGGRESSIVE}.  Stances indicate whether or not the
# module triggers the vulnerability without waiting for one or more conditions to be met ({AGGRESSIVE}) or whether
# it must wait for certain conditions to be satisfied before the exploit can be initiated ({PASSIVE}).
module Metasploit::Model::Module::Stance
  # The module does actively tries to trigger a vulnerability.
  AGGRESSIVE = 'aggressive'
  # The module doesn't actively attack and waits for interaction from the client or other entity before attempting
  # to trigger a vulnerability
  PASSIVE = 'passive'

  # All stances.
  ALL = [
      AGGRESSIVE,
      PASSIVE
  ]
end
