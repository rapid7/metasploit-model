# Metasploit::Model [![Build Status](https://travis-ci.org/rapid7/metasploit-model.png?branch=feature/exploit)](https://travis-ci.org/rapid7/metasploit-model)[![Coverage Status](https://coveralls.io/repos/rapid7/metasploit-model/badge.png?branch=feature%2Fexploit)](https://coveralls.io/r/rapid7/metasploit-model?branch=feature%2Fexploit)

## Versioning

`Metasploit::Model` is versioned using [semantic versioning 2.0](http://semver.org/spec/v2.0.0.html).  Each branch should set `Metasploit::Model::Version::PRERELEASE` to the branch SUMMARY, while master should have no `PRERELEASE` and the `PRERELEASE` section of `Metasploit::Model::VERSION` does not exist.

## Installation

Add this line to your application's Gemfile:

    gem 'metasploit-model'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metasploit-model

## Usage

TODO: Write usage instructions here

## Contributing

### Forking

[Fork this repository](https://github.com/rapid7/metasploit-model/fork)

### Branching

Branch names follow the format `TYPE/ISSUE/SUMMARY`.  You can create it with `git checkout -b TYPE/ISSUE/SUMMARY`.

#### `TYPE`

`TYPE` can be `bug`, `chore`, or `feature`.

#### `ISSUE`

`ISSUE` is either a [Github issue](https://github.com/rapid7/metasploit-model/issues) or an issue from some other
issue tracking software.

#### `SUMMARY`

`SUMMARY` is is short summary of the purpose of the branch composed of lower case words separated by '-' so that it is a valid `PRERELEASE` for the Gem version.

### Changes

#### `PRERELEASE`

1. Update `PRERELEASE` to match the `SUMMARY` in the branch name.
2. `rake spec`
3.  Verify the specs pass, which indicates that `PRERELEASE` was updated correctly.
4. Commit the change `git commit -a`

#### Your changes

Make your changes or however many commits you like, commiting each with `git commit`.

#### `VERSION`

Following the rules for [semantic versioning 2.0](http://semver.org/spec/v2.0.0.html), update [`MINOR`](lib/metasploit/model/version.rb) and [`PATCH`](lib/metasploit/model/version.rb) and commit the changes.

##### Compatible changes

If your change are compatible with the previous branch's API, then increment [`PATCH`](lib/metasploit/model/version.rb).

##### Incompatible changes

If your changes are incompatible with the previous branch's API, then increment
[`MINOR`](lib/metasploit/model/version.rb) and reset [`PATCH`](lib/metasploit/model/version.rb) to `0`.

#### Pre-Pull Request Testing

1. Run specs one last time before opening the Pull Request: `rake spec`
2. Verify there was no failures.

#### Push

Push your branch to your fork on gitub: `git push push TYPE/ISSUE/SUMMARY`

#### Pull Request

* [Create new Pull Request](https://github.com/rapid7/metasploit-model/compare/)
* Add a Verification Steps comment

```
# Verification Steps

- [ ] `bundle install`

## `rake spec`
- [ ] `rake spec`
- [ ] VERIFY no failures
```
You should also include at least one scenario to manually check the changes outside of specs.

* Add a Post-merge Steps comment

The 'Post-merge Steps' are a reminder to the reviewer of the Pull Request of how to update the [`PRERELEASE`](lib/metasploit/model/version.rb) so that [version_spec.rb](spec/lib/metasploit/model/version_spec.rb) passes on the target branch after the merge.

DESTINATION is the name of the destination branch into which the merge is being made.  SOURCE_SUMMARY is the SUMMARY from TYPE/ISSUE/SUMMARY branch name for the SOURCE branch that is being made.

When merging to `master`:

```
# Post-merge Steps

Perform these steps prior to pushing to master or the build will be broke on master.

## Version
- [ ] Edit `lib/metasploit/model/version.rb`
- [ ] Remove `PRERELEASE` and its comment as `PRERELEASE` is not defined on master.

## Gem build
- [ ] gem build *.gemspec
- [ ] VERIFY the gem has no '.pre' version suffix.

## RSpec
- [ ] `rake spec`
- [ ] VERIFY version examples pass without failures

## Commit & Push
- [ ] `git commit -a`
- [ ] `git push origin master`
```

When merging to DESTINATION other than `master`:

```
# Post-merge Steps

Perform these steps prior to pushing to DESTINATION or the build will be broke on DESTINATION.

## Version
- [ ] Edit `lib/metasploit/model/version.rb`
- [ ] Change `PRELEASE` from `SOURCE_SUMMARY` to `DESTINATION_SUMMARY` to match the branch (DESTINATION) summary (DESTINATION_SUMMARY)

## Gem build
- [ ] gem build *.gemspec
- [ ] VERIFY the prerelease suffix has change on the gem.

## RSpec
- [ ] `rake spec`
- [ ] VERIFY version examples pass without failures

## Commit & Push
- [ ] `git commit -a`
- [ ] `git push origin master`
```

* Add a 'Release Steps' comment

The 'Post-merge Steps' are a reminder to the reviewer of the Pull Request of how to release the gem.

```
# Release

Complete these steps on DESTINATION

### JRuby
- [ ] `rvm use jruby@metasploit-model`
- [ ] `rm Gemfile.lock`
- [ ] `bundle install`
- [ ] `rake release`

## MRI Ruby
- [ ] `rvm use ruby-1.9.3@metasploit-model`
- [ ] `rm Gemfile.lock`
- [ ] `bundle install`
- [ ] `rake release`
```

#### Downstream dependencies

When releasing new versions, the following projects may need to be updated:

* [metasploit_data_models](https://github.com/rapid7/metasploit_data_models)
* [metasploit-credential](https://github/com/rapid7/metasploit-credential)
