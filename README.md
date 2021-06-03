# 課程管理系統
## Software Framework

Rails 4.2.4
Ruby 2.5.7

## Setup

#### 1. Clone

```bash
git clone git@github.com:KittyCake/course-management.git
```

#### 2. Setup Local Environment

##### 2.1 Install Ruby

Version 2.5.7

[RVM](https://rvm.io/)


```bash
# Install RVM

$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

$ \curl -sSL https://get.rvm.io | bash -s stable
$ rvm install 2.5.7
$ rvm use 2.5.7
```

##### 2.2 Install Rails

Version 5.2.6

```bash
gem install rails -v 5.2.6
```

##### 2.3 MySQL

```bash
$ brew install mysql@5.7
```

##### 2.4 NodeJS

Version: 15.X 

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
nvm install 15.X
nvm use 15.X
```

#### 3. Setup Config

##### Copy all example setting

```
database.yml 
```

#### 4. Setup Rails

```bash
bundle install
yarn install
rake db:create
rake db:migrate

# create default data
rake db:seed
```

#### 5. Start Server

```bash
rails s
bin/webpack-dev-server
```
Go to `http://localhost:3000` and you should see no error.
Go to `http://localhost:3000/apidoc` and you should see grape API doc.