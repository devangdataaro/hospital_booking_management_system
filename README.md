# Hospital Booking Management System

A comprehensive RESTful API system built with Laravel 13 for managing hospital bookings, doctor schedules, treatments, and patient appointments. This system includes advanced features like role-based access control, slot caching, and multi-currency treatment pricing.

## Features

- 🔐 **Authentication & Authorization** - Laravel Passport OAuth2 authentication with role-based permissions
- 👥 **User Management** - Support for Admin, Doctor, and Patient roles
- 🏥 **Treatment Management** - CRUD operations for medical treatments with multi-currency pricing
- 📅 **Slot Management** - Doctors can manage their availability slots
- 📋 **Booking System** - Patients can book available slots with real-time availability
- 🚀 **Caching** - Optimized available slots caching for better performance
- 🔑 **RBAC** - Fine-grained role and permission management
- 📊 **Postman Collection** - Included API testing collection

## System Requirements

Before installing, ensure your system meets these requirements:

- PHP >= 8.3
- Composer
- Node.js >= 18.x & NPM
- SQLite (default) or MySQL/PostgreSQL
- Git

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/devangdataaro/hospital_booking_management_system.git
cd hospital_booking_management_system
```

### 2. Install PHP Dependencies

```bash
composer install
```

### 3. Install Node Dependencies

```bash
npm install
```

### 4. Environment Configuration

Copy the example environment file and configure it:

```bash
cp .env.example .env
```

### 5. Generate Application Key

```bash
php artisan key:generate
```

### 6. Database Setup

#### Option A: Using SQLite (Default)

Create the SQLite database file:

```bash
touch database/database.sqlite
```

The `.env` file is already configured for SQLite:
```
DB_CONNECTION=sqlite
```

#### Option B: Using MySQL/PostgreSQL

Update your `.env` file with your database credentials:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=hospital_booking
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

### 7. Run Migrations

Create all database tables:

```bash
php artisan migrate
```

### 8. Install Laravel Passport

Generate OAuth2 encryption keys:

```bash
php artisan key:generate
php artisan passport:client --personal
```

**Important:** Save the Client ID and Client Secret from the output for API authentication.

### 9. Seed Database (Optional)

Seed the database with default roles, permissions, and sample data:

```bash
php artisan db:seed
```

This will create:
- Default roles (Admin, Doctor, Patient)
- Permissions for each role
- Sample users (optional)

### 10. Build Frontend Assets

```bash
npm run build
```

### 11. Start the Development Server

```bash
php artisan serve
```

The application will be available at: `http://localhost:8000`

### 12. Run Queue Worker (Optional)

If using queued jobs:

```bash
php artisan queue:work
```

## Quick Setup (Alternative)

Use the composer setup script for automated installation:

```bash
composer setup
```

This will automatically:
- Install dependencies
- Copy .env file
- Generate app key
- Run migrations
- Install npm packages
- Build assets

**Note:** You still need to run `php artisan passport:install` manually.

## Default User Roles & Permissions

After seeding, the following roles are available:

### Admin Role
- Full system access
- User management (`user.create`, `user.edit`)
- Treatment management (`treatment.create`, `treatment.edit`, `treatment.delete`)
- View all bookings (`booking.view-all`)
- Role & permission management

### Doctor Role
- Edit own profile (`user.edit`)
- Manage own slots (`slot.create`, `slot.view`)
- View assigned bookings (`booking.view`)
- Cancel bookings (`booking.cancel`)

### Patient Role
- Edit own profile (`user.edit`)
- Create bookings (no special permission required for public endpoint)

## API Documentation

### Base URL
```
http://localhost:8000/api
```

### Authentication

This API uses Laravel Passport for OAuth2 authentication.

#### Login
```http
POST /api/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "token": "your-access-token",
    "user": {...}
  }
}
```

#### Using the Token

Include the access token in subsequent requests:

```http
Authorization: Bearer your-access-token
```

### API Endpoints

#### Public Endpoints (No Authentication Required)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/login` | User login |
| GET | `/api/users` | List all users |
| GET | `/api/treatments` | List all treatments |
| GET | `/api/available-slots` | List available slots |
| POST | `/api/bookings` | Create a booking |

#### Protected Endpoints (Authentication Required)

**User Management**
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| POST | `/api/users` | `user.create` | Create new user (Admin) |
| PUT | `/api/users/profile` | `user.edit` | Edit own profile |

**Treatment Management**
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| POST | `/api/treatments` | `treatment.create` | Create treatment (Admin) |
| PUT | `/api/treatments/{id}` | `treatment.edit` | Update treatment (Admin) |
| DELETE | `/api/treatments/{id}` | `treatment.delete` | Delete treatment (Admin) |

**Slot Management**
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| POST | `/api/slots` | `slot.create` | Create/update slots (Doctor) |
| GET | `/api/slots` | `slot.view` | List own slots (Doctor) |

**Booking Management**
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| GET | `/api/bookings` | `booking.view` | List bookings |
| PUT | `/api/bookings/{id}/cancel` | `booking.cancel` | Cancel booking (Doctor) |

**Role & Permission Management**
| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| GET | `/api/roles` | `role.manage` | List all roles (Admin) |
| POST | `/api/roles` | `role.manage` | Create role (Admin) |
| PUT | `/api/roles/{id}` | `role.manage` | Update role (Admin) |
| DELETE | `/api/roles/{id}` | `role.manage` | Delete role (Admin) |
| POST | `/api/roles/assign` | `role.assign` | Assign role to user (Admin) |
| POST | `/api/roles/remove` | `role.assign` | Remove role from user (Admin) |
| GET | `/api/permissions` | `permission.manage` | List permissions (Admin) |
| GET | `/api/permissions/groups` | `permission.manage` | List permission groups (Admin) |
| POST | `/api/permissions` | `permission.manage` | Create permission (Admin) |

### Postman Collection

Import the included Postman collection for easy API testing:

```
Hospital Booking Management API (Passport).postman_collection.json
```

## Project Structure

```
hospital_booking_management_system/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/          # All API controllers
│   │   └── Middleware/       # Custom middleware
│   ├── Models/               # Eloquent models
│   │   ├── Booking.php
│   │   ├── Permission.php
│   │   ├── Role.php
│   │   ├── Slot.php
│   │   ├── Treatment.php
│   │   └── User.php
│   ├── Services/             # Business logic
│   │   └── AvailableSlotCache.php
│   └── Traits/               # Reusable traits
│       └── ApiResponse.php
├── database/
│   ├── factories/            # Model factories
│   ├── migrations/           # Database migrations
│   └── seeders/              # Database seeders
├── routes/
│   └── api.php              # API routes definition
└── tests/                   # PHPUnit tests
```

## Testing

Run the test suite:

```bash
php artisan test
```

Or with PHPUnit directly:

```bash
./vendor/bin/phpunit
```

## Development Commands

### Run Development Server with Hot Reload
```bash
composer dev
```

This starts:
- Laravel development server (port 8000)
- Queue worker
- Log viewer (Laravel Pail)
- Vite dev server for hot module reload

### Code Formatting
```bash
./vendor/bin/pint
```

### Clear Cache
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

### Optimize for Production
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## Environment Variables

Key environment variables in `.env`:

```env
# Application
APP_NAME=Hospital Booking Management System
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

# Database
DB_CONNECTION=sqlite

# Cache & Queue
CACHE_STORE=database
QUEUE_CONNECTION=database

# Optional: Currency Exchange API
EXCHANGE_RATE_API_KEY=your-api-key-here
```

## Troubleshooting

### Permission Denied Errors

```bash
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

### Database Connection Issues

Verify your `.env` database credentials and ensure the database exists:

```bash
# For SQLite
touch database/database.sqlite

# For MySQL
mysql -u root -p -e "CREATE DATABASE hospital_booking;"
```

### Passport Keys Not Found

Regenerate Passport keys:

```bash
php artisan passport:install --force
```

### Clear Application Cache

```bash
php artisan optimize:clear
```

## Security

- All passwords are hashed using bcrypt
- OAuth2 tokens for API authentication
- Role-based access control (RBAC)
- Middleware protection on sensitive routes
- CSRF protection enabled

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

## Support

For issues and questions:
- Open an issue on GitHub
- Email: devangdataaro@example.com

## Credits

Built with:
- [Laravel 13](https://laravel.com)
- [Laravel Passport](https://laravel.com/docs/passport)
- [PHP 8.3](https://www.php.net/)

---

**Developed by:** devangdataaro  
**Repository:** https://github.com/devangdataaro/hospital_booking_management_system
