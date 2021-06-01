# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
  category_params = [
    {
      id: 1,
      name: '語言'
    },
    {
      id: 2,
      name: '藝術'
    },
    {
      id: 3,
      name: '科技'
    },
    {
      id: 4,
      name: '程式語言'
    },
    {
      id: 5,
      name: '音樂'
    },
    {
      id: 6,
      name: '管理'
    },
    {
      id: 7,
      name: '生物'
    },
    {
      id: 8,
      name: '物理'
    },
    {
      id: 9 ,
      name: '化學'
    },
    {
      id: 10,
      name: '地球科學'
    },
    {
      id: 11,
      name: '地理'
    },
    {
      id: 12,
      name: '歷史'
    },
    {
      id: 13,
      name: '法律'
    },
    {
      id: 14,
      name: '數學'
    },
  ]

  course_params = [
    {
      name: '英語初級',
      category_id: 1,
      price: 500,
      currency: 1,
      for_sale: true,
      availability_period: 10,
      url: 'https://www.google.com',
      description: '大家來說英語',
    },
    {
      name: '重力加速度是什麼',
      category_id: 8,
      price: 300,
      currency: 1,
      for_sale: false,
      availability_period: 30,
      url: 'https://en.wikipedia.org/wiki/Gravitational_acceleration',
      description: '大家來學基本物理',
    },
    {
      name: 'Ruby on Rails 一天就上手',
      category_id: 4,
      price: 500,
      currency: 2,
      for_sale: true,
      availability_period: 25,
      url: 'https://rubygems.org/',
      description: '大家來學 Ruby',
    },
    {
      name: '貝多芬是誰？',
      category_id: 5,
      price: 100,
      currency: 4,
      for_sale: false,
      availability_period: 20,
      url: 'https://en.wikipedia.org/wiki/Ludwig_van_Beethoven',
      description: '大家來認識一下樂聖',
    },
    {
      name: '生命的奧秘',
      category_id: 7,
      price: 200,
      currency: 1,
      for_sale: true,
      availability_period: 21,
      url: 'https://www.books.com.tw/products/0010041537',
      description: '大家來學生物',
    },
  ]

  user_params = [
    {
      is_admin: true,
      email: 'kittychen@gmail.com',
      password: 'Test1234',
    },
    {
      email: 'JohnSmith@gmail.com',
      password: 'Smith1234',
    },
  ]

  category_params.each do |category_param|
    Category.find_or_create_by(category_param)
  end

  course_params.each do |course_param|
    Course.find_or_create_by(course_param)
  end
  
  user_params.each do |user_param|
    u = User.find_or_initialize_by(email: user_param[:email])
    u.is_admin = user_param[:is_admin] if user_param[:is_admin]
    u.password = user_param[:password]
    u.save!
  end

  all_course = Course.all
  all_users = User.all
  now = Time.now
  all_users.select { |user| user.is_admin == false }.each do |user|
    c = all_course.sample
    Order.find_or_create_by(
      user_id: user.id,
      course_id: c.id,
      price: c.price,
      expiration_date: now + c.availability_period,
      credit_card_number: '1243432143211234',
      credit_card_valid_thru_y: 2022,
      credit_card_valid_thru_m: 01,
      credit_card_verification: 123,
    )
  end
end
