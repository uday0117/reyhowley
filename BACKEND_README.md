# ReyHowley - Laravel Backend

Backend API server for ReyHowley multi-vendor marketplace platform.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Server](#running-the-server)
- [API Documentation](#api-documentation)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

**Application:** ReyHowley Backend API  
**Framework:** Laravel  
**Version:** 3.6  
**Environment:** Production  
**URL:** https://reyhowley.com

ReyHowley backend is a robust Laravel-based API server that powers the multi-vendor marketplace for food, grocery, eCommerce, pharmacy, and parcel delivery services.

## ✨ Features

### Core Functionality
- 🏪 Multi-vendor store management
- 👥 User management and authentication
- 📦 Order management system
- 💳 Multiple payment gateway integration
- 📍 Zone-based service areas
- 🚚 Delivery management
- 💬 Real-time chat system (Pusher/Reverb)
- 🔔 Push notification system
- 📊 Analytics and reporting
- 🎟️ Coupon and discount system
- 💰 Wallet system
- ⭐ Review and rating system

### Technical Features
- RESTful API architecture
- JWT authentication
- Real-time websocket support
- File storage (Local/S3)
- Email notifications
- Database caching
- Queue management
- Rate limiting
- API versioning

## 📦 Prerequisites

### Required Software
- **PHP:** 8.1 or higher
- **Composer:** Latest version
- **MySQL:** 5.7 or higher / MariaDB 10.3+
- **Node.js:** 16+ (for asset compilation)
- **NPM/Yarn:** Latest version
- **Git**

### Recommended
- **Redis:** For caching and sessions (optional)
- **Supervisor:** For queue workers
- **Nginx/Apache:** Web server
- **SSL Certificate:** For HTTPS

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <backend-repository-url>
cd reyhowley-backend
```

### 2. Install PHP Dependencies

```bash
composer install
```

### 3. Install Node Dependencies

```bash
npm install
# or
yarn install
```

### 4. Environment Configuration

Copy the example environment file:

```bash
cp .env.example .env
```

Generate application key:

```bash
php artisan key:generate
```

## ⚙️ Configuration

### Environment Variables

Edit the `.env` file with your configuration:

#### Application Settings

```env
APP_NAME=ReyHowley
APP_ENV=production
APP_DEBUG=false
APP_INSTALL=true
APP_URL=https://reyhowley.com
APP_MODE=live
APP_VERSION=3.6
```

⚠️ **Important:** Set `APP_DEBUG=false` in production!

#### Database Configuration

```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=reyhowley
DB_USERNAME=reyhowley
DB_PASSWORD=MySuccess@6264
```

**Security Note:** Change the default database password before deployment!

#### Cache & Session

```env
BROADCAST_DRIVER=log
CACHE_DRIVER=database
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120
```

For better performance in production, consider:
- `CACHE_DRIVER=redis`
- `SESSION_DRIVER=redis`
- `QUEUE_CONNECTION=redis`

#### Redis Configuration (Optional but Recommended)

```env
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

#### Mail Configuration

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@reyhowley.com
MAIL_FROM_NAME=ReyHowley
```

**Gmail Setup:**
1. Enable 2-factor authentication
2. Generate an app-specific password
3. Use the app password in `MAIL_PASSWORD`

#### AWS S3 Configuration (Optional)

For cloud file storage:

```env
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-bucket-name
```

To use S3, also set:
```env
FILESYSTEM_DISK=s3
```

#### Pusher/Reverb Configuration (Real-time Features)

```env
REVERB_APP_ID=reyhowley
REVERB_APP_KEY=reyhowley
REVERB_APP_SECRET=reyhowley
REVERB_HOST=https://reyhowley.com
REVERB_PORT=6001
REVERB_SCHEME=https

PUSHER_APP_ID=reyhowley
PUSHER_APP_KEY=reyhowley
PUSHER_APP_SECRET=reyhowley
PUSHER_APP_CLUSTER=mt1
PUSHER_HOST=https://reyhowley.com
PUSHER_PORT=6001
PUSHER_SCHEME=https
```

#### OpenAI Configuration (Optional)

For AI-powered features:

```env
OPENAI_API_KEY=your-openai-api-key
OPENAI_ORGANIZATION=your-org-id
```

#### Software Activation

```env
SOFTWARE_ID=MzY3NzIxMTI=
BUYER_USERNAME=open_source
PURCHASE_CODE=open_source
SOFTWARE_VERSION=3.6
REACT_APP_KEY=45370351
```

## 🗄️ Database Setup

### 1. Create Database

```bash
mysql -u root -p
```

```sql
CREATE DATABASE reyhowley CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'reyhowley'@'localhost' IDENTIFIED BY 'MySuccess@6264';
GRANT ALL PRIVILEGES ON reyhowley.* TO 'reyhowley'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 2. Run Migrations

```bash
php artisan migrate
```

### 3. Seed Database (Optional)

```bash
php artisan db:seed
```

Or run specific seeders:
```bash
php artisan db:seed --class=UserSeeder
```

### 4. Storage Link

Create symbolic link for storage:

```bash
php artisan storage:link
```

## 🏃 Running the Server

### Development Server

```bash
php artisan serve
```

The server will start at `http://localhost:8000`

### Queue Workers (Background Jobs)

```bash
php artisan queue:work
```

For production, use Supervisor to manage queue workers.

### WebSocket Server (Reverb)

If using Laravel Reverb for real-time features:

```bash
php artisan reverb:start
```

### Scheduled Tasks

Add to crontab:

```bash
* * * * * cd /path-to-your-project && php artisan schedule:run >> /dev/null 2>&1
```

## 📚 API Documentation

### Base URL
```
https://reyhowley.com/api/v1
```

### Authentication
Most endpoints require authentication using Bearer token:

```
Authorization: Bearer {your-token}
```

### Key Endpoints

#### Authentication
- `POST /auth/sign-up` - User registration
- `POST /auth/login` - User login
- `POST /auth/social-login` - Social login
- `POST /auth/forgot-password` - Password reset
- `POST /auth/verify-token` - Verify reset token
- `POST /auth/reset-password` - Reset password

#### User/Customer
- `GET /customer/info` - Get user profile
- `POST /customer/update-profile` - Update profile
- `GET /customer/address/list` - List addresses
- `POST /customer/address/add` - Add address
- `PUT /customer/address/update/{id}` - Update address
- `DELETE /customer/address/delete?address_id={id}` - Delete address

#### Categories & Items
- `GET /categories` - List all categories
- `GET /categories/childes/{id}` - Get subcategories
- `GET /categories/items/{id}` - Get category items
- `GET /items/latest` - Latest items
- `GET /items/popular` - Popular items
- `GET /items/details/{id}` - Item details

#### Stores
- `GET /stores/get-stores` - List stores
- `GET /stores/popular` - Popular stores
- `GET /stores/latest` - Latest stores
- `GET /stores/details/{id}` - Store details
- `GET /stores/reviews` - Store reviews

#### Orders
- `POST /customer/order/place` - Place order
- `GET /customer/order/running-orders` - Active orders
- `GET /customer/order/list` - Order history
- `GET /customer/order/details?order_id={id}` - Order details
- `GET /customer/order/track?order_id={id}` - Track order
- `POST /customer/order/cancel` - Cancel order

#### Cart & Checkout
- `GET /coupon/list` - List coupons
- `GET /coupon/apply?code={code}` - Apply coupon

#### Notifications
- `GET /customer/notifications` - List notifications
- `POST /customer/cm-firebase-token` - Register FCM token

### Response Format

Success Response:
```json
{
  "success": true,
  "data": {},
  "message": "Success message"
}
```

Error Response:
```json
{
  "success": false,
  "errors": [],
  "message": "Error message"
}
```

## 🚀 Deployment

### Production Deployment Checklist

#### 1. Environment Setup
- [ ] Set `APP_ENV=production`
- [ ] Set `APP_DEBUG=false`
- [ ] Configure production database
- [ ] Set up Redis (recommended)
- [ ] Configure mail server
- [ ] Set up SSL certificate
- [ ] Configure backup strategy

#### 2. Optimization
```bash
# Cache configuration
php artisan config:cache

# Cache routes
php artisan route:cache

# Cache views
php artisan view:cache

# Optimize autoloader
composer install --optimize-autoloader --no-dev
```

#### 3. Security
- [ ] Change all default passwords
- [ ] Set strong `APP_KEY`
- [ ] Configure CORS properly
- [ ] Set up firewall rules
- [ ] Enable rate limiting
- [ ] Regular security updates
- [ ] Database backup automation

#### 4. Web Server Configuration

##### Nginx Example

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name reyhowley.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name reyhowley.com;
    root /var/www/reyhowley/public;

    ssl_certificate /path/to/ssl/cert.pem;
    ssl_certificate_key /path/to/ssl/key.pem;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

#### 5. Supervisor Configuration (Queue Workers)

Create `/etc/supervisor/conf.d/reyhowley-worker.conf`:

```ini
[program:reyhowley-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/reyhowley/artisan queue:work --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=4
redirect_stderr=true
stdout_logfile=/var/www/reyhowley/storage/logs/worker.log
stopwaitsecs=3600
```

Reload Supervisor:
```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start reyhowley-worker:*
```

## 🐛 Troubleshooting

### Common Issues

#### 1. 500 Internal Server Error

**Check Laravel logs:**
```bash
tail -f storage/logs/laravel.log
```

**Common causes:**
- Missing `.env` file
- Incorrect file permissions
- Missing dependencies
- Database connection issues

**Fix permissions:**
```bash
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

#### 2. Database Connection Failed

**Verify credentials:**
```bash
mysql -u reyhowley -p
```

**Check MySQL status:**
```bash
sudo systemctl status mysql
```

#### 3. Composer Dependencies Issues

```bash
composer clear-cache
rm -rf vendor composer.lock
composer install
```

#### 4. Storage Link Not Working

```bash
rm public/storage
php artisan storage:link
```

#### 5. Queue Jobs Not Processing

**Check queue worker:**
```bash
php artisan queue:work --tries=3
```

**Restart Supervisor:**
```bash
sudo supervisorctl restart reyhowley-worker:*
```

#### 6. Cache Issues

Clear all caches:
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
composer dump-autoload
```

### Performance Optimization

#### Enable OPcache

In `php.ini`:
```ini
opcache.enable=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
opcache.revalidate_freq=2
```

#### Database Indexing

Ensure proper indexes on frequently queried columns:
```sql
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);
```

## 📊 Monitoring & Maintenance

### Regular Tasks
- Monitor disk space
- Review error logs daily
- Database backup (automated)
- Security updates
- Performance monitoring
- API response time tracking

### Backup Strategy

**Database Backup:**
```bash
mysqldump -u reyhowley -p reyhowley > backup_$(date +%Y%m%d).sql
```

**Full Backup:**
```bash
tar -czf reyhowley_backup_$(date +%Y%m%d).tar.gz /var/www/reyhowley
```

### Log Management

**Rotate logs:**
```bash
php artisan log:clear
```

Consider using external log management tools like:
- Papertrail
- Loggly
- ELK Stack

## 🧪 Testing

### Run Tests
```bash
php artisan test
```

### Specific Test Suite
```bash
php artisan test --testsuite=Feature
php artisan test --testsuite=Unit
```

### Code Coverage
```bash
php artisan test --coverage
```

## 📄 License

This project is proprietary software. All rights reserved.

## 📞 Support

For backend technical support or server issues:
- Email: support@reyhowley.com
- Documentation: https://reyhowley.com/docs

## 🔗 Related Resources

- [Laravel Documentation](https://laravel.com/docs)
- [Frontend README](FRONTEND_README.md)
- [Backend Configuration](BACKEND_CONFIG.md)

---

**Last Updated:** February 15, 2026  
**Maintained by:** KR Solutions  
**Laravel Version:** Compatible with Laravel 10+
