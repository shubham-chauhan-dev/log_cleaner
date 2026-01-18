require_relative "lib/log_cleaner"

LogCleaner.configure do |c|
  c.mask_fields = [:email, :password, :card_number]
end

data = {
  user: { email: "john@gmail.com", password: "1234" },
  order: { card_number: "4242424242424242", amount: 500 },
  items: [{ name: "Book", price: 200 }]
}

LogCleaner.info(event: "order_create", data: data)
LogCleaner.debug(event: "order_create", data: data)
LogCleaner.warn(event: "order_create", data: data)
LogCleaner.error(event: "order_create", data: data)