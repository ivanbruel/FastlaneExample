Continuous Integration and Delivery with Fastlane
=========
[![Build Status](https://travis-ci.org/ivanbruel/FastlaneExample.svg?branch=master)](https://travis-ci.org/ivanbruel/FastlaneExample)

> fastlane is a tool for iOS and Android developers to automate tedious tasks like generating screenshots, dealing with provisioning profiles, and releasing your application. - Felix Krause @KrausFx

https://github.com/fastlane/fastlane

# NOTICE

In order to complete this workshop, due to what appears to be an issue with Two-factor authentication and geo-location based cookie session,  we cannot complete the deployment steps. As such I'd ask you to temporarily remove two-step authentication on https://appleid.apple.com/account/manage and turn it back on at the end of the workshop.

# Context

The goal of this workshop is to add continuous integration and delivery processes to a really simple app.

With this in mind, we will be configuring [fastlane](https://github.com/fastlane/fastlane) to do all the heavy lifting for us through a CI platform (e.g. Travis, Bitrise or Gitlab-CI).

# 0) Boilerplate

To make sure everyone understands how to add CI/CD processes to an app, we're providing some boilerplate code of an app which queries for a GitHub's user repos and sorts it by stars (based on Moya's example). This app is structured in an MVVM architecture alongside with RxSwift.

This app already contains both unit tests and UI tests in order to take advantage of a CI pipeline.

As such, be sure to fork this repo into your own account so you can manage the CI/CD pipeline.

# 1) Project Changes

Since the end-game is to publish the app to iTunes, we all need to change the bundle identifier of the app into something unique. (e.g. `xyz.swiftaveiro.ivanbruel.FastlaneExample`)

![Change scheme](http://i.imgur.com/qiLDeI8.png)

And then we have to create the app on the [Member Center portal](https://developer.apple.com/account/ios/certificate/) and then on [iTunes Connect](https://itunesconnect.apple.com/). Note: this is required in order to automatically manage the code signing with Fastlane's Match and to eventually deploy the app.

# 2) Installing Fastlane

Fastlane is a ruby gem, and as such requires a ruby environment setup on your mac. I recommend installing the latest stable version through RVM: `\curl -sSL https://get.rvm.io | bash -s stable --ruby`

In case that is sorted out, next we need to make sure that the `bundler` gem is installed to allows to setup a specific gem environment for this project.

`gem install bundler`

Since we now have bundler installed we can add the dependencies into a `Gemfile`

```
source 'https://rubygems.org'

gem 'fastlane'
gem 'cocoapods'

```

And finally install those dependencies with `bundle install`.

With fastlane installed, let's try initializing it:

`bundle exec fastlane init`

Fastlane will ask your for your Apple ID and your password which will be saved to the keychain of your mac.

`Your Apple ID (e.g. fastlane@krausefx.com): ivan.bruel@gmail.com`

`Password (for ivan.bruel@gmail.com): **********`

In case you have multiple teams select the one you created the app on and then confirm your app identifier. Also feel free to execute `echo 'itc_team_id "YOURTEAMID"' >> fastlane/Appfile'` to help out in future steps.

Be sure to remove the `cocoapods` call from the before_script, as we're pushing the cocoapods code to the git repo already.

# 3) CLI testing

In order to speed up unit testing let's remove the `FastlaneExample` target dependency from the `FastlaneExampleTests` target and set the host application to none.

![Remove Dependency](http://i.imgur.com/GZFywXE.png)
![Host app](http://i.imgur.com/6wPn14D.png)

In order for the CI to work we need to create a `FastlaneExampleTests` and a `FastlaneExampleUITests` scheme and make them shared.

![Create Schemes](http://i.imgur.com/Z6tj9Hu.png)
![Share](http://i.imgur.com/eRooJLJ.png)

Make sure to tick the `Run` on both test schemes

![Run](http://i.imgur.com/4RncnDZ.png)

Let's update the fastlane test lane into: `scan(scheme: "FastlaneExampleTests")` and execute it `bundle exec fastlane test`

Since it all seems to be working, we should add a UI testing lane to make sure our app is working correctly in regards to the UI as well.

```
desc "Runs all the UI tests"
lane :ui_test do
  scan(scheme: "FastlaneExampleUITests")
end
```

And execute it: `bundle exec fastlane ui_test`

# 4) Continuous Integration

Now that we can run tests locally, the next step is to run tests upon pushing code to the git remote. In order to to this let's take advantage of the open source free tier of [Travis](https://travis-ci.org/) and activate your fork of `FastlaneExample` in there.

Let's perform a simple setup that on every push it run all the tests.

Simply create a `.travis.yml` file with the following contents:

```
osx_image: xcode8.3
language: objective-c
install:
  - bundle install
script:
  - bundle exec fastlane test
  - bundle exec fastlane ui_test
```

And then push your code into your fork of `FastlaneExample`.
Check its progress under https://travis-ci.org/<YOUR_GITHUB_HANDLE>/FastlaneExample

# 5) Continuous Delivery

Now comes the hard part, after running tests, we want to finally deploy our app into iTunes Connect.

To make sure all your environment variables are safely stored in the CI and not visible to anyone, let's use the Travis CLI to encrypt it into the .travis.yml file.

`gem install travis` to install the travis gem.

and execute `travis encrypt FASTLANE_PASSWORD=<YOUR_APPLE_ID_PASSWORD> --add`

Fastlane has a sub-project called match, match automatically manages all the code signing profiles for you, the way Xcode was supposed to actually do.

Match requires an additional repo to store encrypted versions of your certificates and provisioning profiles. If possible I'd suggest you create a private repo on https://github.com/new but regardless, a public one should work out for the purpose of this workshop.

After creating the repo run `bundle exec fastlane match init` in order to setup the match gem. When it prompts for the repo url, paste your recently created repo (e.g. https://github.com/ivanbruel/FastlaneExampleMatch).

Now that we have Match setup, let's start creating the development and appstore profiles. Match will ask you for a password to encrypt certificates and provisioning profiles, be sure to save it and add it to the .travis.yml.

In order to take advantage of match's automatic code signing, we need to add `match(type: "appstore")` before `gym` in the beta and release lanes.

`travis encrypt MATCH_PASSWORD=<YOUR_MATCH_PASSWORD> --add`

Warning: https://docs.travis-ci.com/user/common-build-problems/#Mac%3A-macOS-Sierra-(10.12)-Code-Signing-Errors
Travis CI has some issues with the keychain "allow" popup, as such we need to add the following lines for match (instead of the simple command above):

```
create_keychain(
      name: "CI"
      password: ENV["MATCH_PASSWORD"],
      default_keychain: true,
      unlock: true,
      timeout: 3600,
      add_to_search_list: true
    )

    match(
      type: "appstore",
      keychain_name: "CI",
      keychain_password: ENV["MATCH_PASSWORD"],
      readonly: true
    )
```

Since we have brand new provisioning profiles and certificates, let's set them on Xcode by removing automatic manage signing and selecting the match generated profiles. You can test it and see if it compiles in debug mode.

Finally, since iTunes Connect is anal about incremental build numbers on build uploads, we should add `increment_build_number(build_number: Time.now.getutc.to_i)` to avoid having to do it manually everytime the CD runs. To make this work, be sure to change the versioning system to Apple Generic.

![versioning](http://i.imgur.com/gJ8VXsa.png)

Let's update `.travis.yml` and add `bundle exec fastlane release` after the ui_test lane.

# 6) Improvements

With fastlane you can always improve your workflow. Usually the first obvious improvement would be to apply GitFlow to our CI/CD pipeline, where we would test on every branch, but only deploy a beta version on the development branch and a release version on the master branch.
Integrations with Slack could also help getting some visibility in the pipeline.
Fabric deployment...
etc.

# Remarks

Here's an example of a build that got deployed https://travis-ci.org/ivanbruel/FastlaneExample/builds/238570562 and its code on the `test-run`  branch.
I've attached to this project Unbabel's iOS Fastfile and .gitlab-ci.yml that we currently use to shed some light on the topic!
Hope you enjoyed this workshop and feel free to ping @ivanbruel on twitter!
