# :wrench: COMMANDS

## Create a project

```sh
mix phx.new <projectName>
```

### with args

```sh
mix phx.new <projectName> -app <appName> -module <moduleName> -no-html
```
"-no-html" tells Phoenix to generate an API-only application, without HTML templates, views, and helpers. 

## Initialize PostgreSQL database

```sh
mix ecto.create
```

## Schemas & migrations

```sh
mix phx.gen.context <contextName> <schemaName> <tableName> <field>:<type> <field2>:<type>
```

### Example 
```sh
mix phx.gen.context Accounts User users first_name:string last_name:string
```

### Example with foreign key
```sh
mix phx.gen.context Tasks Task tasks title:string description:string status:string user_id:references:users
```

### Migration step 
```sh
mix ecto.migrate
```

##  Phenix console
```sh
iex -S mix phx.server
```

## Tests ( on Phenix console )
```sh
# Create a user
user = <YourApp>.Accounts.create_user(%{first_name: "John", last_name: "Doe"})

# Create a task associated with the user
task = <YourApp>.Tasks.create_task(%{title: "Sample Task", description: "Do something", status: "pending", user_id: user.id})

# Fetch the task and preload the associated user
task = <YourApp>.Tasks.get_task!(task.id)

# Check the associated user
task.user
```