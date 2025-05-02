# Rails Service

This is a minimal API-only Rails service for demonstration purposes.

## Setup

1. Install dependencies:
    ```sh
    bundle install
    ```
2. Create a new API-only Rails app (if not already created):
    ```sh
    rails new . --api --skip-bundle
    ```
3. Generate a simple controller:
    ```sh
    rails generate controller Health check
    ```
4. Edit `app/controllers/health_controller.rb` to return 'OK' for the `/health` endpoint:
    ```ruby
    class HealthController < ApplicationController
      def check
        render plain: 'OK'
      end
    end
    ```
5. Add to `config/routes.rb`:
    ```ruby
    get '/health', to: 'health#check'
    ```
6. (Optional, for inter-service calls) Add a `/chain` endpoint to `health_controller.rb` that calls the Python service's `/chain` endpoint:

    ```ruby
    require 'net/http'
    class HealthController < ApplicationController
      def check
        render plain: 'OK'
      end

      def chain
        host = ENV.fetch('PYTHON_SERVICE_HOST', 'python-service')
        port = ENV.fetch('PYTHON_SERVICE_PORT', '8080')
        url = URI("http://{host}:{port}/chain")
        begin
          resp = Net::HTTP.get(url)
          render plain: "Rails 1 Python → 1 Go: #{resp}"
        rescue => e
          render plain: "Error calling Python service: #{e}", status: 500
        end
      end
    end
    ```

    And add to `config/routes.rb`:

    ```ruby
    get '/chain', to: 'health#chain'
    ```

    Set the environment variables `PYTHON_SERVICE_HOST` and `PYTHON_SERVICE_PORT` in your deployment or Docker Compose file as needed.

## Running with Docker

```sh
docker build -t rails-service .
docker run -p 3000:3000 rails-service
```
