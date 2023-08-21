[![Gem Version](https://badge.fury.io/rb/locale_ninja.svg)](https://badge.fury.io/rb/locale_ninja)
[![Ruby on Rails CI](https://github.com/squadracer/locale_ninja/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/squadracer/locale_ninja/actions/workflows/rubyonrails.yml)

# 🥷 LocaleNinja

A Git-based gem to manage translations in your Ruby on Rails app.

Demo : https://ninja-local-test.osc-fr1.scalingo.io/

LocaleNinja simplifies the management of translations on a website. Unlike traditional solutions that require connecting to an external platform, LocaleNinja is a Git-based gem  installed directly in your project, allowing you to maintain full control over your translations without relying on a third-party service.

<br/>

## ✨ Key Features
**Streamlined Translation Management:** LocaleNinja provides a user-friendly interface to effortlessly handle all your website translations within the same project.

**Seamless Git Integration:** LocaleNinja connects to your Git repository and automatically handles pull and push of translation files. This ensures smooth collaboration with developers and simplifies the process of updating translations.

<br/>

## 💻 Installation
Add this line to your application's Gemfile:

```ruby
gem "locale_ninja"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install locale_ninja
```

<br/>

## ⚙️ Setup

To setup LocalNinja you will need to create a [github app](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app) in your repository, it will allow your app to commit to your repo. When you are on the github app form, here are some steps specific to our application to follow :

- In the "Identifying and authorizing users" section, your callback url will be : `your-domain-name.com/locale_ninja/github`
- In the "Webhook" section switch off the "active" checkbox
- In the "Permissions" section, you will have to:
    - Switch "Content" permissions to "Read and write"
    - Switch "Metadata" permissions to "Read-only"
    - Switch "Pull requests" permissions to "Read-only"
      
<br/>

Once done you will have access to your `CLIENT_ID` and `CLIENT_SECRET`. You can then run :

```sh
bin/rails g locale_ninja:install
```

Follow instructions.
This should create `config/initializers/locale_ninja.rb` :
```rb
LocaleNinja.configure do |config|
  config.plateform = :github
  config.repository = 'organisation/repository'
  config.branch_suffix = '__translations'
  config.client_id = 'CLIENT_ID'
  config.client_secret = 'CLIENT_SECRET'
end
```
We recommend to use rails credentials system to store your `CLIENT_SECRET`.
<br/>
For more info, check the rails guide [10 Environmental Security](https://edgeguides.rubyonrails.org/security.html#environmental-security).


You now just have to add this in your routes :
```ruby
#config/routes.rb
mount LocaleNinja::Engine => '/locale_ninja'
```
<br/>

Your  translation manager will be accessible at `your-domain-name/locale_ninja` or `localhost:3000/locale_ninja` 🎉

## 👥 Contributors 

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="25%"><a href="https://twitter.com/julienmarseil"><img src="https://avatars.githubusercontent.com/u/18447285?v=4" width="100px;" alt="Julien Marseille"/><br /><sub><b>Julien Marseille</b></sub></a></td>
      <td align="center" valign="top" width="25%"><a href="https://twitter.com/ClementAvenel"><img src="https://avatars.githubusercontent.com/u/29872940?v=4" width="100px;" alt="Clément Avenel"/><br /><sub><b>Clément Avenel</b></sub></a></td>
      <td align="center" valign="top" width="25%"><a href="https://www.linkedin.com/in/pierre-fitoussi-267133135/"><img src="https://avatars.githubusercontent.com/u/79254731?v=4" width="100px;" alt="Pierre Fitoussi"/><br /><sub><b>Pierre Fitoussi</b></sub></a></td>
      <td align="center" valign="top" width="25%"><a href="https://twitter.com/masterpoo_dev"><img src="https://avatars.githubusercontent.com/u/92919588?v=4" width="100px;" alt="Théo Dupuis"/><br /><sub><b>Théo Dupuis</b></sub></a></td>
    </tr>
</table>


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
