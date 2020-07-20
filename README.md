# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

```ruby
def send_todos_csv(todos)
    header = CSV_COLUMNS
    csv_form = []
    csv_form << header
    todos.each do |todo|
      values = [todo.id,todo.title,todo.detail,todo.status,todo.note,todo.closed_on]
      csv_form << values
    end
    csv_change = csv_form.transpose
    csv_data = CSV.generate do |csv|
      csv << csv_change
    end
    send_data(csv_data, filename: "todos.csv")
  end


  def send_todos_csv(todos)
    csv_data = CSV.generate do |csv|
      header = CSV_COLUMNS
      csv << header
      todos.each do |todo|
        values = [todo.id,todo.title,todo.detail,todo.status,todo.note,todo.closed_on]
        csv << values
      end
    end
    send_data(csv_data, filename: "todos.csv")
  end
```
